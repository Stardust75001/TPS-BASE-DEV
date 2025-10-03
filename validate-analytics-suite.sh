#!/bin/bash

# 🚀 ANALYTICS SUITE VALIDATION - PROFESSIONAL EDITION
# ====================================================
#
# Script de validation complète du système analytics.
# Vérifie configuration, connectivité, performance et sécurité.
#
# Usage: ./validate-analytics-suite.sh
#
# Développé par Expert Shopify | Version: 2.0.0

set -e

# ===================================================================
# CONFIGURATION
# ===================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_DIR="$SCRIPT_DIR"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="analytics_validation_${TIMESTAMP}.log"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Compteurs de résultats
PASSED=0
FAILED=0
WARNINGS=0

# ===================================================================
# UTILITAIRES
# ===================================================================

log() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

success() {
    log "${GREEN}✅ $1${NC}"
    ((PASSED++))
}

error() {
    log "${RED}❌ $1${NC}"
    ((FAILED++))
}

warning() {
    log "${YELLOW}⚠️  $1${NC}"
    ((WARNINGS++))
}

info() {
    log "${BLUE}ℹ️  $1${NC}"
}

header() {
    log ""
    log "${PURPLE}=== $1 ===${NC}"
    log ""
}

# ===================================================================
# VALIDATIONS
# ===================================================================

validate_environment() {
    header "VALIDATION ENVIRONNEMENT"

    # Vérifier fichier .env
    if [[ -f "$THEME_DIR/.env" ]]; then
        success "Fichier .env trouvé"

        # Compter les variables
        env_vars=$(grep -c "^[A-Z].*=" "$THEME_DIR/.env" || echo "0")
        if [[ $env_vars -gt 20 ]]; then
            success "Configuration .env complète ($env_vars variables)"
        else
            warning "Configuration .env incomplète ($env_vars variables)"
        fi

        # Vérifier variables critiques
        critical_vars=("GTM_CONTAINER_ID" "GA4_MEASUREMENT_ID" "FACEBOOK_PIXEL_ID" "SHOPIFY_ADMIN_TOKEN")
        for var in "${critical_vars[@]}"; do
            if grep -q "^${var}=" "$THEME_DIR/.env"; then
                success "Variable critique ${var} présente"
            else
                error "Variable critique ${var} manquante"
            fi
        done

    else
        error "Fichier .env non trouvé"
    fi

    # Vérifier Node.js
    if command -v node >/dev/null 2>&1; then
        node_version=$(node --version)
        success "Node.js disponible ($node_version)"
    else
        warning "Node.js non trouvé - scripts d'injection indisponibles"
    fi

    # Vérifier Shopify CLI
    if command -v shopify >/dev/null 2>&1; then
        shopify_version=$(shopify version)
        success "Shopify CLI disponible ($shopify_version)"
    else
        warning "Shopify CLI non trouvé - déploiement manuel requis"
    fi
}

validate_files_structure() {
    header "VALIDATION STRUCTURE FICHIERS"

    # Fichiers requis
    required_files=(
        "config/settings_schema.json"
        "layout/theme.liquid"
        "snippets/analytics-config.liquid"
        "snippets/analytics-tracking.liquid"
        "snippets/turnstile.liquid"
        "snippets/meta-tags.liquid"
        "assets/analytics-config-manager.js"
        "analytics-env-injector.js"
    )

    for file in "${required_files[@]}"; do
        if [[ -f "$THEME_DIR/$file" ]]; then
            success "Fichier $file présent"
        else
            error "Fichier $file manquant"
        fi
    done

    # Vérifier intégration theme.liquid
    if grep -q "analytics-config" "$THEME_DIR/layout/theme.liquid"; then
        success "Intégration analytics dans theme.liquid"
    else
        error "Analytics non intégrés dans theme.liquid"
    fi

    # Vérifier settings_schema.json
    if grep -q "Analytics & Tracking Professional" "$THEME_DIR/config/settings_schema.json"; then
        success "Section Analytics dans settings_schema.json"
    else
        error "Section Analytics manquante dans settings_schema.json"
    fi
}

validate_configuration_integrity() {
    header "VALIDATION INTÉGRITÉ CONFIGURATION"

    # Vérifier formats d'IDs dans .env
    if [[ -f "$THEME_DIR/.env" ]]; then
        # GTM ID
        if grep -qE "^GTM_CONTAINER_ID=\"?GTM-[A-Z0-9]{6,8}\"?" "$THEME_DIR/.env"; then
            success "Format GTM Container ID valide"
        else
            warning "Format GTM Container ID invalide ou manquant"
        fi

        # GA4 ID
        if grep -qE "^GA4_MEASUREMENT_ID=\"?G-[A-Z0-9]{10}\"?" "$THEME_DIR/.env"; then
            success "Format GA4 Measurement ID valide"
        else
            warning "Format GA4 Measurement ID invalide ou manquant"
        fi

        # Facebook Pixel
        if grep -qE "^FACEBOOK_PIXEL_ID=\"?[0-9]{15,16}\"?" "$THEME_DIR/.env"; then
            success "Format Facebook Pixel ID valide"
        else
            warning "Format Facebook Pixel ID invalide ou manquant"
        fi

        # Sentry DSN
        if grep -qE "^SENTRY_DSN=\"?https://.*@sentry\\.io/.*\"?" "$THEME_DIR/.env"; then
            success "Format Sentry DSN valide"
        else
            info "Sentry DSN non configuré (optionnel)"
        fi

        # Turnstile
        if grep -qE "^TURNSTILE_SITE_KEY=\"?0x[A-Za-z0-9_-]{30,50}\"?" "$THEME_DIR/.env"; then
            success "Format Turnstile Site Key valide"
        else
            info "Turnstile non configuré (optionnel)"
        fi
    fi

    # Vérifier cohérence entre .env et snippets
    if [[ -f "$THEME_DIR/snippets/analytics-config.liquid" ]]; then
        if grep -q "window.analyticsEnvConfig" "$THEME_DIR/snippets/analytics-config.liquid"; then
            success "Configuration JavaScript dans analytics-config.liquid"
        else
            warning "Configuration JavaScript manquante dans snippet"
        fi
    fi
}

validate_security() {
    header "VALIDATION SÉCURITÉ"

    # Vérifier protection .env
    if [[ -f "$THEME_DIR/.gitignore" ]]; then
        if grep -q "\.env" "$THEME_DIR/.gitignore"; then
            success "Fichier .env protégé dans .gitignore"
        else
            error "Fichier .env non protégé - RISQUE DE SÉCURITÉ"
        fi
    else
        warning "Fichier .gitignore manquant"
    fi

    # Vérifier tokens dans le code source
    liquid_files=$(find "$THEME_DIR" -name "*.liquid" -type f)
    token_found=false

    for file in $liquid_files; do
        if grep -qE "(shpat_|shptka_)" "$file"; then
            error "Token Shopify trouvé dans $file - RISQUE DE SÉCURITÉ"
            token_found=true
        fi
    done

    if [[ "$token_found" == false ]]; then
        success "Aucun token hardcodé trouvé dans les templates"
    fi

    # Vérifier permissions fichiers sensibles
    if [[ -f "$THEME_DIR/.env" ]]; then
        env_perms=$(stat -c "%a" "$THEME_DIR/.env" 2>/dev/null || stat -f "%Lp" "$THEME_DIR/.env" 2>/dev/null || echo "unknown")
        if [[ "$env_perms" == "600" ]] || [[ "$env_perms" == "400" ]]; then
            success "Permissions .env sécurisées ($env_perms)"
        else
            warning "Permissions .env à vérifier ($env_perms)"
        fi
    fi
}

validate_performance() {
    header "VALIDATION PERFORMANCE"

    # Vérifier taille des assets
    if [[ -f "$THEME_DIR/assets/analytics-config-manager.js" ]]; then
        file_size=$(wc -c < "$THEME_DIR/assets/analytics-config-manager.js")
        if [[ $file_size -lt 50000 ]]; then # 50KB
            success "Taille analytics-config-manager.js optimisée (${file_size} bytes)"
        else
            warning "Taille analytics-config-manager.js importante (${file_size} bytes)"
        fi
    fi

    # Vérifier chargement différé dans snippets
    if grep -q "defer\\|async" "$THEME_DIR/snippets/analytics-tracking.liquid"; then
        success "Chargement asynchrone configuré"
    else
        warning "Chargement synchrone détecté - impact performance possible"
    fi

    # Vérifier lazy loading
    if grep -q "load_strategy.*lazy" "$THEME_DIR/snippets/analytics-tracking.liquid"; then
        success "Stratégie de chargement différé activée"
    else
        info "Stratégie de chargement immédiat configurée"
    fi
}

validate_analytics_services() {
    header "VALIDATION SERVICES ANALYTICS"

    # Services dans analytics-tracking.liquid
    services=("Google Tag Manager" "Google Analytics" "Facebook Pixel" "Sentry" "Turnstile")

    for service in "${services[@]}"; do
        case "$service" in
            "Google Tag Manager")
                if grep -q "googletagmanager.com/gtm.js" "$THEME_DIR/snippets/analytics-tracking.liquid"; then
                    success "Service $service configuré"
                else
                    info "Service $service non configuré"
                fi
                ;;
            "Google Analytics")
                if grep -q "gtag\\|analytics" "$THEME_DIR/snippets/analytics-tracking.liquid"; then
                    success "Service $service configuré"
                else
                    info "Service $service non configuré"
                fi
                ;;
            "Facebook Pixel")
                if grep -q "fbq\\|facebook" "$THEME_DIR/snippets/analytics-tracking.liquid"; then
                    success "Service $service configuré"
                else
                    info "Service $service non configuré"
                fi
                ;;
            "Sentry")
                if grep -q "sentry" "$THEME_DIR/snippets/analytics-tracking.liquid"; then
                    success "Service $service configuré"
                else
                    info "Service $service non configuré"
                fi
                ;;
            "Turnstile")
                if grep -q "turnstile\\|cloudflare" "$THEME_DIR/snippets/analytics-tracking.liquid"; then
                    success "Service $service configuré"
                else
                    info "Service $service non configuré"
                fi
                ;;
        esac
    done
}

test_connectivity() {
    header "TEST CONNECTIVITÉ"

    # Test des domaines analytics
    domains=("www.googletagmanager.com" "www.google-analytics.com" "connect.facebook.net" "challenges.cloudflare.com")

    for domain in "${domains[@]}"; do
        if command -v curl >/dev/null 2>&1; then
            if curl -s --connect-timeout 5 "https://$domain" >/dev/null 2>&1; then
                success "Connectivité $domain OK"
            else
                warning "Connectivité $domain échouée"
            fi
        else
            info "Curl non disponible - test connectivité ignoré"
            break
        fi
    done

    # Test injection script
    if [[ -f "$THEME_DIR/analytics-env-injector.js" ]] && command -v node >/dev/null 2>&1; then
        info "Test d'injection des variables d'environnement..."
        if node "$THEME_DIR/analytics-env-injector.js" --dry-run 2>/dev/null; then
            success "Script d'injection fonctionnel"
        else
            warning "Script d'injection nécessite configuration"
        fi
    fi
}

generate_report() {
    header "RAPPORT DE VALIDATION"

    local total=$((PASSED + FAILED + WARNINGS))
    local success_rate=0

    if [[ $total -gt 0 ]]; then
        success_rate=$((PASSED * 100 / total))
    fi

    log "📊 Résultats de validation:"
    log "   ✅ Tests réussis: $PASSED"
    log "   ❌ Tests échoués: $FAILED"
    log "   ⚠️  Avertissements: $WARNINGS"
    log "   📈 Taux de réussite: ${success_rate}%"
    log ""

    if [[ $FAILED -eq 0 ]]; then
        if [[ $WARNINGS -eq 0 ]]; then
            log "${GREEN}🎉 EXCELLENT ! Analytics Suite parfaitement configuré${NC}"
        else
            log "${YELLOW}✅ BON ! Analytics Suite opérationnel avec quelques améliorations possibles${NC}"
        fi
    else
        log "${RED}❌ ATTENTION ! Problèmes critiques détectés${NC}"
    fi

    log ""
    log "📝 Rapport détaillé sauvé dans: $LOG_FILE"

    # Recommandations
    if [[ $FAILED -gt 0 ]] || [[ $WARNINGS -gt 0 ]]; then
        log ""
        log "🔧 Actions recommandées:"

        if [[ $FAILED -gt 0 ]]; then
            log "   1. Corriger les erreurs critiques listées ci-dessus"
            log "   2. Re-exécuter la validation après corrections"
        fi

        if [[ $WARNINGS -gt 0 ]]; then
            log "   3. Réviser les avertissements pour optimisation"
        fi

        log "   4. Consulter README-ANALYTICS-SUITE-PROFESSIONAL.md"
        log "   5. Tester en environnement de développement"
    else
        log ""
        log "🚀 Prêt pour déploiement en production !"
    fi
}

# ===================================================================
# EXÉCUTION PRINCIPALE
# ===================================================================

main() {
    log "${PURPLE}🚀 ANALYTICS SUITE VALIDATION - PROFESSIONAL EDITION${NC}"
    log "${PURPLE}====================================================${NC}"
    log ""
    log "Début validation: $(date)"
    log "Répertoire thème: $THEME_DIR"
    log ""

    # Exécuter toutes les validations
    validate_environment
    validate_files_structure
    validate_configuration_integrity
    validate_security
    validate_performance
    validate_analytics_services
    test_connectivity

    # Générer le rapport final
    generate_report

    # Code de sortie selon les résultats
    if [[ $FAILED -gt 0 ]]; then
        exit 1
    else
        exit 0
    fi
}

# Exécution si appelé directement
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
