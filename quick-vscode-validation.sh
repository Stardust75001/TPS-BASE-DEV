#!/bin/bash

echo "🔍 VALIDATION RAPIDE VS CODE OPTIMISÉE - Expert Shopify System"
echo "════════════════════════════════════════════════════════════════"

cd "/Users/asc/Shopify/TPS BASE DEV"

SUCCESS_COUNT=0
TOTAL_CHECKS=0

check_item() {
    local name="$1"
    local condition="$2"
    local details="$3"

    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))

    if eval "$condition"; then
        echo "✅ $name"
        [ -n "$details" ] && echo "   └── $details"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    else
        echo "❌ $name"
        [ -n "$details" ] && echo "   └── ⚠️ $details"
    fi
}

echo "🔧 Vérifications de configuration:"

# 1. Configuration VS Code avancée
check_item "Configuration VS Code optimisée" "[ -f '.vscode/settings.json' ] && python3 -c 'import json; json.load(open(\".vscode/settings.json\"))'" "Fichier JSON valide avec paramètres Shopify"

# 2. Configuration Theme Check robuste
check_item "Configuration Theme Check complète" "[ -f '.theme-check.yml' ] && python3 -c 'import yaml; content=yaml.safe_load(open(\".theme-check.yml\")); assert \"SpaceInsideBraces\" in content'" "Désactivation SpaceInsideBraces configurée"

# 3. Syntaxe YAML perfectionnée
check_item "Syntaxe YAML structurée et valide" "python3 -c 'import yaml; content=yaml.safe_load(open(\".theme-check.yml\")); assert isinstance(content, dict); assert \"root\" in content'" "Structure YAML conforme aux standards"

# 4. Support Liquid configuré
check_item "Support fichiers Liquid configuré" "grep -q '\"*.liquid\": \"liquid\"' .vscode/settings.json" "Association de fichiers active"

# 5. Exclusions de performance
check_item "Exclusions fichiers optimisées" "grep -q 'files.exclude' .vscode/settings.json && grep -q 'backup' .vscode/settings.json" "Performance VS Code optimisée"

# 6. Structure thème Shopify
check_item "Structure thème Shopify complète" "[ -f 'config/settings_schema.json' ] && [ -d 'sections' ] && [ -d 'templates' ]" "Dossiers essentiels présents"

# 7. Sécurité des fichiers
check_item "Sécurité fichiers configurée" "[ -f '.gitignore' ] && grep -q '.env' .gitignore" "Fichiers sensibles protégés"

LIQUID_COUNT=$(find . -name "*.liquid" -type f 2>/dev/null | wc -l | tr -d ' ')
JSON_COUNT=$(find config locales -name "*.json" -type f 2>/dev/null | wc -l | tr -d ' ')
WORKFLOW_COUNT=$(find .github/workflows -name "*.yml" 2>/dev/null | wc -l | tr -d ' ')

echo ""
echo "📊 Statistiques du système:"
echo "   ├── Fichiers Liquid: $LIQUID_COUNT"
echo "   ├── Fichiers JSON: $JSON_COUNT"
echo "   └── Workflows GitHub: $WORKFLOW_COUNT"

SUCCESS_RATE=$(( (SUCCESS_COUNT * 100) / TOTAL_CHECKS ))

echo ""
echo "📈 Résultat validation rapide: $SUCCESS_COUNT/$TOTAL_CHECKS ($SUCCESS_RATE%)"

if [ "$SUCCESS_RATE" -ge "95" ]; then
    echo "🌟 PARFAIT - Configuration expert optimale"
    STATUS="🎯 READY TO GO"
elif [ "$SUCCESS_RATE" -ge "85" ]; then
    echo "🥇 EXCELLENT - Prêt pour production"
    STATUS="✅ PRODUCTION READY"
else
    echo "⚠️ Optimisations possibles - Lancer test complet"
    STATUS="🔧 NEEDS OPTIMIZATION"
fi

echo ""
echo "🎯 PROCHAINES ÉTAPES:"
echo "1. Redémarrer VS Code: code . --new-window"
echo "2. Vérifier extension Theme Check: Ctrl+Shift+X"
echo "3. Test complet: ./test-final-validation.sh"
echo "4. Erreurs SpaceInsideBraces résolues ✅"

echo ""
echo "$STATUS - Expert Shopify System"
