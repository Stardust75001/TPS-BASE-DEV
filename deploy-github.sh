#!/bin/bash

# 🚀 Script de déploiement GitHub - TPS BASE DEV
# Créé le 3 octobre 2025

echo "🚀 DÉPLOIEMENT GITHUB - TPS BASE DEV"
echo "===================================="

# Vérifier si GitHub CLI est installé
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) n'est pas installé"
    echo "📥 Installez avec: brew install gh"
    exit 1
fi

# Vérifier l'authentification GitHub
if ! gh auth status &> /dev/null; then
    echo "🔐 Authentification GitHub requise"
    echo "🔑 Lancez: gh auth login"
    exit 1
fi

echo "✅ GitHub CLI configuré et authentifié"

# Créer le dépôt GitHub
echo "📦 Création du dépôt 'TPS-BASE-DEV'..."
gh repo create TPS-BASE-DEV \
    --public \
    --description "🎨 Thème Shopify de développement pour The Pet Society - Analytics Suite Professionnelle, Sécurité Centralisée, 11 langues" \
    --homepage "https://thepetsociety-paris.myshopify.com"

if [ $? -eq 0 ]; then
    echo "✅ Dépôt GitHub créé avec succès"
else
    echo "⚠️ Le dépôt existe peut-être déjà, on continue..."
fi

# Ajouter l'origine GitHub
echo "🔗 Configuration de l'origine GitHub..."
git remote add origin https://github.com/$(gh api user --jq .login)/TPS-BASE-DEV.git

# Push vers GitHub
echo "🚀 Push vers GitHub..."
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 SUCCÈS ! TPS BASE DEV déployé sur GitHub"
    echo "📋 URL du dépôt: https://github.com/$(gh api user --jq .login)/TPS-BASE-DEV"
    echo ""
    echo "🔧 PROCHAINES ÉTAPES:"
    echo "1. Configurer les branches de protection"
    echo "2. Ajouter les collaborateurs"
    echo "3. Configurer les secrets GitHub Actions"
    echo "4. Paramétrer les webhooks Shopify"
    echo ""
    echo "💡 DÉVELOPPEMENT:"
    echo "   git clone https://github.com/$(gh api user --jq .login)/TPS-BASE-DEV.git"
    echo "   cd TPS-BASE-DEV"
    echo "   source .env && shopify theme dev"
else
    echo "❌ Erreur lors du push vers GitHub"
    exit 1
fi
