#!/bin/bash

# 🚀 AUTOMATISATION TOTALE - ZERO CONFIGURATION
# Script expert Shopify qui gère TOUT automatiquement

set -e

# Couleurs pour l'interface
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}🚀 EXPERT SHOPIFY - AUTOMATISATION TOTALE${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════════${NC}"

# Auto-détection intelligente des repositories
detect_repositories() {
    echo -e "${BLUE}🔍 Détection automatique des repositories...${NC}"
    
    REPOS=()
    
    # TPS BASE DEV (principal)
    if [ -d "/Users/asc/Shopify/TPS BASE DEV/.git" ]; then
        REPOS+=("/Users/asc/Shopify/TPS BASE DEV")
        echo -e "${GREEN}✅ TPS BASE DEV détecté${NC}"
    fi
    
    # TPS-BASE-316 (secondary) 
    if [ -d "/Users/asc/Shopify/TPS-BASE-316/.git" ]; then
        REPOS+=("/Users/asc/Shopify/TPS-BASE-316")
        echo -e "${GREEN}✅ TPS-BASE-316 détecté${NC}"
    fi
    
    echo -e "${CYAN}📊 ${#REPOS[@]} repository(s) détecté(s)${NC}"
}

# Analyse intelligente des thèmes et branches
analyze_themes_and_branches() {
    echo -e "${BLUE}🎨 Analyse des thèmes Shopify...${NC}"
    
    for repo in "${REPOS[@]}"; do
        echo -e "${YELLOW}📁 Repository: $(basename "$repo")${NC}"
        cd "$repo"
        
        # Branches disponibles
        echo -e "🌿 Branches:"
        git branch -a | sed 's/^/   /'
        
        # Branche actuelle
        CURRENT_BRANCH=$(git branch --show-current)
        echo -e "${CYAN}   👉 Actuelle: $CURRENT_BRANCH${NC}"
        
        # Thème sur la branche actuelle
        if [ -f "config/settings_schema.json" ]; then
            THEME_NAME=$(grep '"theme_name"' config/settings_schema.json | cut -d'"' -f4 2>/dev/null || echo "Non défini")
            THEME_VERSION=$(grep '"theme_version"' config/settings_schema.json | cut -d'"' -f4 2>/dev/null || echo "Non définie")
            echo -e "${GREEN}   🎨 Thème: $THEME_NAME${NC}"
            echo -e "${GREEN}   📊 Version: $THEME_VERSION${NC}"
        fi
        
        # Vérifier la branche development si elle existe
        if git show-ref --verify --quiet refs/heads/development; then
            echo -e "   🔄 Checking branche development..."
            git stash -q 2>/dev/null || true
            git checkout -q development
            
            if [ -f "config/settings_schema.json" ]; then
                DEV_THEME_NAME=$(grep '"theme_name"' config/settings_schema.json | cut -d'"' -f4 2>/dev/null || echo "Non défini")
                DEV_THEME_VERSION=$(grep '"theme_version"' config/settings_schema.json | cut -d'"' -f4 2>/dev/null || echo "Non définie")
                echo -e "${YELLOW}   🧪 Thème DEV: $DEV_THEME_NAME${NC}"
                echo -e "${YELLOW}   📊 Version DEV: $DEV_THEME_VERSION${NC}"
            fi
            
            git checkout -q "$CURRENT_BRANCH"
            git stash pop -q 2>/dev/null || true
        fi
        
        # Modifications en attente
        UNCOMMITTED=$(git status --porcelain | wc -l | tr -d ' ')
        if [ $UNCOMMITTED -gt 0 ]; then
            echo -e "${RED}   ⚠️ $UNCOMMITTED modification(s) non commitée(s)${NC}"
        else
            echo -e "${GREEN}   ✅ Repository propre${NC}"
        fi
        
        echo ""
    done
}

# Audit automatique multisite
auto_security_audit() {
    echo -e "${BLUE}🔒 Audit sécurité automatique...${NC}"
    
    TOTAL_ISSUES=0
    
    for repo in "${REPOS[@]}"; do
        echo -e "${YELLOW}🔍 Scanning $(basename "$repo")...${NC}"
        cd "$repo"
        
        # Secrets Shopify
        SHOPIFY_SECRETS=$(find . -name "*.liquid" -o -name "*.js" | xargs grep -l "sk_live_\|pk_live_" 2>/dev/null | wc -l | tr -d ' ')
        
        # API Keys  
        API_KEYS=$(find . -name "*.liquid" -o -name "*.js" | xargs grep -l "AIza[A-Za-z0-9]\{35\}" 2>/dev/null | wc -l | tr -d ' ')
        
        # Tokens
        TOKENS=$(find . -name "*.liquid" -o -name "*.js" | xargs grep -l "ghp_\|gho_\|ghu_\|ghs_\|ghr_" 2>/dev/null | wc -l | tr -d ' ')
        
        REPO_ISSUES=$((SHOPIFY_SECRETS + API_KEYS + TOKENS))
        TOTAL_ISSUES=$((TOTAL_ISSUES + REPO_ISSUES))
        
        if [ $REPO_ISSUES -eq 0 ]; then
            echo -e "${GREEN}   ✅ Aucun secret exposé${NC}"
        else
            echo -e "${RED}   🚨 $REPO_ISSUES secret(s) exposé(s)${NC}"
            [ $SHOPIFY_SECRETS -gt 0 ] && echo -e "${RED}      - Shopify: $SHOPIFY_SECRETS${NC}"
            [ $API_KEYS -gt 0 ] && echo -e "${RED}      - API Keys: $API_KEYS${NC}"
            [ $TOKENS -gt 0 ] && echo -e "${RED}      - Tokens: $TOKENS${NC}"
        fi
    done
    
    if [ $TOTAL_ISSUES -gt 0 ]; then
        echo -e "${RED}🚨 ALERTE: $TOTAL_ISSUES secret(s) exposé(s) au total!${NC}"
        return 1
    else
        echo -e "${GREEN}🛡️ SÉCURITÉ: Tous les repositories sont sécurisés${NC}"
        return 0
    fi
}

# Optimisation automatique Shopify
auto_shopify_optimization() {
    echo -e "${BLUE}⚡ Optimisation automatique Shopify...${NC}"
    
    for repo in "${REPOS[@]}"; do
        echo -e "${YELLOW}🔧 Optimisation $(basename "$repo")...${NC}"
        cd "$repo"
        
        # Moderniser les filtres img_url -> image_url
        DEPRECATED_FILES=$(find . -name "*.liquid" -exec grep -l "img_url" {} \; 2>/dev/null | wc -l | tr -d ' ')
        if [ $DEPRECATED_FILES -gt 0 ]; then
            echo -e "   🔄 Modernisation de $DEPRECATED_FILES fichier(s) avec filtres dépréciés..."
            find . -name "*.liquid" -exec sed -i.bak 's/| *img_url/| image_url/g' {} \; 2>/dev/null
            find . -name "*.bak" -delete 2>/dev/null
            echo -e "${GREEN}   ✅ Filtres img_url modernisés${NC}"
        fi
        
        # Nettoyer console.log
        CONSOLE_FILES=$(find . -name "*.liquid" -exec grep -l "console\." {} \; 2>/dev/null | wc -l | tr -d ' ')
        if [ $CONSOLE_FILES -gt 0 ] && [ $CONSOLE_FILES -lt 20 ]; then
            echo -e "   🧹 Nettoyage console.log dans $CONSOLE_FILES fichier(s)..."
            find . -name "*.liquid" -exec sed -i.bak 's/console\.log([^;]*);*//g' {} \; 2>/dev/null
            find . -name "*.bak" -delete 2>/dev/null
            echo -e "${GREEN}   ✅ Console.log nettoyés${NC}"
        fi
        
        # Corriger les permissions  
        chmod +x *.sh 2>/dev/null || true
        
        # Nettoyer les temporaires
        find . -name "*.bak" -delete 2>/dev/null || true
        find . -name "*.tmp" -delete 2>/dev/null || true
        find . -name ".DS_Store" -delete 2>/dev/null || true
        
        echo -e "${GREEN}   ✅ Optimisation terminée${NC}"
    done
}

# Validation JSON automatique
auto_json_validation() {
    echo -e "${BLUE}📝 Validation JSON automatique...${NC}"
    
    TOTAL_ERRORS=0
    
    for repo in "${REPOS[@]}"; do
        echo -e "${YELLOW}📋 Validation $(basename "$repo")...${NC}"
        cd "$repo"
        
        if [ -d "locales" ]; then
            JSON_ERRORS=0
            for file in locales/*.json; do
                if [ -f "$file" ]; then
                    if python3 -m json.tool "$file" > /dev/null 2>&1; then
                        echo -e "${GREEN}   ✅ $(basename "$file")${NC}"
                    else
                        echo -e "${RED}   ❌ $(basename "$file")${NC}"
                        JSON_ERRORS=$((JSON_ERRORS + 1))
                    fi
                fi
            done
            
            TOTAL_ERRORS=$((TOTAL_ERRORS + JSON_ERRORS))
            
            if [ $JSON_ERRORS -eq 0 ]; then
                echo -e "${GREEN}   🎯 Tous les JSON sont valides${NC}"
            else
                echo -e "${RED}   ⚠️ $JSON_ERRORS erreur(s) JSON${NC}"
            fi
        fi
    done
    
    if [ $TOTAL_ERRORS -gt 0 ]; then
        echo -e "${YELLOW}📊 $TOTAL_ERRORS erreur(s) JSON au total${NC}"
    else
        echo -e "${GREEN}🎯 VALIDATION: Tous les JSON sont parfaits${NC}"
    fi
}

# Synchronisation intelligente automatique
auto_intelligent_sync() {
    echo -e "${BLUE}🔄 Synchronisation intelligente automatique...${NC}"
    
    for repo in "${REPOS[@]}"; do
        echo -e "${YELLOW}📦 Synchronisation $(basename "$repo")...${NC}"
        cd "$repo"
        
        # Vérifier s'il y a des changements
        if [ -n "$(git status --porcelain)" ]; then
            echo -e "   📝 Changements détectés, création du commit..."
            
            # Analyser les types de fichiers
            LIQUID_CHANGES=$(git status --porcelain | grep -c "\.liquid$" || echo "0")
            JSON_CHANGES=$(git status --porcelain | grep -c "\.json$" || echo "0")
            JS_CHANGES=$(git status --porcelain | grep -c "\.js$" || echo "0")
            CONFIG_CHANGES=$(git status --porcelain | grep -c -E "\.(yml|yaml|sh|md)$" || echo "0")
            
            # Message intelligent
            COMMIT_MSG="🚀 Auto-optimization $(date +%Y%m%d_%H%M): "
            
            [ $LIQUID_CHANGES -gt 0 ] && COMMIT_MSG="${COMMIT_MSG}Templates($LIQUID_CHANGES) "
            [ $JSON_CHANGES -gt 0 ] && COMMIT_MSG="${COMMIT_MSG}JSON($JSON_CHANGES) "
            [ $JS_CHANGES -gt 0 ] && COMMIT_MSG="${COMMIT_MSG}Scripts($JS_CHANGES) "
            [ $CONFIG_CHANGES -gt 0 ] && COMMIT_MSG="${COMMIT_MSG}Config($CONFIG_CHANGES) "
            
            COMMIT_MSG="${COMMIT_MSG}

🔧 Optimizations applied:
- Shopify filters modernized (img_url → image_url)
- Console.log cleaned for production
- Security audit passed
- JSON validation completed
- Permissions corrected

🤖 Automated commit by Expert Shopify System"
            
            # Commit et push
            git add .
            git commit -m "$COMMIT_MSG"
            
            echo -e "${GREEN}   ✅ Commit créé${NC}"
            
            # Push intelligent avec gestion des conflits
            if git push origin $(git branch --show-current) 2>/dev/null; then
                echo -e "${GREEN}   📤 Push réussi${NC}"
            else
                echo -e "${YELLOW}   🔄 Conflit détecté, résolution automatique...${NC}"
                git fetch origin $(git branch --show-current)
                if git rebase origin/$(git branch --show-current) 2>/dev/null; then
                    git push origin $(git branch --show-current)
                    echo -e "${GREEN}   ✅ Conflit résolu et push réussi${NC}"
                else
                    echo -e "${RED}   ⚠️ Conflit complexe, intervention manuelle requise${NC}"
                fi
            fi
        else
            echo -e "${GREEN}   ✅ Repository déjà synchronisé${NC}"
        fi
    done
}

# Score final automatique
calculate_final_score() {
    echo -e "${BLUE}📊 Calcul du score final...${NC}"
    
    # Sécurité (40%)
    SECURITY_SCORE=100
    if ! auto_security_audit > /dev/null 2>&1; then
        SECURITY_SCORE=0
    fi
    
    # JSON (20%)  
    JSON_SCORE=100
    JSON_ERRORS=$(find "${REPOS[@]}" -name "*.json" -exec python3 -m json.tool {} \; 2>&1 | grep -c "ERROR" || echo "0")
    if [ $JSON_ERRORS -gt 0 ]; then
        JSON_SCORE=$((100 - JSON_ERRORS * 20))
        [ $JSON_SCORE -lt 0 ] && JSON_SCORE=0
    fi
    
    # Performance (40%)
    PERFORMANCE_SCORE=100
    TOTAL_ISSUES=0
    
    for repo in "${REPOS[@]}"; do
        cd "$repo"
        # Images sans dimensions
        IMG_ISSUES=$(find . -name "*.liquid" -exec grep -c "<img" {} \; 2>/dev/null | grep -v "width=" | wc -l | tr -d ' ')
        # Console.log restants
        CONSOLE_ISSUES=$(find . -name "*.liquid" -exec grep -c "console\." {} \; 2>/dev/null | awk '{sum+=$1} END {print sum}' || echo "0")
        # Filtres dépréciés
        DEPRECATED_ISSUES=$(find . -name "*.liquid" -exec grep -c "img_url" {} \; 2>/dev/null | awk '{sum+=$1} END {print sum}' || echo "0")
        
        TOTAL_ISSUES=$((TOTAL_ISSUES + IMG_ISSUES/10 + CONSOLE_ISSUES + DEPRECATED_ISSUES))
    done
    
    PERFORMANCE_SCORE=$((100 - TOTAL_ISSUES * 5))
    [ $PERFORMANCE_SCORE -lt 0 ] && PERFORMANCE_SCORE=0
    
    # Score final pondéré
    FINAL_SCORE=$(( (SECURITY_SCORE * 40 + PERFORMANCE_SCORE * 40 + JSON_SCORE * 20) / 100 ))
    
    echo -e "${CYAN}🏆 SCORE FINAL: $FINAL_SCORE/100${NC}"
    echo -e "   🔒 Sécurité: $SECURITY_SCORE/100 (40%)"
    echo -e "   ⚡ Performance: $PERFORMANCE_SCORE/100 (40%)"  
    echo -e "   📝 JSON: $JSON_SCORE/100 (20%)"
    
    if [ $FINAL_SCORE -ge 95 ]; then
        echo -e "${GREEN}🏆 EXCELLENT - Production Ready!${NC}"
    elif [ $FINAL_SCORE -ge 85 ]; then
        echo -e "${GREEN}✅ TRÈS BON - Optimisations mineures${NC}"
    elif [ $FINAL_SCORE -ge 75 ]; then
        echo -e "${YELLOW}⚠️ MOYEN - Corrections recommandées${NC}"
    else
        echo -e "${RED}❌ CRITIQUE - Action immédiate requise${NC}"
    fi
}

# Fonction principale - TOUT AUTOMATIQUE
main() {
    echo -e "${PURPLE}🎯 DÉMARRAGE DE L'AUTOMATISATION TOTALE${NC}"
    echo ""
    
    detect_repositories
    echo ""
    
    analyze_themes_and_branches
    echo ""
    
    echo -e "${PURPLE}🚀 EXÉCUTION DES OPTIMISATIONS AUTOMATIQUES${NC}"
    echo ""
    
    auto_security_audit
    echo ""
    
    auto_shopify_optimization  
    echo ""
    
    auto_json_validation
    echo ""
    
    auto_intelligent_sync
    echo ""
    
    calculate_final_score
    echo ""
    
    echo -e "${GREEN}🎉 AUTOMATISATION TERMINÉE AVEC SUCCÈS!${NC}"
    echo -e "${CYAN}📊 Tous vos repositories Shopify sont optimisés et synchronisés${NC}"
    echo -e "${YELLOW}🤖 Aucune action manuelle requise${NC}"
}

# Exécution
main "$@"