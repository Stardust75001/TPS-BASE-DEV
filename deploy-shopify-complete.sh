#!/bin/bash

# 🚀 DÉPLOIEMENT SHOPIFY COMPLET - Expert System
# Push automatique vers Dev et Live après confirmation

echo "🚀 DÉPLOIEMENT SHOPIFY COMPLET - Expert Shopify System"
echo "════════════════════════════════════════════════════════════"

cd "/Users/asc/Shopify/TPS BASE DEV"

# Configuration
TIMESTAMP=$(date +%Y%m%d-%H%M)
DEV_THEME_NAME="TPS-DEV-$TIMESTAMP"
LIVE_THEME_NAME="TPS-LIVE-$TIMESTAMP"

# Vérifier l'authentification Shopify
echo "🔍 Vérification authentification Shopify..."
shopify auth whoami 2>/dev/null
if [ $? -ne 0 ]; then
    echo "⚠️ Authentification Shopify requise"
    echo "🔑 Lancement authentification..."
    shopify auth login

    if [ $? -ne 0 ]; then
        echo "❌ Échec authentification Shopify"
        exit 1
    fi
fi
echo "✅ Authentification Shopify OK"

# Charger configuration
if [ -f ".env" ]; then
    source .env
    echo "✅ Configuration .env chargée"
else
    echo "⚠️ Fichier .env non trouvé, utilisation configuration par défaut"
fi

echo ""
echo "📋 PLAN DE DÉPLOIEMENT:"
echo "──────────────────────────"
echo "🎯 Store: ${SHOPIFY_STORE_DOMAIN:-'À configurer'}"
echo "🔧 Theme DEV: $DEV_THEME_NAME (unpublished)"
echo "🚀 Theme LIVE: $LIVE_THEME_NAME (à publier manuellement)"
echo "📅 Timestamp: $TIMESTAMP"

echo ""
echo "🛡️ SÉCURITÉ - CONFIRMATION REQUISE:"
echo "───────────────────────────────────"

read -p "1️⃣ Déployer vers DEV (unpublished)? (y/N): " deploy_dev

if [[ $deploy_dev =~ ^[Yy]$ ]]; then
    echo ""
    echo "🔧 DÉPLOIEMENT DEV EN COURS..."
    echo "──────────────────────────────"

    shopify theme push --unpublished --theme="$DEV_THEME_NAME"

    if [ $? -eq 0 ]; then
        echo "✅ Déploiement DEV réussi: $DEV_THEME_NAME"

        # Obtenir l'URL de preview
        DEV_URL=$(shopify theme list --json 2>/dev/null | grep -A5 "$DEV_THEME_NAME" | grep "preview_url" | cut -d'"' -f4)
        if [ -n "$DEV_URL" ]; then
            echo "🌐 Preview DEV: $DEV_URL"
        fi
    else
        echo "❌ Échec déploiement DEV"
        exit 1
    fi
else
    echo "⏭️ Déploiement DEV ignoré"
fi

echo ""
read -p "2️⃣ Déployer vers LIVE (ATTENTION: PRODUCTION)? (y/N): " deploy_live

if [[ $deploy_live =~ ^[Yy]$ ]]; then
    echo ""
    echo "🚨 ATTENTION: DÉPLOIEMENT PRODUCTION!"
    echo "────────────────────────────────────"
    echo "Ceci va créer un nouveau thème sur le site LIVE."
    echo "Vous devrez le publier manuellement via l'admin Shopify."
    echo ""

    read -p "Confirmer déploiement LIVE? (tapez 'CONFIRM'): " confirm_live

    if [ "$confirm_live" = "CONFIRM" ]; then
        echo ""
        echo "🚀 DÉPLOIEMENT LIVE EN COURS..."
        echo "─────────────────────────────────"

        shopify theme push --unpublished --theme="$LIVE_THEME_NAME"

        if [ $? -eq 0 ]; then
            echo "✅ Déploiement LIVE réussi: $LIVE_THEME_NAME"
            echo ""
            echo "📋 PROCHAINES ÉTAPES MANUELLES:"
            echo "1. 🌐 Aller sur l'admin Shopify"
            echo "2. 🎨 Themes > $LIVE_THEME_NAME"
            echo "3. 🚀 Cliquer 'Publish' quand prêt"
            echo "4. 🧪 Tester le site avant publication"
        else
            echo "❌ Échec déploiement LIVE"
            exit 1
        fi
    else
        echo "❌ Déploiement LIVE annulé (confirmation incorrecte)"
    fi
else
    echo "⏭️ Déploiement LIVE ignoré"
fi

echo ""
echo "📊 RÉSUMÉ DES DÉPLOIEMENTS:"
echo "──────────────────────────"

if [[ $deploy_dev =~ ^[Yy]$ ]]; then
    echo "✅ DEV déployé: $DEV_THEME_NAME"
fi

if [[ $deploy_live =~ ^[Yy]$ ]] && [ "$confirm_live" = "CONFIRM" ]; then
    echo "✅ LIVE déployé: $LIVE_THEME_NAME (à publier manuellement)"
fi

echo ""
echo "🔗 LIENS UTILES:"
echo "─────────────────"
if [ -n "$SHOPIFY_STORE_DOMAIN" ]; then
    echo "🏪 Admin Shopify: https://$SHOPIFY_STORE_DOMAIN/admin/themes"
    echo "🎨 Themes: https://$SHOPIFY_STORE_DOMAIN/admin/themes"
fi

echo ""
echo "✅ DÉPLOIEMENT SHOPIFY TERMINÉ - Expert Shopify System"
