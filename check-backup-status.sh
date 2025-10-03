#!/bin/bash

# 📊 STATUT SAUVEGARDE - Expert Shopify System
# Vérification complète de l'état des sauvegardes

echo "📊 STATUT SAUVEGARDE COMPLÈTE - Expert Shopify System"
echo "════════════════════════════════════════════════════════════"

cd "/Users/asc/Shopify/TPS BASE DEV"

echo "🔍 VÉRIFICATION ÉTAT SYSTÈME:"
echo "─────────────────────────────────"

# 1. Statut Git
echo "📝 1. STATUT GIT:"
echo "   ├── Repository: $(basename "$PWD")"
echo "   ├── Branche: $(git branch --show-current 2>/dev/null || echo 'Non détectée')"

# Vérifier s'il y a des changements non commitées
if git status --porcelain | grep -q .; then
    echo "   ├── ⚠️  Changements non sauvegardés détectés:"
    git status --porcelain | head -5 | while read line; do
        echo "   │   $line"
    done
    GIT_CLEAN=false
else
    echo "   ├── ✅ Tous les changements sont sauvegardés"
    GIT_CLEAN=true
fi

# Vérifier le statut avec remote
echo "   └── Synchronisation GitHub:"
git fetch origin main --dry-run 2>/dev/null
LOCAL_COMMIT=$(git rev-parse HEAD 2>/dev/null)
REMOTE_COMMIT=$(git rev-parse origin/main 2>/dev/null)

if [ "$LOCAL_COMMIT" = "$REMOTE_COMMIT" ]; then
    echo "       └── ✅ Synchronisé avec GitHub"
    GITHUB_SYNCED=true
else
    echo "       └── ⚠️  Pas synchronisé avec GitHub"
    GITHUB_SYNCED=false
fi

echo ""

# 2. Statut Shopify
echo "🛒 2. STATUT SHOPIFY:"

# Vérifier authentification
if shopify auth whoami > /dev/null 2>&1; then
    echo "   ├── ✅ Authentification Shopify OK"
    SHOPIFY_AUTH=true

    # Lister les thèmes récents
    echo "   ├── 🎨 Thèmes récents déployés:"
    shopify theme list --json 2>/dev/null | grep -o '"name":"[^"]*TPS[^"]*"' | head -3 | while read theme; do
        theme_name=$(echo "$theme" | cut -d'"' -f4)
        echo "   │   └── $theme_name"
    done

else
    echo "   ├── ❌ Authentification Shopify manquante"
    SHOPIFY_AUTH=false
fi

# Vérifier configuration .env
if [ -f ".env" ]; then
    source .env
    if [ -n "$SHOPIFY_STORE_DOMAIN" ]; then
        echo "   └── ✅ Configuration store: $SHOPIFY_STORE_DOMAIN"
        SHOPIFY_CONFIG=true
    else
        echo "   └── ⚠️  SHOPIFY_STORE_DOMAIN non configuré"
        SHOPIFY_CONFIG=false
    fi
else
    echo "   └── ⚠️  Fichier .env non trouvé"
    SHOPIFY_CONFIG=false
fi

echo ""

# 3. Statut Scripts et Configuration
echo "🔧 3. STATUT SYSTÈME:"

# Vérifier scripts principaux
REQUIRED_SCRIPTS=(
    "expert-final-command.sh"
    "dashboard-metrics-complete.sh"
    "complete-save-deploy.sh"
    "test-final-validation.sh"
    "fix-vscode-issues.sh"
)

echo "   ├── 📜 Scripts essentiels:"
SCRIPTS_OK=0
for script in "${REQUIRED_SCRIPTS[@]}"; do
    if [ -f "$script" ] && [ -x "$script" ]; then
        echo "   │   ✅ $script"
        SCRIPTS_OK=$((SCRIPTS_OK + 1))
    else
        echo "   │   ❌ $script (manquant ou non exécutable)"
    fi
done

# Vérifier configuration VS Code
if [ -f ".vscode/settings.json" ] && [ -f ".theme-check.yml" ]; then
    echo "   ├── ✅ Configuration VS Code complète"
    VSCODE_CONFIG=true
else
    echo "   ├── ⚠️  Configuration VS Code incomplète"
    VSCODE_CONFIG=false
fi

# Score système
TOTAL_SCRIPTS=${#REQUIRED_SCRIPTS[@]}
SCRIPT_SCORE=$((SCRIPTS_OK * 100 / TOTAL_SCRIPTS))
echo "   └── 📊 Score scripts: $SCRIPTS_OK/$TOTAL_SCRIPTS ($SCRIPT_SCORE%)"

echo ""

# 4. Rapport Final
echo "📈 4. RAPPORT GLOBAL:"
echo "─────────────────────────"

TOTAL_CHECKS=0
PASSED_CHECKS=0

# Git
TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
if [ "$GIT_CLEAN" = true ]; then
    echo "✅ Git: Changements sauvegardés"
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
else
    echo "⚠️ Git: Changements non sauvegardés"
fi

# GitHub
TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
if [ "$GITHUB_SYNCED" = true ]; then
    echo "✅ GitHub: Synchronisé"
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
else
    echo "⚠️ GitHub: Non synchronisé"
fi

# Shopify Auth
TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
if [ "$SHOPIFY_AUTH" = true ]; then
    echo "✅ Shopify: Authentifié"
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
else
    echo "❌ Shopify: Non authentifié"
fi

# Configuration
TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
if [ "$VSCODE_CONFIG" = true ]; then
    echo "✅ VS Code: Configuré"
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
else
    echo "⚠️ VS Code: Configuration incomplète"
fi

# Scripts
TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
if [ $SCRIPT_SCORE -ge 80 ]; then
    echo "✅ Scripts: $SCRIPT_SCORE% fonctionnels"
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
else
    echo "⚠️ Scripts: $SCRIPT_SCORE% fonctionnels"
fi

# Score final
FINAL_SCORE=$((PASSED_CHECKS * 100 / TOTAL_CHECKS))

echo ""
echo "🎯 SCORE GLOBAL: $PASSED_CHECKS/$TOTAL_CHECKS ($FINAL_SCORE%)"

if [ $FINAL_SCORE -ge 90 ]; then
    echo "🏆 EXCELLENT: Système complètement sauvegardé et opérationnel"
    STATUS="🌟 PARFAIT"
elif [ $FINAL_SCORE -ge 70 ]; then
    echo "✅ BON: Système majoritairement sauvegardé"
    STATUS="✅ BON"
else
    echo "⚠️ ATTENTION: Sauvegardes incomplètes"
    STATUS="⚠️ À AMÉLIORER"
fi

echo ""
echo "📋 ACTIONS RECOMMANDÉES:"
echo "────────────────────────"

if [ "$GIT_CLEAN" = false ]; then
    echo "📝 Git: ./complete-save-deploy.sh pour sauvegarder"
fi

if [ "$SHOPIFY_AUTH" = false ]; then
    echo "🔑 Shopify: shopify auth login"
fi

if [ $SCRIPT_SCORE -lt 100 ]; then
    echo "🔧 Scripts: Vérifier permissions avec chmod +x"
fi

if [ -n "$SHOPIFY_STORE_DOMAIN" ]; then
    echo ""
    echo "🔗 LIENS UTILES:"
    echo "Admin Shopify: https://$SHOPIFY_STORE_DOMAIN/admin"
    echo "GitHub: $(git config --get remote.origin.url | sed 's/\.git$//' | sed 's/git@github.com:/https:\/\/github.com\//')"
fi

echo ""
echo "$STATUS - Expert Shopify System"
echo "📊 Statut vérifié le $(date '+%d/%m/%Y à %H:%M')"
