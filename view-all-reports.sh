#!/bin/bash

# 🔍 RAPPORT CENTRALISÉ - EXPERT SHOPIFY SYSTEM
# Accès rapide à tous les rapports et checks

echo "📊 RAPPORTS SYSTÈME - EXPERT SHOPIFY"
echo "═══════════════════════════════════════════════════════"

cd "/Users/asc/Shopify/TPS BASE DEV"

echo "🎯 ACCÈS AUX RAPPORTS:"
echo ""

echo "1. 📈 RAPPORTS LOCAUX DISPONIBLES:"
echo "───────────────────────────────────"

# Lister tous les rapports disponibles
if [ -f "RAPPORT-CORRECTIONS-THEME-CHECK.md" ]; then
    echo "✅ Rapport corrections Theme Check: ./RAPPORT-CORRECTIONS-THEME-CHECK.md"
fi

if [ -f "RAPPORT-LOCALES-JSON.md" ]; then
    echo "✅ Rapport locales JSON: ./RAPPORT-LOCALES-JSON.md"
fi

if [ -f "RAPPORT-SYNCHRONISATION-COMPLETE.md" ]; then
    echo "✅ Rapport synchronisation: ./RAPPORT-SYNCHRONISATION-COMPLETE.md"
fi

if [ -f "AUDIT-COMPLET-RAPPORT.md" ]; then
    echo "✅ Audit complet: ./AUDIT-COMPLET-RAPPORT.md"
fi

# Rapports de logs
echo ""
echo "📋 LOGS RÉCENTS:"
echo "─────────────────"
find . -name "*.log" -type f -mtime -7 | head -5 | while read log_file; do
    echo "📄 $(basename "$log_file"): $log_file"
done

echo ""
echo "2. 🔗 GITHUB ACTIONS - RAPPORTS EN LIGNE:"
echo "─────────────────────────────────────────"

# Récupérer les informations du repo
REPO_URL=$(git config --get remote.origin.url 2>/dev/null | sed 's/\.git$//' | sed 's/git@github.com:/https:\/\/github.com\//')

if [ -n "$REPO_URL" ]; then
    echo "🌐 Repository URL: $REPO_URL"
    echo ""
    echo "📊 ACCÈS DIRECT AUX ACTIONS GITHUB:"
    echo "   ├── 🔗 Toutes les actions: $REPO_URL/actions"
    echo "   ├── 📈 Workflows: $REPO_URL/actions/workflows"
    echo "   ├── 🔍 Runs récents: $REPO_URL/actions/runs"
    echo "   └── ⚙️ Configuration: $REPO_URL/tree/main/.github/workflows"

    echo ""
    echo "🕐 PLANNING DES ACTIONS AUTOMATIQUES:"
    echo "   ├── 🗓️ Lundi 10h: Optimisation hebdomadaire"
    echo "   ├── ☀️ Quotidien 11h: Health check et monitoring"
    echo "   ├── 📅 Vendredi 18h: Synchronisation intelligente"
    echo "   └── ⚡ Sur push: Validation en temps réel"
else
    echo "⚠️ Repository Git non configuré"
fi

echo ""
echo "3. 🛠️ WORKFLOWS DISPONIBLES:"
echo "────────────────────────────"

if [ -d ".github/workflows" ]; then
    WORKFLOW_COUNT=0
    for workflow in .github/workflows/*.yml; do
        if [ -f "$workflow" ]; then
            WORKFLOW_NAME=$(basename "$workflow" .yml)
            WORKFLOW_COUNT=$((WORKFLOW_COUNT + 1))

            # Extraire les informations du workflow
            if grep -q "schedule:" "$workflow"; then
                SCHEDULE=$(grep -A 1 "schedule:" "$workflow" | grep "cron:" | sed 's/.*cron: *//' | tr -d "\"'")
                echo "   ├── 📋 $WORKFLOW_NAME (Planifié: $SCHEDULE)"
            elif grep -q "on: push" "$workflow" || grep -q "push:" "$workflow"; then
                echo "   ├── ⚡ $WORKFLOW_NAME (Sur push)"
            else
                echo "   ├── 🔧 $WORKFLOW_NAME (Manuel)"
            fi
        fi
    done
    echo "   └── 📊 Total: $WORKFLOW_COUNT workflows configurés"
else
    echo "❌ Aucun workflow GitHub Actions trouvé"
fi

echo ""
echo "4. 🚀 COMMANDES RAPIDES:"
echo "────────────────────────"
echo "   ├── 📊 Validation complète: ./test-final-validation.sh"
echo "   ├── ⚡ Validation rapide: ./quick-vscode-validation.sh"
echo "   ├── 🔧 Correction VS Code: ./fix-vscode-issues.sh"
echo "   ├── 🚀 Automation complète: ./shopify-expert-auto.sh"
echo "   └── 🎯 Optimisation système: ./optimize-system-complete.sh"

echo ""
echo "5. � DASHBOARD MÉTRIQUE COMPLET:"
echo "──────────────────────────────────"
echo "   ├── 🎯 Dashboard pilotage: ./dashboard-metrics-complete.sh"
echo "   ├── 📋 Rapport HTML/PDF: ./generate-dashboard-report.sh"
echo "   ├── 🔍 Google Analytics, Ahrefs, Cloudflare"
echo "   ├── 🛒 Shopify Analytics & E-commerce"
echo "   ├── 📱 Réseaux sociaux & Communication"
echo "   └── 🎯 Analyse concurrentielle & SEO"

echo ""
echo "6. �📱 ACCÈS MOBILE/WEB AUX RAPPORTS:"
echo "───────────────────────────────────"
if [ -n "$REPO_URL" ]; then
    echo "📱 GitHub Mobile App: Actions → TPS-BASE-DEV"
    echo "🌐 GitHub Web: $REPO_URL/actions"
    echo "📧 Email notifications: Configurables dans Settings → Notifications"
fi

echo ""
echo "🎯 MENU RAPIDE:"
echo "1. 📊 Dashboard métrique complet"
echo "2. 📋 Générer rapport HTML/PDF"
echo "3. 🔗 Ouvrir GitHub Actions"
echo "0. ❌ Quitter"
echo ""

read -p "Choisir une action (0-3): " quick_choice

case $quick_choice in
    1)
        echo "📊 Ouverture dashboard métrique..."
        if [ -f "./dashboard-metrics-complete.sh" ]; then
            chmod +x "./dashboard-metrics-complete.sh"
            ./dashboard-metrics-complete.sh
        else
            echo "❌ Dashboard non trouvé"
        fi
        ;;
    2)
        echo "📋 Génération rapport HTML/PDF..."
        if [ -f "./generate-dashboard-report.sh" ]; then
            chmod +x "./generate-dashboard-report.sh"
            ./generate-dashboard-report.sh
        else
            echo "❌ Générateur de rapport non trouvé"
        fi
        ;;
    3)
        echo "🔗 Ouverture GitHub Actions..."
        if [ -n "$REPO_URL" ]; then
            open "$REPO_URL/actions" 2>/dev/null || echo "URL: $REPO_URL/actions"
        else
            echo "❌ Repository non configuré"
        fi
        ;;
    0)
        echo "👋 Au revoir !"
        ;;
    *)
        echo "❌ Option invalide"
        ;;
esac

echo ""
echo "✅ RAPPORT CENTRALISÉ DISPONIBLE - Expert Shopify System"
echo "🔗 Dashboard complet: ./dashboard-metrics-complete.sh"
