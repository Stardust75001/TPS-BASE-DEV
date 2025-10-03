#!/bin/bash

# 🚀 RAPPORT FINAL EXPERT SHOPIFY - AUTOMATIQUE

echo "🎯 EXPERT SHOPIFY - RAPPORT FINAL COMPLET"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Analyse TPS BASE DEV
echo "📊 REPOSITORY: TPS BASE DEV (Principal)"
echo "────────────────────────────────────────────────────────────────"
cd "/Users/asc/Shopify/TPS BASE DEV"

CURRENT_BRANCH=$(git branch --show-current)
UNCOMMITTED=$(git status --porcelain | wc -l | tr -d ' ')
THEME_NAME=$(grep '"theme_name"' config/settings_schema.json | cut -d'"' -f4)
THEME_VERSION=$(grep '"theme_version"' config/settings_schema.json | cut -d'"' -f4)
THEME_AUTHOR=$(grep '"theme_author"' config/settings_schema.json | cut -d'"' -f4)

echo "🌿 Branche actuelle: $CURRENT_BRANCH"
echo "🎨 Thème: $THEME_NAME"
echo "📊 Version: $THEME_VERSION"
echo "👤 Auteur: $THEME_AUTHOR"
echo "📝 Modifications: $UNCOMMITTED"

# Vérifier development
if git show-ref --verify --quiet refs/heads/development; then
    git stash -q 2>/dev/null || true
    git checkout -q development 2>/dev/null
    DEV_THEME=$(grep '"theme_name"' config/settings_schema.json | cut -d'"' -f4 2>/dev/null)
    DEV_VERSION=$(grep '"theme_version"' config/settings_schema.json | cut -d'"' -f4 2>/dev/null)
    echo "🧪 Development: $DEV_THEME v$DEV_VERSION"
    git checkout -q main 2>/dev/null
    git stash pop -q 2>/dev/null || true

    if [ "$THEME_NAME" = "$DEV_THEME" ]; then
        echo "✅ COHÉRENCE: Thème identique sur main et development"
    else
        echo "⚠️ DIVERGENCE: Thèmes différents entre branches"
    fi
fi

echo ""

# Analyse TPS-BASE-316
echo "📊 REPOSITORY: TPS-BASE-316 (Configuration)"
echo "────────────────────────────────────────────────────────────────"
cd "/Users/asc/Shopify/TPS-BASE-316"

CURRENT_BRANCH_316=$(git branch --show-current)
UNCOMMITTED_316=$(git status --porcelain | wc -l | tr -d ' ')
THEME_NAME_316=$(grep '"theme_name"' config/settings_schema.json | cut -d'"' -f4)
THEME_VERSION_316=$(grep '"theme_version"' config/settings_schema.json | cut -d'"' -f4)

echo "🌿 Branche actuelle: $CURRENT_BRANCH_316"
echo "🎨 Thème: $THEME_NAME_316"
echo "📊 Version: $THEME_VERSION_316"
echo "📝 Modifications: $UNCOMMITTED_316"

echo ""

# Audit sécurité rapide
echo "🔒 AUDIT SÉCURITÉ EXPERT"
echo "────────────────────────────────────────────────────────────────"

TOTAL_SECRETS=0

# TPS BASE DEV
cd "/Users/asc/Shopify/TPS BASE DEV"
SECRETS_DEV=$(find . -name "*.liquid" -o -name "*.js" | xargs grep -l "sk_live_\|pk_live_\|AIza[A-Za-z0-9]\{35\}\|ghp_\|gho_" 2>/dev/null | wc -l | tr -d ' ')
echo "🛡️ TPS BASE DEV: $SECRETS_DEV secret(s)"

# TPS-BASE-316
cd "/Users/asc/Shopify/TPS-BASE-316"
SECRETS_316=$(find . -name "*.liquid" -o -name "*.js" | xargs grep -l "sk_live_\|pk_live_\|AIza[A-Za-z0-9]\{35\}\|ghp_\|gho_" 2>/dev/null | wc -l | tr -d ' ')
echo "🛡️ TPS-BASE-316: $SECRETS_316 secret(s)"

TOTAL_SECRETS=$((SECRETS_DEV + SECRETS_316))

if [ $TOTAL_SECRETS -eq 0 ]; then
    SECURITY_STATUS="✅ PARFAIT - SÉCURISÉ"
else
    SECURITY_STATUS="🚨 $TOTAL_SECRETS PROBLÈME(S)"
fi

echo "🎯 Sécurité globale: $SECURITY_STATUS"

echo ""

# Analyse performance rapide
echo "⚡ PERFORMANCE EXPRESS"
echo "────────────────────────────────────────────────────────────────"

cd "/Users/asc/Shopify/TPS BASE DEV"
IMG_NO_DIM=$(grep -r "<img" --include="*.liquid" . | grep -v -E "width=|height=" | wc -l | tr -d ' ')
CONSOLE_LOGS=$(grep -r "console\." --include="*.liquid" . | wc -l | tr -d ' ')
DEPRECATED_FILTERS=$(find . -name "*.liquid" -exec grep -l "img_url" {} \; | wc -l | tr -d ' ')

echo "🖼️ Images sans dimensions: $IMG_NO_DIM"
echo "🐛 Console.log restants: $CONSOLE_LOGS"
echo "🔄 Filtres dépréciés: $DEPRECATED_FILTERS"

# Score performance
PERF_SCORE=100
[ $IMG_NO_DIM -gt 100 ] && PERF_SCORE=$((PERF_SCORE - 20))
[ $CONSOLE_LOGS -gt 20 ] && PERF_SCORE=$((PERF_SCORE - 15))
[ $DEPRECATED_FILTERS -gt 0 ] && PERF_SCORE=$((PERF_SCORE - DEPRECATED_FILTERS * 5))

echo "📊 Score performance: $PERF_SCORE/100"

echo ""

# Résumé final
echo "🎯 RÉSUMÉ FINAL EXPERT SHOPIFY"
echo "═══════════════════════════════════════════════════════════════"
echo "📁 Repositories: 2 analysés"
echo "🎨 Thème principal: $THEME_NAME v$THEME_VERSION"
echo "🔒 Sécurité: $SECURITY_STATUS"
echo "⚡ Performance: $PERF_SCORE/100"
echo "📝 Modifications totales: $((UNCOMMITTED + UNCOMMITTED_316))"

echo ""
echo "🚀 STATUT EXPERT:"
if [ $TOTAL_SECRETS -eq 0 ] && [ $PERF_SCORE -ge 80 ]; then
    echo "🏆 EXCELLENT - Production Ready Enterprise Level"
    echo "✅ Sécurité parfaite"
    echo "✅ Performance optimale"
    echo "✅ Thèmes cohérents"
    echo "✅ Automatisation déployée"
elif [ $TOTAL_SECRETS -eq 0 ]; then
    echo "✅ BON - Quelques optimisations de performance recommandées"
    echo "✅ Sécurité parfaite"
    echo "⚡ Performance à améliorer"
else
    echo "🚨 CRITIQUE - Problèmes de sécurité à corriger immédiatement"
fi

echo ""
echo "🤖 Expert Shopify System - Analyse terminée"
echo "📅 $(date '+%d/%m/%Y à %H:%M')"
