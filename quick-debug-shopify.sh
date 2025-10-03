#!/bin/bash

# 🚀 QUICK DEBUG - TPS BASE DEV
# =============================
# Script de validation rapide (5 min) pour audit complet thème Shopify
# Usage: ./quick-debug-shopify.sh

echo "🚀 QUICK DEBUG TPS BASE DEV - $(date)"
echo "====================================="

error_count=0
warning_count=0

# 1. Theme Check
echo ""
echo "1. 🔍 THEME CHECK..."
if command -v ~/.rbenv/shims/theme-check >/dev/null; then
    theme_issues=$(~/.rbenv/shims/theme-check --list 2>/dev/null | wc -l || echo "0")
    echo "   📊 Issues détectées: $theme_issues"
    if [ "$theme_issues" -gt 50 ]; then
        echo "   ⚠️ ATTENTION: Beaucoup d'issues theme-check"
        ((warning_count++))
    fi
else
    echo "   ❌ theme-check non installé"
    ((error_count++))
fi

# 2. JSON Locales Validation
echo ""
echo "2. 📝 JSON LOCALES VALIDATION..."
json_errors=0
for file in locales/*.json; do
    if [ -f "$file" ]; then
        if python3 -m json.tool "$file" > /dev/null 2>&1; then
            echo "   ✅ $(basename $file) - JSON valide"
        else
            echo "   ❌ $(basename $file) - JSON INVALIDE"
            ((json_errors++))
            ((error_count++))
        fi
    fi
done

if [ $json_errors -eq 0 ]; then
    echo "   🎉 Tous les fichiers JSON locales sont valides"
fi

# 3. Images Dimensions Check
echo ""
echo "3. 🖼️ IMAGES DIMENSIONS..."
missing_dimensions=$(grep -r "<img" --include="*.liquid" snippets/ sections/ templates/ 2>/dev/null | grep -v 'width=\|height=' | wc -l)
total_images=$(grep -r "<img" --include="*.liquid" snippets/ sections/ templates/ 2>/dev/null | wc -l)

echo "   📊 Images totales: $total_images"
echo "   📊 Images sans dimensions: $missing_dimensions"

if [ "$missing_dimensions" -gt 0 ]; then
    echo "   ⚠️ $missing_dimensions images sans width/height (impact SEO/CLS)"
    ((warning_count++))
else
    echo "   ✅ Toutes les images ont des dimensions explicites"
fi

# 4. Loading Attributes Check
loading_lazy=$(grep -r "loading=" --include="*.liquid" snippets/ sections/ templates/ 2>/dev/null | wc -l)
echo "   📊 Images avec loading attribute: $loading_lazy"

if [ "$loading_lazy" -gt 0 ]; then
    echo "   ✅ Images optimisées avec loading attributes"
else
    echo "   ⚠️ Aucun attribut loading détecté (opportunité perf)"
    ((warning_count++))
fi

# 5. Sécurité - Secrets Scan
echo ""
echo "4. 🔒 SÉCURITÉ - SCAN SECRETS..."
exposed_secrets=$(grep -r "sk_test\|pk_test\|password.*=\|secret.*=\|token.*=" --include="*.liquid" --include="*.js" snippets/ sections/ templates/ assets/ 2>/dev/null | wc -l)

if [ "$exposed_secrets" -eq 0 ]; then
    echo "   ✅ Aucun secret exposé détecté"
else
    echo "   ❌ $exposed_secrets secrets potentiellement exposés"
    echo "   🚨 CRITIQUE: Vérifiez immédiatement les secrets exposés"
    ((error_count++))
fi

# 6. Console.log Debug
echo ""
echo "5. 🐛 CONSOLE.LOG DEBUG..."
console_logs=$(grep -r "console\." --include="*.js" --include="*.liquid" assets/ snippets/ sections/ 2>/dev/null | wc -l)

if [ "$console_logs" -eq 0 ]; then
    echo "   ✅ Pas de console.log oubliés"
else
    echo "   ⚠️ $console_logs console.log trouvés (à nettoyer pour prod)"
    ((warning_count++))
fi

# 7. Deprecated Filters Check
echo ""
echo "6. 🔄 DEPRECATED FILTERS..."
deprecated_filters=$(grep -r "img_url" --include="*.liquid" snippets/ sections/ templates/ 2>/dev/null | wc -l)

if [ "$deprecated_filters" -eq 0 ]; then
    echo "   ✅ Aucun filtre img_url déprécié"
else
    echo "   ⚠️ $deprecated_filters utilisations img_url (remplacer par image_url)"
    ((warning_count++))
fi

# 8. Headings Structure
echo ""
echo "7. ♿ ACCESSIBILITÉ - HEADINGS..."
headings=$(grep -rE "<h[1-6]" --include="*.liquid" sections/ templates/ layout/ 2>/dev/null | wc -l)
h1_count=$(grep -rE "<h1" --include="*.liquid" sections/ templates/ layout/ 2>/dev/null | wc -l)

echo "   📊 Headings totaux: $headings"
echo "   📊 H1 détectés: $h1_count"

if [ "$h1_count" -gt 3 ]; then
    echo "   ⚠️ Trop de H1 détectés (SEO: 1 seul H1 recommandé par page)"
    ((warning_count++))
elif [ "$h1_count" -eq 0 ]; then
    echo "   ⚠️ Aucun H1 détecté (structure SEO manquante)"
    ((warning_count++))
else
    echo "   ✅ Structure H1 semble correcte"
fi

# 9. Git Status Check
echo ""
echo "8. 📁 GIT STATUS..."
if git status --porcelain 2>/dev/null | grep -q .; then
    uncommitted=$(git status --porcelain 2>/dev/null | wc -l)
    echo "   ⚠️ $uncommitted fichiers non committés"
    ((warning_count++))
    echo "   📝 Files à committer:"
    git status --porcelain 2>/dev/null | head -5
else
    echo "   ✅ Git clean - tous les fichiers committés"
fi

# 10. Performance Quick Check
echo ""
echo "9. ⚡ PERFORMANCE HINTS..."

# CSS !important check
important_usage=$(grep -r "!important" --include="*.css" --include="*.scss" assets/ 2>/dev/null | wc -l)
echo "   📊 Utilisations !important: $important_usage"

if [ "$important_usage" -gt 10 ]; then
    echo "   ⚠️ Beaucoup de !important (optimisation CSS recommandée)"
    ((warning_count++))
fi

# Assets count
css_files=$(find assets/ -name "*.css" -o -name "*.scss" 2>/dev/null | wc -l)
js_files=$(find assets/ -name "*.js" 2>/dev/null | wc -l)
echo "   📊 Fichiers CSS/SCSS: $css_files"
echo "   📊 Fichiers JS: $js_files"

# RÉSUMÉ FINAL
echo ""
echo "🎯 RÉSUMÉ AUDIT COMPLET"
echo "======================="

if [ $error_count -eq 0 ] && [ $warning_count -eq 0 ]; then
    echo "🟢 EXCELLENT - Aucune erreur critique détectée"
    echo "✅ Thème prêt pour production"
elif [ $error_count -eq 0 ]; then
    echo "🟡 BON - $warning_count warnings à optimiser"
    echo "✅ Thème déployable, optimisations recommandées"
else
    echo "🔴 ATTENTION - $error_count erreurs critiques"
    echo "❌ Corrections requises avant déploiement"
fi

echo ""
echo "📊 SCORE DÉTAILLÉ:"
echo "   🔴 Erreurs critiques: $error_count"
echo "   🟡 Warnings: $warning_count"
echo "   ✅ Checks réussis: $((9 - error_count - (warning_count > 0 ? 1 : 0)))/9"

# Score global
total_checks=9
if [ $error_count -eq 0 ] && [ $warning_count -eq 0 ]; then
    score=100
elif [ $error_count -eq 0 ]; then
    score=$((90 - warning_count * 5))
else
    score=$((70 - error_count * 10 - warning_count * 2))
fi

if [ $score -lt 0 ]; then score=0; fi

echo "   🎯 Score global: $score/100"

echo ""
echo "🔧 ACTIONS RECOMMANDÉES:"

if [ $error_count -gt 0 ]; then
    echo "1. 🚨 PRIORITÉ CRITIQUE: Corriger les erreurs détectées"
fi

if [ $warning_count -gt 0 ]; then
    echo "2. ⚡ OPTIMISATIONS: Traiter les warnings pour améliorer les performances"
fi

echo "3. 📋 CHECKLIST: Consulter CHECKLIST-DEBUG-SHOPIFY.md pour détails"
echo "4. 🛠️ TOOLS: Lancer ./auto-fix-theme-check.sh pour corrections automatiques"

echo ""
echo "✅ Quick debug completed! $(date)"
echo ""

exit $error_count
