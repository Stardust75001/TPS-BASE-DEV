#!/bin/bash
echo "🔍 SCAN ET VALIDATION COMPLÈTE DES FICHIERS JSON LOCALES"
echo "============================================================"

LOCALES_DIR="/Users/asc/Shopify/theme_export__thepetsociety-paris-tps-base-316__02OCT2025-1235am/locales"
REPORT_FILE="/Users/asc/Shopify/theme_export__thepetsociety-paris-tps-base-316__02OCT2025-1235am/locales-report.txt"

cd "$LOCALES_DIR"

echo "📊 STATISTIQUES GÉNÉRALES" | tee "$REPORT_FILE"
echo "=========================" | tee -a "$REPORT_FILE"
echo "Nombre de fichiers JSON: $(ls -1 *.json | wc -l)" | tee -a "$REPORT_FILE"
echo "Taille totale: $(du -sh . | cut -f1)" | tee -a "$REPORT_FILE"
echo "" | tee -a "$REPORT_FILE"

echo "📋 DÉTAILS PAR FICHIER" | tee -a "$REPORT_FILE"
echo "======================" | tee -a "$REPORT_FILE"

for file in *.json; do
    echo "--- $file ---" | tee -a "$REPORT_FILE"
    echo "Lignes: $(wc -l < "$file")" | tee -a "$REPORT_FILE"
    echo "Taille: $(ls -lh "$file" | awk '{print $5}')" | tee -a "$REPORT_FILE"
    
    # Validation JSON
    if python3 -m json.tool "$file" > /dev/null 2>&1; then
        echo "Syntaxe JSON: ✅ VALIDE" | tee -a "$REPORT_FILE"
    else
        echo "Syntaxe JSON: ❌ INVALIDE" | tee -a "$REPORT_FILE"
    fi
    
    # Compter les clés principales
    if command -v jq &> /dev/null; then
        echo "Clés principales: $(jq 'keys | length' "$file" 2>/dev/null || echo 'N/A')" | tee -a "$REPORT_FILE"
    fi
    
    echo "" | tee -a "$REPORT_FILE"
done

echo "✅ Rapport généré: $REPORT_FILE"
