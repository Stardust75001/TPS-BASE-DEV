#!/bin/bash

# 🚀 DÉPLOIEMENT SHOPIFY AUTOMATIQUE - Expert System
# Déploiement forcé DEV et LIVE sans confirmation interactive

echo "🚀 DÉPLOIEMENT SHOPIFY AUTOMATIQUE - Expert Shopify System"
echo "════════════════════════════════════════════════════════════════"

cd "/Users/asc/Shopify/TPS BASE DEV"

# Configuration
TIMESTAMP=$(date +%Y%m%d-%H%M)
DEV_THEME_NAME="TPS-DEV-AUTO-$TIMESTAMP"
LIVE_THEME_NAME="TPS-LIVE-AUTO-$TIMESTAMP"

echo "📋 DÉPLOIEMENT AUTOMATIQUE:"
echo "──────────────────────────────"
echo "🎯 Store: f6d72e-0f.myshopify.com"
echo "🔧 Theme DEV: $DEV_THEME_NAME (unpublished)"
echo "🚀 Theme LIVE: $LIVE_THEME_NAME (à publier manuellement)"
echo "📅 Timestamp: $TIMESTAMP"

# Vérifier si on a des fichiers de thème à déployer
THEME_DIR="/Users/asc/Shopify/theme_export__thepetsociety-paris-tps-base-316__02OCT2025-1235am"

if [ -d "$THEME_DIR" ]; then
    echo "✅ Répertoire thème trouvé: $THEME_DIR"
    
    echo ""
    echo "🔧 ÉTAPE 1: Déploiement DEV (unpublished)..."
    echo "────────────────────────────────────────────"
    
    cd "$THEME_DIR"
    
    if shopify theme push --unpublished --theme="$DEV_THEME_NAME" --store=f6d72e-0f.myshopify.com; then
        echo "✅ Déploiement DEV réussi!"
        DEV_SUCCESS=true
    else
        echo "❌ Échec déploiement DEV"
        DEV_SUCCESS=false
    fi
    
    echo ""
    echo "🚀 ÉTAPE 2: Déploiement LIVE (production)..."
    echo "─────────────────────────────────────────────"
    echo "⚠️  ATTENTION: Déploiement en PRODUCTION"
    
    if shopify theme push --theme="$LIVE_THEME_NAME" --store=f6d72e-0f.myshopify.com; then
        echo "✅ Déploiement LIVE réussi!"
        LIVE_SUCCESS=true
    else
        echo "❌ Échec déploiement LIVE"
        LIVE_SUCCESS=false
    fi
    
else
    echo "⚠️  Répertoire thème non trouvé: $THEME_DIR"
    echo "🔍 Recherche d'autres répertoires de thème..."
    
    # Rechercher d'autres dossiers de thème
    THEME_DIRS=$(find /Users/asc/Shopify -name "*.liquid" -type f | head -1 | xargs dirname 2>/dev/null)
    
    if [ -n "$THEME_DIRS" ]; then
        THEME_ROOT=$(echo "$THEME_DIRS" | xargs dirname)
        echo "✅ Thème trouvé dans: $THEME_ROOT"
        
        cd "$THEME_ROOT"
        
        echo "🔧 Déploiement DEV depuis: $THEME_ROOT"
        if shopify theme push --unpublished --theme="$DEV_THEME_NAME" --store=f6d72e-0f.myshopify.com; then
            echo "✅ Déploiement DEV réussi!"
            DEV_SUCCESS=true
        else
            echo "❌ Échec déploiement DEV"
            DEV_SUCCESS=false
        fi
        
    else
        echo "❌ Aucun fichier de thème Shopify trouvé"
        DEV_SUCCESS=false
        LIVE_SUCCESS=false
    fi
fi

echo ""
echo "📊 RÉSUMÉ DES DÉPLOIEMENTS:"
echo "──────────────────────────────"

if [ "$DEV_SUCCESS" = true ]; then
    echo "✅ DEV: $DEV_THEME_NAME (unpublished)"
else
    echo "❌ DEV: Échec du déploiement"
fi

if [ "$LIVE_SUCCESS" = true ]; then
    echo "✅ LIVE: $LIVE_THEME_NAME (production)"
else
    echo "⚠️  LIVE: Non déployé ou échec"
fi

echo ""
echo "🔗 LIENS UTILES:"
echo "─────────────────"
echo "🏪 Admin Shopify: https://f6d72e-0f.myshopify.com/admin/themes"
echo "🎨 Themes: https://f6d72e-0f.myshopify.com/admin/themes"

echo ""
echo "✅ DÉPLOIEMENT AUTOMATIQUE TERMINÉ - Expert Shopify System"

# Retourner au répertoire de travail
cd "/Users/asc/Shopify/TPS BASE DEV"