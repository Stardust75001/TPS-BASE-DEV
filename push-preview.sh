#!/bin/bash

echo "🚀 PUSH TPS BASE DEV VERS SHOPIFY - PREVIEW"
echo "==========================================="

# Configuration
export SHOPIFY_CLI_THEME_TOKEN="shptka_fa39897a2dfff10b4ae7bfff3a5f6c05"
STORE="f6d72e-0f.myshopify.com"
THEME_NAME="TPS-BASE-DEV-Preview-$(date +%m%d-%H%M)"

echo "📦 Store: $STORE"
echo "🎨 Theme: $THEME_NAME"
echo ""

# Vérification de la connexion
echo "🔍 Vérification connexion Shopify..."
shopify theme list --store="$STORE" --json > themes.json 2>&1

if [ $? -eq 0 ]; then
    echo "✅ Connexion Shopify OK"
    
    echo "📤 Push du thème vers Shopify..."
    shopify theme push --store="$STORE" --theme="$THEME_NAME" --allow-live
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "🎉 SUCCÈS ! Thème poussé avec succès"
        echo "📱 Preview disponible dans votre admin Shopify"
        echo "🔗 Store: https://$STORE/admin/themes"
    else
        echo "❌ Erreur lors du push du thème"
    fi
else
    echo "❌ Erreur de connexion Shopify"
    echo "Contenu du fichier d'erreur:"
    cat themes.json
fi

# Nettoyage
rm -f themes.json
