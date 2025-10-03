#!/bin/bash

# 🎯 COMMANDE FINALE UNIFIÉE - Expert Shopify System
# Exécute toutes les optimisations et donne accès complet aux rapports

echo "🚀 SYSTÈME EXPERT SHOPIFY - COMMANDE FINALE"
echo "══════════════════════════════════════════════════════"

cd "/Users/asc/Shopify/TPS BASE DEV"

# Fonction pour les URLs GitHub
get_github_url() {
    local repo_url=$(git config --get remote.origin.url 2>/dev/null | sed 's/\.git$//' | sed 's/git@github.com:/https:\/\/github.com\//')
    echo "$repo_url"
}

echo "📋 MENU PRINCIPAL:"
echo "1. 🔄 Redémarrer VS Code (code . --new-window)"
echo "2. 🧪 Tests et validation complète"
echo "3. 📊 Dashboard métrique & pilotage site"
echo "4. 🔗 Accès aux rapports GitHub Actions"
echo "5. 🚀 Lancer automation Shopify"
echo "6. 📖 Guide complet"
echo "0. ❌ Quitter"
echo ""

read -p "Choisissez une option (0-6): " choice

case $choice in
    1)
        echo "🔄 REDÉMARRAGE VS CODE:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━"

        # Méthode 1: Fermer et redémarrer
        echo "Fermeture VS Code en cours..."
        pkill -f "Visual Studio Code" 2>/dev/null || true
        sleep 2

        echo "Redémarrage avec configuration optimisée..."
        code . --new-window

        echo "✅ VS Code redémarré !"
        echo ""
        echo "🔍 VÉRIFICATION THEME CHECK:"
        echo "1. Dans VS Code: Ctrl+Shift+X (Extensions)"
        echo "2. Rechercher: 'Shopify Theme Check'"
        echo "3. Vérifier qu'elle est activée ✅"
        echo "4. Ouvrir un fichier .liquid pour tester"
        ;;

    2)
        echo "🧪 TESTS ET VALIDATION:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━"

        echo "Test rapide..."
        if [ -f "./quick-vscode-validation.sh" ]; then
            chmod +x "./quick-vscode-validation.sh"
            ./quick-vscode-validation.sh
        fi

        echo ""
        echo "Test complet..."
        if [ -f "./test-final-validation.sh" ]; then
            chmod +x "./test-final-validation.sh"
            ./test-final-validation.sh
        fi
        ;;

    ;;

    3)
        echo "📊 DASHBOARD MÉTRIQUE & PILOTAGE:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

        echo "🎯 Options disponibles:"
        echo "1. 📊 Dashboard complet (Google, Ahrefs, Cloudflare...)"
        echo "2. 📋 Générer rapport HTML/PDF"
        echo "3. ⚙️ Configurer domaine du site"
        echo ""

        read -p "Choisir une option (1-3): " dashboard_choice

        case $dashboard_choice in
            1)
                echo "📊 Ouverture dashboard métrique complet..."
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
                    echo "❌ Générateur non trouvé"
                fi
                ;;
            3)
                echo "⚙️ Configuration domaine..."
                if [ -f "./configure-dashboard.sh" ]; then
                    chmod +x "./configure-dashboard.sh"
                    ./configure-dashboard.sh
                else
                    echo "❌ Script de configuration non trouvé"
                fi
                ;;
            *)
                echo "❌ Option invalide"
                ;;
        esac
        ;;

    4)
        echo "🔗 ACCÈS RAPPORTS GITHUB ACTIONS:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

        REPO_URL=$(get_github_url)

        if [ -n "$REPO_URL" ]; then
            echo "🔗 Repository: $REPO_URL"
            echo ""
            echo "📊 LIENS DIRECTS:"
            echo "├── 🌐 Toutes les actions: $REPO_URL/actions"
            echo "├── 📈 Workflows: $REPO_URL/actions/workflows"
            echo "├── 🔍 Runs récents: $REPO_URL/actions/runs"
            echo "└── ⚙️ Config workflows: $REPO_URL/tree/main/.github/workflows"

            echo ""
            echo "🕐 PLANNING AUTOMATIQUE:"
            echo "├── 🗓️ Lundi 10h: Optimisation hebdomadaire"
            echo "├── ☀️ Quotidien 11h: Health check et monitoring"
            echo "├── 📅 Vendredi 18h: Synchronisation intelligente"
            echo "└── ⚡ Sur push: Validation en temps réel"

            echo ""
            read -p "Ouvrir GitHub Actions dans le navigateur? (y/N): " open_browser

            if [[ $open_browser =~ ^[Yy]$ ]]; then
                echo "🌐 Ouverture GitHub Actions..."
                open "$REPO_URL/actions" 2>/dev/null || echo "URL: $REPO_URL/actions"
            fi
        else
            echo "⚠️ Repository GitHub non configuré"
        fi

        # Afficher rapports locaux
        echo ""
        echo "📋 RAPPORTS LOCAUX:"
        find . -name "RAPPORT-*.md" -o -name "AUDIT-*.md" | head -5 | while read report; do
            echo "📄 $(basename "$report")"
        done
        ;;

    ;;

    5)
        echo "🚀 AUTOMATION SHOPIFY:"
        echo "━━━━━━━━━━━━━━━━━━━━━━"

        if [ -f "./shopify-expert-auto.sh" ]; then
            echo "🔄 Lancement automation experte..."
            chmod +x "./shopify-expert-auto.sh"
            ./shopify-expert-auto.sh
        elif [ -f "./optimize-system-complete.sh" ]; then
            echo "🔄 Lancement optimisation système..."
            chmod +x "./optimize-system-complete.sh"
            ./optimize-system-complete.sh
        else
            echo "⚠️ Scripts d'automation non trouvés"
            echo "Exécution manuelle recommandée:"
            echo "1. ./test-final-validation.sh"
            echo "2. ./fix-vscode-issues.sh"
            echo "3. code . --new-window"
        fi
        ;;

    ;;

    6)
        echo "📖 GUIDE COMPLET:"
        echo "━━━━━━━━━━━━━━━━━"

        if [ -f "./GUIDE-POST-OPTIMIZATION.md" ]; then
            echo "📚 Guide disponible: ./GUIDE-POST-OPTIMIZATION.md"

            read -p "Afficher le guide? (y/N): " show_guide
            if [[ $show_guide =~ ^[Yy]$ ]]; then
                cat "./GUIDE-POST-OPTIMIZATION.md"
            fi
        else
            echo "📋 RÉSUMÉ RAPIDE:"
            echo ""
            echo "🔄 REDÉMARRAGE VS CODE:"
            echo "   code . --new-window"
            echo ""
            echo "📊 RAPPORTS GITHUB ACTIONS:"
            REPO_URL=$(get_github_url)
            echo "   $REPO_URL/actions"
            echo ""
            echo "🚀 AUTOMATION:"
            echo "   ./shopify-expert-auto.sh"
        fi
        ;;

    0)
        echo "👋 Au revoir !"
        exit 0
        ;;

    *)
        echo "❌ Option invalide"
        ;;
esac

echo ""
echo "🎯 COMMANDE FINALE - Expert Shopify System"
echo "✅ Pour relancer ce menu: ./expert-final-command.sh"
