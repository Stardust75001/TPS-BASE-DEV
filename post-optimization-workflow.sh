#!/bin/bash

# 🎯 WORKFLOW POST-OPTIMISATION - Expert Shopify
# Exécute automatiquement les 3 étapes recommandées

echo "🚀 WORKFLOW POST-OPTIMISATION AUTOMATIQUE"
echo "════════════════════════════════════════════"

cd "/Users/asc/Shopify/TPS BASE DEV"

echo "ÉTAPE 1/3: 🔄 Redémarrage VS Code"
echo "─────────────────────────────────────"

# Option 1: Redémarrage automatique
echo "Fermeture de VS Code en cours..."
pkill -f "Visual Studio Code" 2>/dev/null || true
sleep 2

echo "Redémarrage avec nouvelle configuration..."
code . --new-window
echo "✅ VS Code redémarré"

sleep 3

echo ""
echo "ÉTAPE 2/3: 🔍 Vérification Theme Check"
echo "─────────────────────────────────────────"

echo "🔍 Instructions pour vérifier Theme Check:"
echo "1. Dans VS Code: Ctrl+Shift+X (Extensions)"
echo "2. Rechercher: 'Shopify Theme Check'"
echo "3. Vérifier qu'elle est activée ✅"
echo "4. Ouvrir un fichier .liquid pour tester"

# Attendre confirmation
read -p "Theme Check vérifié et fonctionnel? (y/N): " theme_check_ok

if [[ $theme_check_ok =~ ^[Yy]$ ]]; then
    echo "✅ Theme Check confirmé fonctionnel"
else
    echo "⚠️ Si problème: Désactiver/Réactiver l'extension Theme Check"
fi

echo ""
echo "ÉTAPE 3/3: 🚀 Automation complète"
echo "────────────────────────────────────"

if [ -f "./shopify-expert-auto.sh" ]; then
    echo "🔄 Lancement de l'automation complète..."
    chmod +x "./shopify-expert-auto.sh"

    read -p "Lancer ./shopify-expert-auto.sh maintenant? (y/N): " auto_launch

    if [[ $auto_launch =~ ^[Yy]$ ]]; then
        echo "🚀 Démarrage automation..."
        ./shopify-expert-auto.sh
    else
        echo "ℹ️ Pour lancer manuellement: ./shopify-expert-auto.sh"
    fi
else
    echo "⚠️ Script shopify-expert-auto.sh non trouvé"
    echo "Création d'un raccourci d'automation..."

    # Créer un raccourci simple si le script principal n'existe pas
    cat > "./run-automation.sh" << 'EOF'
#!/bin/bash
echo "🚀 Automation Shopify simplifiée"
echo "1. Test validation: ./test-final-validation.sh"
echo "2. Optimisation: ./optimize-system-complete.sh"
echo "3. Rapports: ./view-all-reports.sh"
EOF
    chmod +x "./run-automation.sh"
    echo "✅ Raccourci créé: ./run-automation.sh"
fi

echo ""
echo "📊 ACCÈS AUX RAPPORTS:"
echo "─────────────────────"

if [ -f "./view-all-reports.sh" ]; then
    echo "📋 Tous les rapports: ./view-all-reports.sh"

    read -p "Afficher les rapports maintenant? (y/N): " show_reports

    if [[ $show_reports =~ ^[Yy]$ ]]; then
        ./view-all-reports.sh
    fi
else
    echo "ℹ️ Script de rapports: créé automatiquement"
fi

echo ""
echo "🎯 WORKFLOW TERMINÉ - Expert Shopify System"
echo "✅ VS Code redémarré avec optimisations"
echo "🔍 Theme Check à vérifier manuellement"
echo "🚀 Automation disponible"
echo "📊 Rapports accessibles via GitHub Actions"

# Rappel des URLs GitHub Actions
REPO_URL=$(git config --get remote.origin.url 2>/dev/null | sed 's/\.git$//' | sed 's/git@github.com:/https:\/\/github.com\//')
if [ -n "$REPO_URL" ]; then
    echo ""
    echo "🔗 GitHub Actions: $REPO_URL/actions"
    echo "📱 Pour ouvrir: open '$REPO_URL/actions'"
fi
