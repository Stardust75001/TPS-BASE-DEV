#!/bin/bash

# 🚀 EXPERT SHOPIFY - RAPPORT FINAL AUTOMATIQUE
# Analyse complète sans configuration

echo "🚀 EXPERT SHOPIFY - ANALYSE COMPLÈTE"
echo "════════════════════════════════════════════════════════════════"

# Analyse TPS BASE DEV
echo ""
echo "📊 REPOSITORY: TPS BASE DEV"
echo "────────────────────────────────────────────────────────────────"
cd "/Users/asc/Shopify/TPS BASE DEV"

# Branche actuelle
CURRENT_BRANCH=$(git branch --show-current)
echo "🌿 Branche actuelle: $CURRENT_BRANCH"

# Thème sur main
if [ -f "config/settings_schema.json" ]; then
    MAIN_THEME=$(grep '"theme_name"' config/settings_schema.json | cut -d'"' -f4 2>/dev/null)
    MAIN_VERSION=$(grep '"theme_version"' config/settings_schema.json | cut -d'"' -f4 2>/dev/null)
    MAIN_AUTHOR=$(grep '"theme_author"' config/settings_schema.json | cut -d'"' -f4 2>/dev/null)

    echo "🎨 THÈME MAIN:"
    echo "   Nom: $MAIN_THEME"
    echo "   Version: $MAIN_VERSION"
    echo "   Auteur: $MAIN_AUTHOR"
fi

# Vérifier development
if git show-ref --verify --quiet refs/heads/development; then
    git stash -q 2>/dev/null || true
    git checkout -q development 2>/dev/null

    if [ -f "config/settings_schema.json" ]; then
        DEV_THEME=$(grep '"theme_name"' config/settings_schema.json | cut -d'"' -f4 2>/dev/null)
        DEV_VERSION=$(grep '"theme_version"' config/settings_schema.json | cut -d'"' -f4 2>/dev/null)

        echo "🧪 THÈME DEVELOPMENT:"
        echo "   Nom: $DEV_THEME"
        echo "   Version: $DEV_VERSION"

        # Comparaison
        if [ "$MAIN_THEME" != "$DEV_THEME" ]; then
            echo "⚠️  DIFFÉRENCE: Thèmes différents entre main et development"
        else
            echo "✅ COHÉRENCE: Même thème sur main et development"
        fi
    fi

    git checkout -q main 2>/dev/null
    git stash pop -q 2>/dev/null || true
else
    echo "ℹ️  Pas de branche development"
fi

# Statut des modifications
UNCOMMITTED=$(git status --porcelain | wc -l | tr -d ' ')
echo "📝 Modifications non commitées: $UNCOMMITTED"

# Analyse TPS-BASE-316
echo ""
echo "📊 REPOSITORY: TPS-BASE-316"
echo "────────────────────────────────────────────────────────────────"
cd "/Users/asc/Shopify/TPS-BASE-316"

CURRENT_BRANCH_316=$(git branch --show-current)
echo "🌿 Branche actuelle: $CURRENT_BRANCH_316"

if [ -f "config/settings_schema.json" ]; then
    THEME_316=$(grep '"theme_name"' config/settings_schema.json | cut -d'"' -f4 2>/dev/null)
    VERSION_316=$(grep '"theme_version"' config/settings_schema.json | cut -d'"' -f4 2>/dev/null)
    AUTHOR_316=$(grep '"theme_author"' config/settings_schema.json | cut -d'"' -f4 2>/dev/null)

    echo "🎨 THÈME:"
    echo "   Nom: $THEME_316"
    echo "   Version: $VERSION_316"
    echo "   Auteur: $AUTHOR_316"
fi

UNCOMMITTED_316=$(git status --porcelain | wc -l | tr -d ' ')
echo "📝 Modifications non commitées: $UNCOMMITTED_316"

# Analyse sécurité express
echo ""
echo "🔒 AUDIT SÉCURITÉ EXPRESS"
echo "────────────────────────────────────────────────────────────────"

TOTAL_SECRETS=0

# TPS BASE DEV
cd "/Users/asc/Shopify/TPS BASE DEV"
SECRETS_DEV=$(find . -name "*.liquid" -o -name "*.js" | xargs grep -l "sk_live_\|pk_live_\|AIza[A-Za-z0-9]\{35\}\|ghp_\|gho_" 2>/dev/null | wc -l | tr -d ' ')
echo "🛡️  TPS BASE DEV: $SECRETS_DEV secret(s) détecté(s)"
TOTAL_SECRETS=$((TOTAL_SECRETS + SECRETS_DEV))

# TPS-BASE-316
cd "/Users/asc/Shopify/TPS-BASE-316"
SECRETS_316=$(find . -name "*.liquid" -o -name "*.js" | xargs grep -l "sk_live_\|pk_live_\|AIza[A-Za-z0-9]\{35\}\|ghp_\|gho_" 2>/dev/null | wc -l | tr -d ' ')
echo "🛡️  TPS-BASE-316: $SECRETS_316 secret(s) détecté(s)"
TOTAL_SECRETS=$((TOTAL_SECRETS + SECRETS_316))

if [ $TOTAL_SECRETS -eq 0 ]; then
    echo "✅ SÉCURITÉ: Aucun secret exposé - PARFAIT"
else
    echo "🚨 ALERTE: $TOTAL_SECRETS secret(s) exposé(s) - ACTION REQUISE"
fi

# Résumé final
echo ""
echo "🎯 RÉSUMÉ EXPERT SHOPIFY"
echo "════════════════════════════════════════════════════════════════"
echo "📁 Repositories analysés: 2"
echo "🎨 Thèmes identifiés:"
echo "   • Main: $MAIN_THEME v$MAIN_VERSION"
echo "   • Dev: $DEV_THEME v$DEV_VERSION"
echo "   • 316: $THEME_316 v$VERSION_316"
echo "🔒 Sécurité: $([ $TOTAL_SECRETS -eq 0 ] && echo "✅ SÉCURISÉ" || echo "🚨 $TOTAL_SECRETS PROBLÈME(S)")"
echo "📝 Modifications: TPS-DEV($UNCOMMITTED) | TPS-316($UNCOMMITTED_316)"

# Recommandation expert
echo ""
echo "🚀 RECOMMANDATION EXPERT:"
if [ $TOTAL_SECRETS -eq 0 ] && [ $UNCOMMITTED -eq 0 ] && [ $UNCOMMITTED_316 -eq 0 ]; then
    echo "✅ PARFAIT - Tous vos repositories sont sécurisés et synchronisés"
    echo "🏆 Prêt pour la production"
elif [ $TOTAL_SECRETS -gt 0 ]; then
    echo "🚨 CRITIQUE - Corriger les secrets exposés IMMÉDIATEMENT"
    echo "💡 Utiliser les variables d'environnement Shopify"
elif [ $UNCOMMITTED -gt 0 ] || [ $UNCOMMITTED_316 -gt 0 ]; then
    echo "📝 Push recommandé pour synchroniser les modifications"
    echo "💡 Utiliser: ./instant-deploy.sh"
fi

echo ""
echo "🤖 Analyse terminée - Expert Shopify System"
