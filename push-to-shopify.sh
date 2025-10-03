#!/bin/bash

echo "🚀 TPS BASE DEV - PUSH VERS SHOPIFY PREVIEW"
echo "============================================"

# Configuration
source .env
STORE="$SHOPIFY_STORE_DOMAIN"
THEME_NAME="TPS-BASE-DEV-Preview-$(date +%m%d-%H%M)"

echo "📦 Store: $STORE"
echo "🎨 Theme Name: $THEME_NAME"
echo ""

# Test de connexion d'abord
echo "🔍 Test de connexion Shopify..."
shopify auth whoami 2>/dev/null
if [ $? -ne 0 ]; then
    echo "⚠️  Authentification Shopify requise"
    echo "🔑 Lancement de l'authentification..."
    shopify auth login --store="$STORE"

    if [ $? -ne 0 ]; then
        echo "❌ Échec de l'authentification"
        exit 1
    fi
fi

echo "✅ Authentification OK"
echo ""

# Vérification des tokens dans .env
echo "🔍 Vérification configuration..."
if [ -z "$SHOPIFY_STORE_DOMAIN" ]; then
    echo "❌ SHOPIFY_STORE_DOMAIN non défini dans .env"
    exit 1
fi

echo "✅ Configuration OK"
echo ""

# Push du thème comme unpublished (preview)
echo "📤 Push du thème TPS BASE DEV vers Shopify..."
echo "   • Destination: $STORE"
echo "   • Mode: Unpublished (Preview)"
echo "   • Theme: $THEME_NAME"
echo ""

shopify theme push --store="$STORE" --unpublished --theme="$THEME_NAME" --allow-live

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 SUCCÈS ! TPS BASE DEV poussé avec succès"
    echo "📱 Preview disponible dans votre admin Shopify :"
    echo "🔗 https://$STORE/admin/themes"
    echo ""
    echo "🎯 Actions suivantes :"
    echo "   1. Aller dans Shopify Admin → Online Store → Themes"
    echo "   2. Trouver '$THEME_NAME'"
    echo "   3. Cliquer 'Preview' pour voir le thème avec les infobulles corrigées"
    echo "   4. Tester les infobulles sur le carousel"
else
    echo ""
    echo "❌ Erreur lors du push du thème"
    echo "💡 Suggestions :"
    echo "   1. Vérifier les permissions de l'app Shopify"
    echo "   2. Vérifier que le store $STORE existe"
    echo "   3. Vérifier la connexion internet"
fi
