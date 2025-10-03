#!/bin/bash

# 🚀 DAILY SHOPIFY WORKFLOW AUTOMATION
# Usage: ./daily-workflow.sh [quick|full|deploy]
# =========================================

set -e
cd "/Users/asc/Shopify/TPS BASE DEV"

# Colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
THRESHOLD_IMAGES_NO_DIMS=50
THRESHOLD_CONSOLE_LOGS=10
THRESHOLD_SECURITY_ISSUES=0

print_header() {
    echo -e "${BLUE}🚀 DAILY SHOPIFY WORKFLOW - $(date)${NC}"
    echo "========================================"
    echo
}

print_section() {
    echo -e "${YELLOW}$1${NC}"
    echo "$(echo $1 | sed 's/./-/g')"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 1. QUICK DEBUG (5min)
run_quick_debug() {
    print_section "1. QUICK DEBUG (5min)"

    if [ -f "./quick-debug-shopify.sh" ]; then
        ./quick-debug-shopify.sh
    else
        print_error "Script quick-debug-shopify.sh non trouvé"
        return 1
    fi
    echo
}

# 2. SECURITY AUDIT
run_security_audit() {
    print_section "2. SECURITY AUDIT"

    if [ -f "./security-audit.sh" ]; then
        ./security-audit.sh
    else
        print_warning "Script security-audit.sh non trouvé, utilisation scan manuel"

        # Manual security check
        live_keys=$(grep -r "sk_live_\|pk_live_" --include="*.liquid" --include="*.js" snippets/ sections/ templates/ assets/ 2>/dev/null | wc -l | tr -d ' ')
        api_keys=$(grep -r "AIza[A-Za-z0-9]\{35\}" --include="*.liquid" --include="*.js" snippets/ sections/ templates/ assets/ 2>/dev/null | wc -l | tr -d ' ')

        total_security=$((live_keys + api_keys))

        if [ "$total_security" -eq 0 ]; then
            print_success "Aucun secret critique exposé"
        else
            print_error "$total_security secrets critiques détectés!"
            return 1
        fi
    fi
    echo
}

# 3. JSON VALIDATION
validate_json() {
    print_section "3. JSON VALIDATION"

    json_errors=0
    for file in locales/*.json; do
        if python3 -m json.tool "$file" > /dev/null 2>&1; then
            print_success "$(basename $file)"
        else
            print_error "$(basename $file) - SYNTAX ERROR"
            json_errors=$((json_errors + 1))
        fi
    done

    if [ "$json_errors" -eq 0 ]; then
        print_success "Tous les fichiers JSON sont valides"
    else
        print_error "$json_errors fichiers JSON avec erreurs"
        return 1
    fi
    echo
}

# 4. AUTO-CORRECTIONS
run_auto_corrections() {
    print_section "4. AUTO-CORRECTIONS"

    if [ -f "./auto-fix-theme-check.sh" ]; then
        print_success "Lancement des corrections automatiques..."
        ./auto-fix-theme-check.sh
    else
        print_warning "Script auto-fix-theme-check.sh non trouvé"

        # Manual basic fixes
        print_success "Application des corrections manuelles de base..."

        # Fix basic JSON formatting
        for file in locales/*.json; do
            if python3 -m json.tool "$file" > "${file}.tmp" 2>/dev/null; then
                mv "${file}.tmp" "$file"
                print_success "JSON formaté: $(basename $file)"
            else
                rm -f "${file}.tmp"
            fi
        done
    fi
    echo
}

# 5. PERFORMANCE CHECK
check_performance() {
    print_section "5. PERFORMANCE CHECK"

    # Images sans dimensions
    images_no_dims=$(grep -r "<img" --include="*.liquid" snippets/ sections/ templates/ 2>/dev/null | grep -v -E "width=|height=" | wc -l | tr -d ' ')

    if [ "$images_no_dims" -lt "$THRESHOLD_IMAGES_NO_DIMS" ]; then
        print_success "Images sans dimensions: $images_no_dims (< $THRESHOLD_IMAGES_NO_DIMS)"
    else
        print_warning "Images sans dimensions: $images_no_dims (impact CLS/SEO)"
    fi

    # Console.log statements
    console_logs=$(grep -r "console\." --include="*.liquid" --include="*.js" snippets/ sections/ assets/ 2>/dev/null | grep -v ".min.js" | wc -l | tr -d ' ')

    if [ "$console_logs" -lt "$THRESHOLD_CONSOLE_LOGS" ]; then
        print_success "Console statements: $console_logs (< $THRESHOLD_CONSOLE_LOGS)"
    else
        print_warning "Console statements: $console_logs (nettoyer pour production)"
    fi

    # Filtres dépréciés
    deprecated_filters=$(find . -name "*.liquid" -not -path "./backup*" -exec grep -l "img_url" {} \; 2>/dev/null | wc -l | tr -d ' ')

    if [ "$deprecated_filters" -eq 0 ]; then
        print_success "Aucun filtre déprécié"
    else
        print_warning "$deprecated_filters filtres img_url à moderniser"
    fi
    echo
}

# 6. GIT STATUS
check_git_status() {
    print_section "6. GIT STATUS"

    uncommitted=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')

    if [ "$uncommitted" -eq 0 ]; then
        print_success "Repository propre"
    else
        print_warning "$uncommitted fichiers modifiés"
        echo "Fichiers modifiés:"
        git status --porcelain | head -5
    fi
    echo
}

# 7. FINAL SCORE
calculate_final_score() {
    print_section "7. SCORE FINAL"

    # Calculer le score basé sur les métriques
    score=100

    # Sécurité (critique)
    live_keys=$(grep -r "sk_live_\|pk_live_" --include="*.liquid" --include="*.js" snippets/ sections/ templates/ assets/ 2>/dev/null | wc -l | tr -d ' ')
    score=$((score - live_keys * 50))

    # JSON errors (bloquant)
    json_errors=0
    for file in locales/*.json; do
        if ! python3 -m json.tool "$file" > /dev/null 2>&1; then
            json_errors=$((json_errors + 1))
        fi
    done
    score=$((score - json_errors * 20))

    # Performance (impact modéré)
    images_no_dims=$(grep -r "<img" --include="*.liquid" snippets/ sections/ 2>/dev/null | grep -v -E "width=|height=" | wc -l | tr -d ' ')
    if [ "$images_no_dims" -gt 100 ]; then
        score=$((score - 15))
    fi

    console_logs=$(grep -r "console\." --include="*.liquid" snippets/ sections/ 2>/dev/null | wc -l | tr -d ' ')
    if [ "$console_logs" -gt 50 ]; then
        score=$((score - 10))
    fi

    # Afficher le résultat
    if [ "$score" -ge 90 ]; then
        print_success "EXCELLENT: Score $score/100 - Production Ready! 🚀"
    elif [ "$score" -ge 70 ]; then
        print_warning "BON: Score $score/100 - Quelques optimisations recommandées"
    else
        print_error "CRITIQUE: Score $score/100 - Corrections requises avant production"
        return 1
    fi
    echo
}

# WORKFLOW MODES
case "${1:-quick}" in
    "quick")
        print_header
        run_security_audit
        validate_json
        check_performance
        calculate_final_score
        ;;

    "full")
        print_header
        run_quick_debug
        run_security_audit
        validate_json
        run_auto_corrections
        check_performance
        check_git_status
        calculate_final_score
        ;;

    "deploy")
        print_header
        print_section "DÉPLOIEMENT - VALIDATION COMPLÈTE"

        run_security_audit || exit 1
        validate_json || exit 1
        check_performance
        check_git_status

        print_section "BACKUP PRE-DÉPLOIEMENT"
        backup_dir="../backup-$(date +%Y%m%d_%H%M%S)"
        cp -r . "$backup_dir"
        print_success "Backup créé: $backup_dir"

        calculate_final_score || exit 1

        print_success "✅ PRÊT POUR DÉPLOIEMENT! 🚀"
        ;;

    *)
        echo "Usage: $0 [quick|full|deploy]"
        echo ""
        echo "Modes disponibles:"
        echo "  quick  - Vérifications essentielles (2min)"
        echo "  full   - Audit complet + corrections (5min)"
        echo "  deploy - Validation pre-déploiement + backup"
        exit 1
        ;;
esac

exit 0
