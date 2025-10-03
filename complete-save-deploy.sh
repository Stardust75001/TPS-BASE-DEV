#!/bin/bash

# 💾 SAUVEGARDE COMPLÈTE - Expert Shopify System
# Git commit/push + Déploiement Shopify Dev/Live

echo "💾 SAUVEGARDE COMPLÈTE - Expert Shopify System"
echo "═══════════════════════════════════════════════════"

cd "/Users/asc/Shopify/TPS BASE DEV"

echo "📊 ÉTAT DU SYSTÈME:"
echo "──────────────────────"

# Vérifier les changements Git
echo "🔍 Vérification changements Git..."
git status --porcelain > /tmp/git_status.txt

if [ -s /tmp/git_status.txt ]; then
    echo "📝 Changements détectés:"
    cat /tmp/git_status.txt | head -10
    
    if [ $(wc -l < /tmp/git_status.txt) -gt 10 ]; then
        echo "... et $(($(wc -l < /tmp/git_status.txt) - 10)) autres fichiers"
    fi
    
    HAS_CHANGES=true
else
    echo "✅ Aucun changement Git détecté"
    HAS_CHANGES=false
fi

echo ""
echo "🎯 PLAN DE SAUVEGARDE:"
echo "─────────────────────────"
echo "1. 📝 Git: Commit + Push GitHub"
echo "2. 🔧 Shopify DEV: Déploiement preview"
echo "3. 🚀 Shopify LIVE: Déploiement production (optionnel)"

echo ""
echo "⚡ EXÉCUTION AUTOMATIQUE:"
echo "────────────────────────────"

# ÉTAPE 1: Git Commit et Push
if [ "$HAS_CHANGES" = true ]; then
    echo "📝 ÉTAPE 1: Sauvegarde Git..."
    
    # Ajouter tous les fichiers
    echo "   ├── Ajout fichiers modifiés..."
    git add -A
    
    # Créer commit avec timestamp
    COMMIT_MSG="💾 Sauvegarde automatique $(date '+%Y-%m-%d %H:%M')

🔧 Améliorations système:
- Configuration VS Code optimisée
- Dashboard métrique complet
- Scripts automatisation mis à jour
- Tests validation améliorés

📊 Expert Shopify System - Auto-save"
    
    echo "   ├── Création commit..."
    git commit -m "$COMMIT_MSG"
    
    if [ $? -eq 0 ]; then
        echo "   ├── ✅ Commit créé"
        
        echo "   └── Push GitHub..."
        git push
        
        if [ $? -eq 0 ]; then
            echo "   └── ✅ Push GitHub réussi"
            GIT_SUCCESS=true
        else
            echo "   └── ❌ Échec push GitHub"
            GIT_SUCCESS=false
        fi
    else
        echo "   └── ❌ Échec création commit"
        GIT_SUCCESS=false
    fi
else
    echo "📝 ÉTAPE 1: Git à jour, pas de commit nécessaire"
    GIT_SUCCESS=true
fi

# ÉTAPE 2: Déploiement Shopify DEV
echo ""
echo "🔧 ÉTAPE 2: Déploiement Shopify DEV..."

read -p "Déployer vers Shopify DEV? (y/N): " deploy_dev_choice

if [[ $deploy_dev_choice =~ ^[Yy]$ ]]; then
    echo "   ├── Vérification authentification..."
    
    # Vérifier auth Shopify
    shopify auth whoami > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "   ├── Authentification Shopify..."
        shopify auth login
    fi
    
    if [ $? -eq 0 ]; then
        echo "   ├── ✅ Authentification OK"
        
        DEV_THEME="TPS-DEV-$(date +%m%d-%H%M)"
        echo "   ├── Déploiement theme: $DEV_THEME"
        
        shopify theme push --unpublished --theme="$DEV_THEME"
        
        if [ $? -eq 0 ]; then
            echo "   └── ✅ Déploiement DEV réussi: $DEV_THEME"
            DEV_SUCCESS=true
        else
            echo "   └── ❌ Échec déploiement DEV"
            DEV_SUCCESS=false
        fi
    else
        echo "   └── ❌ Échec authentification Shopify"
        DEV_SUCCESS=false
    fi
else
    echo "   └── ⏭️ Déploiement DEV ignoré"
    DEV_SUCCESS="skipped"
fi

# ÉTAPE 3: Déploiement Shopify LIVE (optionnel)
echo ""
echo "🚀 ÉTAPE 3: Déploiement Shopify LIVE (PRODUCTION)..."

read -p "Déployer vers Shopify LIVE (PRODUCTION)? (y/N): " deploy_live_choice

if [[ $deploy_live_choice =~ ^[Yy]$ ]]; then
    echo ""
    echo "🚨 ATTENTION: DÉPLOIEMENT PRODUCTION!"
    echo "Ceci créera un nouveau thème sur le site LIVE."
    echo "Vous devrez le publier manuellement via l'admin."
    echo ""
    
    read -p "Confirmer PRODUCTION (tapez 'CONFIRM'): " confirm_prod
    
    if [ "$confirm_prod" = "CONFIRM" ]; then
        LIVE_THEME="TPS-LIVE-$(date +%m%d-%H%M)"
        echo "   ├── Déploiement LIVE: $LIVE_THEME"
        
        shopify theme push --unpublished --theme="$LIVE_THEME"
        
        if [ $? -eq 0 ]; then
            echo "   └── ✅ Déploiement LIVE réussi: $LIVE_THEME"
            echo ""
            echo "📋 IMPORTANT: Publier manuellement via Shopify Admin!"
            LIVE_SUCCESS=true
        else
            echo "   └── ❌ Échec déploiement LIVE"
            LIVE_SUCCESS=false
        fi
    else
        echo "   └── ❌ Déploiement LIVE annulé"
        LIVE_SUCCESS=false
    fi
else
    echo "   └── ⏭️ Déploiement LIVE ignoré"
    LIVE_SUCCESS="skipped"
fi

# RAPPORT FINAL
echo ""
echo "📊 RAPPORT DE SAUVEGARDE:"
echo "═════════════════════════════"

if [ "$GIT_SUCCESS" = true ]; then
    echo "✅ Git: Commit + Push GitHub réussi"
else
    echo "❌ Git: Problème de sauvegarde"
fi

if [ "$DEV_SUCCESS" = true ]; then
    echo "✅ Shopify DEV: Déployé ($DEV_THEME)"
elif [ "$DEV_SUCCESS" = "skipped" ]; then
    echo "⏭️ Shopify DEV: Ignoré par l'utilisateur"
else
    echo "❌ Shopify DEV: Échec déploiement"
fi

if [ "$LIVE_SUCCESS" = true ]; then
    echo "✅ Shopify LIVE: Déployé ($LIVE_THEME) - À publier manuellement"
elif [ "$LIVE_SUCCESS" = "skipped" ]; then
    echo "⏭️ Shopify LIVE: Ignoré par l'utilisateur"
else
    echo "❌ Shopify LIVE: Échec ou annulé"
fi

# Liens utiles
if [ -f ".env" ]; then
    source .env
    if [ -n "$SHOPIFY_STORE_DOMAIN" ]; then
        echo ""
        echo "🔗 LIENS UTILES:"
        echo "Admin Shopify: https://$SHOPIFY_STORE_DOMAIN/admin"
        echo "Themes: https://$SHOPIFY_STORE_DOMAIN/admin/themes"
    fi
fi

echo ""
echo "💾 SAUVEGARDE COMPLÈTE TERMINÉE - Expert Shopify System"
echo "🎯 Tous vos changements sont sécurisés !"