#!/bin/bash

# 🚀 WORKFLOW SHOPIFY SIMPLIFIÉ
# ===============================

echo "🚀 DAILY SHOPIFY WORKFLOW - $(date)"
echo "===================================="
echo

# 1. SÉCURITÉ
echo "🔒 1. AUDIT SÉCURITÉ"
echo "=================="

live_keys=$(grep -r "sk_live_\|pk_live_" --include="*.liquid" --include="*.js" snippets/ sections/ templates/ assets/ 2>/dev/null | wc -l | tr -d ' ')
api_keys=$(grep -r "AIza[A-Za-z0-9]\{35\}" --include="*.liquid" --include="*.js" snippets/ sections/ templates/ assets/ 2>/dev/null | wc -l | tr -d ' ')

if [ "$live_keys" -eq 0 ] && [ "$api_keys" -eq 0 ]; then
    echo "✅ SÉCURISÉ: Aucun secret critique exposé"
else
    echo "❌ CRITIQUE: $((live_keys + api_keys)) secrets exposés!"
fi
echo

# 2. JSON VALIDATION
echo "📝 2. VALIDATION JSON"
echo "==================="

json_errors=0
for file in locales/*.json; do
    if python3 -m json.tool "$file" > /dev/null 2>&1; then
        echo "✅ $(basename $file)"
    else
        echo "❌ $(basename $file) - ERREUR SYNTAXE"
        json_errors=$((json_errors + 1))
    fi
done

if [ "$json_errors" -eq 0 ]; then
    echo "🎉 Tous les JSON sont valides"
fi
echo

# 3. PERFORMANCE
echo "⚡ 3. PERFORMANCE CHECK"
echo "===================="

# Images sans dimensions
images_no_dims=$(grep -r "<img" --include="*.liquid" snippets/ sections/ 2>/dev/null | grep -v -E "width=|height=" | wc -l | tr -d ' ')
echo "🖼️ Images sans dimensions: $images_no_dims"

# Console logs
console_logs=$(grep -r "console\." --include="*.liquid" snippets/ sections/ 2>/dev/null | wc -l | tr -d ' ')
echo "🐛 Console statements: $console_logs"

# Filtres dépréciés
deprecated_filters=$(find . -name "*.liquid" -not -path "./backup*" -exec grep -l "img_url" {} \; 2>/dev/null | wc -l | tr -d ' ')
echo "🔄 Filtres img_url: $deprecated_filters"
echo

# 4. GIT STATUS
echo "📁 4. GIT STATUS"
echo "==============="

uncommitted=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
echo "📝 Fichiers modifiés: $uncommitted"
echo

# 5. SCORE FINAL
echo "🎯 5. SCORE FINAL"
echo "================"

score=100

# Sécurité critique
score=$((score - live_keys * 50))
score=$((score - api_keys * 30))

# JSON errors bloquants
score=$((score - json_errors * 20))

# Performance impact
if [ "$images_no_dims" -gt 100 ]; then
    score=$((score - 15))
fi

if [ "$console_logs" -gt 50 ]; then
    score=$((score - 10))
fi

if [ "$deprecated_filters" -gt 0 ]; then
    score=$((score - 5))
fi

# Résultat
if [ "$score" -ge 90 ]; then
    echo "🎉 EXCELLENT: Score $score/100 - Production Ready!"
elif [ "$score" -ge 70 ]; then
    echo "⚠️ BON: Score $score/100 - Optimisations recommandées"
else
    echo "❌ CRITIQUE: Score $score/100 - Corrections requises"
fi

echo
echo "✅ Workflow terminé - $(date)"
echo "==============================="
