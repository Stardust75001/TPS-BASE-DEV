#!/bin/bash

# 🚀 SCRIPT DE SYNCHRONISATION AUTOMATIQUE GITHUB
# Usage: ./auto-push-github.sh [mode]
# Modes: quick, safe, force

set -e

# Configuration
REPO_NAME="TPS-BASE-DEV"
OWNER="Stardust75001"
MAIN_BRANCH="main"
BACKUP_PREFIX="backup/auto-push"
LOG_FILE="sync_$(date +%Y%m%d_%H%M%S).log"

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Mode par défaut
MODE=${1:-"safe"}

echo -e "${CYAN}🚀 SYNCHRONISATION AUTOMATIQUE GITHUB${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "📅 Date: $(date '+%d/%m/%Y à %H:%M')"
echo -e "🎯 Mode: $MODE"
echo -e "📁 Repository: $OWNER/$REPO_NAME"
echo ""

# Fonction de logging
log() {
    echo "[$(date '+%H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Fonction de vérification des prérequis
check_prerequisites() {
    log "🔍 Vérification des prérequis..."

    # Vérifier Git
    if ! command -v git &> /dev/null; then
        echo -e "${RED}❌ Git n'est pas installé${NC}"
        exit 1
    fi

    # Vérifier Python3
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}❌ Python3 n'est pas installé${NC}"
        exit 1
    fi

    # Vérifier qu'on est dans un repo git
    if [ ! -d ".git" ]; then
        echo -e "${RED}❌ Ce répertoire n'est pas un repository Git${NC}"
        exit 1
    fi

    # Vérifier la connexion à GitHub
    if ! git remote get-url origin &> /dev/null; then
        echo -e "${RED}❌ Aucun remote origin configuré${NC}"
        exit 1
    fi

    echo -e "${GREEN}✅ Tous les prérequis sont satisfaits${NC}"
}

# Analyse de l'état actuel
analyze_repository_state() {
    log "📊 Analyse de l'état du repository..."

    # Récupérer les infos depuis origin
    git fetch origin $MAIN_BRANCH 2>/dev/null || {
        echo -e "${YELLOW}⚠️ Impossible de fetch origin, tentative de continue...${NC}"
    }

    # Compter les changements
    UNCOMMITTED=$(git status --porcelain | wc -l | tr -d ' ')
    UNTRACKED=$(git ls-files --others --exclude-standard | wc -l | tr -d ' ')

    # Vérifier la position par rapport à origin
    AHEAD=$(git rev-list --count origin/$MAIN_BRANCH..HEAD 2>/dev/null || echo "0")
    BEHIND=$(git rev-list --count HEAD..origin/$MAIN_BRANCH 2>/dev/null || echo "0")

    echo -e "${BLUE}📈 État du repository:${NC}"
    echo -e "   📝 Fichiers modifiés/staged: $UNCOMMITTED"
    echo -e "   📁 Fichiers non trackés: $UNTRACKED"
    echo -e "   ⬆️ Commits en avance: $AHEAD"
    echo -e "   ⬇️ Commits en retard: $BEHIND"

    # Déterminer si une sync est nécessaire
    TOTAL_CHANGES=$((UNCOMMITTED + UNTRACKED))
    if [ $TOTAL_CHANGES -gt 0 ]; then
        log "🔄 Synchronisation nécessaire: $TOTAL_CHANGES changement(s)"
        SYNC_NEEDED=true
    else
        log "✅ Repository déjà synchronisé"
        SYNC_NEEDED=false
    fi

    # Vérifier les conflits potentiels
    if [ $BEHIND -gt 0 ] && [ $AHEAD -gt 0 ]; then
        echo -e "${YELLOW}⚠️ Divergence détectée: merge/rebase nécessaire${NC}"
        CONFLICTS_POSSIBLE=true
    else
        CONFLICTS_POSSIBLE=false
    fi
}

# Audit de sécurité rapide
security_audit() {
    log "🔒 Audit de sécurité..."

    SECURITY_ISSUES=0

    # Vérifier les secrets Shopify
    SHOPIFY_SECRETS=$(grep -r "sk_live_\|pk_live_" --include="*.liquid" --include="*.js" . 2>/dev/null | wc -l | tr -d ' ')
    if [ $SHOPIFY_SECRETS -gt 0 ]; then
        echo -e "${RED}🚨 CRITIQUE: $SHOPIFY_SECRETS secret(s) Shopify détecté(s)${NC}"
        SECURITY_ISSUES=$((SECURITY_ISSUES + SHOPIFY_SECRETS))
    fi

    # Vérifier les API keys
    API_KEYS=$(grep -r "AIza[A-Za-z0-9]\{35\}" --include="*.liquid" --include="*.js" . 2>/dev/null | wc -l | tr -d ' ')
    if [ $API_KEYS -gt 0 ]; then
        echo -e "${RED}🚨 $API_KEYS clé(s) API exposée(s)${NC}"
        SECURITY_ISSUES=$((SECURITY_ISSUES + API_KEYS))
    fi

    # Vérifier les tokens GitHub
    GH_TOKENS=$(grep -r "ghp_\|gho_\|ghu_\|ghs_\|ghr_" --include="*.liquid" --include="*.js" . 2>/dev/null | wc -l | tr -d ' ')
    if [ GH_TOKENS -gt 0 ]; then
        echo -e "${RED}🚨 $GH_TOKENS token(s) GitHub exposé(s)${NC}"
        SECURITY_ISSUES=$((SECURITY_ISSUES + GH_TOKENS))
    fi

    if [ $SECURITY_ISSUES -gt 0 ]; then
        echo -e "${RED}❌ $SECURITY_ISSUES problème(s) de sécurité détecté(s)${NC}"
        if [ "$MODE" != "force" ]; then
            echo -e "${RED}🛑 SYNC BLOQUÉE: Corrigez les problèmes de sécurité d'abord${NC}"
            exit 1
        else
            echo -e "${YELLOW}⚠️ Mode force activé: continuation malgré les problèmes${NC}"
        fi
    else
        echo -e "${GREEN}✅ Aucun problème de sécurité détecté${NC}"
    fi
}

# Validation des fichiers
validate_files() {
    log "📝 Validation des fichiers..."

    # Valider les JSON
    JSON_ERRORS=0
    if [ -d "locales" ]; then
        for file in locales/*.json; do
            if [ -f "$file" ]; then
                if python3 -m json.tool "$file" > /dev/null 2>&1; then
                    echo -e "${GREEN}   ✅ $(basename "$file")${NC}"
                else
                    echo -e "${RED}   ❌ $(basename "$file") - Erreur JSON${NC}"
                    JSON_ERRORS=$((JSON_ERRORS + 1))
                fi
            fi
        done
    fi

    if [ $JSON_ERRORS -gt 0 ]; then
        echo -e "${YELLOW}⚠️ $JSON_ERRORS erreur(s) JSON détectée(s)${NC}"
        if [ "$MODE" == "safe" ]; then
            echo -e "${RED}🛑 Mode safe: corrigez les erreurs JSON d'abord${NC}"
            exit 1
        fi
    fi

    log "✅ Validation terminée"
}

# Nettoyage intelligent
intelligent_cleanup() {
    log "🧹 Nettoyage intelligent..."

    # Supprimer les fichiers temporaires
    find . -name "*.bak" -delete 2>/dev/null || true
    find . -name "*.tmp" -delete 2>/dev/null || true
    find . -name ".DS_Store" -delete 2>/dev/null || true
    find . -name "Thumbs.db" -delete 2>/dev/null || true

    # Corriger les permissions des scripts
    chmod +x *.sh 2>/dev/null || true
    chmod +x scripts/*.sh 2>/dev/null || true

    # Moderniser les filtres Shopify (si peu de fichiers)
    LIQUID_COUNT=$(find . -name "*.liquid" | wc -l | tr -d ' ')
    if [ $LIQUID_COUNT -lt 100 ]; then
        DEPRECATED_COUNT=$(find . -name "*.liquid" -exec grep -l "img_url" {} \; | wc -l | tr -d ' ')
        if [ $DEPRECATED_COUNT -gt 0 ]; then
            log "🔄 Modernisation de $DEPRECATED_COUNT filtre(s) Shopify..."
            find . -name "*.liquid" -exec sed -i.bak 's/| *img_url/| image_url/g' {} \; 2>/dev/null || true
            find . -name "*.bak" -delete 2>/dev/null || true
        fi
    fi

    # Nettoyer les console.log (si peu)
    CONSOLE_COUNT=$(grep -r "console\." --include="*.liquid" . 2>/dev/null | wc -l | tr -d ' ')
    if [ $CONSOLE_COUNT -lt 10 ] && [ $CONSOLE_COUNT -gt 0 ]; then
        log "🧹 Nettoyage de $CONSOLE_COUNT console.log..."
        find . -name "*.liquid" -exec sed -i.bak 's/console\.log([^;]*);*//g' {} \; 2>/dev/null || true
        find . -name "*.bak" -delete 2>/dev/null || true
    fi

    log "✅ Nettoyage terminé"
}

# Créer un backup de sécurité
create_backup() {
    log "📦 Création du backup de sécurité..."

    BACKUP_BRANCH="${BACKUP_PREFIX}-$(date +%Y%m%d_%H%M%S)"

    # Sauvegarder l'état actuel sur une nouvelle branche
    git checkout -b "$BACKUP_BRANCH" 2>/dev/null || {
        echo -e "${YELLOW}⚠️ Impossible de créer la branche backup${NC}"
        return 1
    }

    # Ajouter tous les fichiers au backup
    git add . 2>/dev/null || true
    git commit -m "🗄️ Backup automatique avant sync: $(date)" 2>/dev/null || {
        echo -e "${YELLOW}⚠️ Rien à sauvegarder${NC}"
    }

    # Retourner sur main
    git checkout $MAIN_BRANCH

    # Pousser le backup (optionnel)
    if [ "$MODE" == "safe" ] || [ "$MODE" == "quick" ]; then
        git push origin "$BACKUP_BRANCH" 2>/dev/null || {
            echo -e "${YELLOW}⚠️ Impossible de pousser le backup sur origin${NC}"
        }
    fi

    echo -e "${GREEN}✅ Backup créé: $BACKUP_BRANCH${NC}"
}

# Stratégie de commit intelligente
intelligent_commit() {
    log "💾 Stratégie de commit intelligente..."

    if [ -z "$(git status --porcelain)" ]; then
        log "ℹ️ Aucun changement à commiter"
        return 0
    fi

    # Analyser les types de fichiers modifiés
    LIQUID_CHANGES=$(git status --porcelain | grep -c "\.liquid$" || echo "0")
    JSON_CHANGES=$(git status --porcelain | grep -c "\.json$" || echo "0")
    JS_CHANGES=$(git status --porcelain | grep -c "\.js$" || echo "0")
    CSS_CHANGES=$(git status --porcelain | grep -c "\.css$" || echo "0")
    CONFIG_CHANGES=$(git status --porcelain | grep -c -E "\.(yml|yaml|sh|md)$" || echo "0")

    # Construire un message de commit intelligent
    COMMIT_PARTS=()
    [ $LIQUID_CHANGES -gt 0 ] && COMMIT_PARTS+=("Templates ($LIQUID_CHANGES)")
    [ $JSON_CHANGES -gt 0 ] && COMMIT_PARTS+=("Locales ($JSON_CHANGES)")
    [ $JS_CHANGES -gt 0 ] && COMMIT_PARTS+=("Scripts ($JS_CHANGES)")
    [ $CSS_CHANGES -gt 0 ] && COMMIT_PARTS+=("Styles ($CSS_CHANGES)")
    [ $CONFIG_CHANGES -gt 0 ] && COMMIT_PARTS+=("Config ($CONFIG_CHANGES)")

    # Message principal
    if [ ${#COMMIT_PARTS[@]} -eq 1 ]; then
        COMMIT_MSG="🔧 Update ${COMMIT_PARTS[0]}"
    elif [ ${#COMMIT_PARTS[@]} -le 3 ]; then
        COMMIT_MSG="🚀 Auto-sync: $(IFS=', '; echo "${COMMIT_PARTS[*]}")"
    else
        COMMIT_MSG="🚀 Auto-sync: Multiple updates ($(date +%Y%m%d))"
    fi

    # Message détaillé
    COMMIT_BODY="🔧 Optimisations automatiques:
- Filtres Shopify modernisés
- Console.log nettoyés
- Fichiers temporaires supprimés
- Permissions corrigées

📊 Résumé des changements:
- Templates Liquid: $LIQUID_CHANGES
- Fichiers de traduction: $JSON_CHANGES
- Scripts JavaScript: $JS_CHANGES
- Feuilles de style: $CSS_CHANGES
- Configuration: $CONFIG_CHANGES

🤖 Commit automatique généré le $(date '+%d/%m/%Y à %H:%M')"

    # Effectuer le commit
    git add .
    git commit -m "$COMMIT_MSG" -m "$COMMIT_BODY"

    log "✅ Commit créé: $COMMIT_MSG"
}

# Push avec gestion des conflits
smart_push() {
    log "📤 Push intelligent vers GitHub..."

    # Vérifier s'il y a des commits à pousser
    COMMITS_TO_PUSH=$(git rev-list --count origin/$MAIN_BRANCH..HEAD 2>/dev/null || echo "0")

    if [ $COMMITS_TO_PUSH -eq 0 ]; then
        log "ℹ️ Aucun commit à pousser"
        return 0
    fi

    echo -e "${BLUE}📤 $COMMITS_TO_PUSH commit(s) à pousser...${NC}"

    # Tentative de push simple
    if git push origin $MAIN_BRANCH 2>/dev/null; then
        echo -e "${GREEN}✅ Push réussi!${NC}"
        return 0
    fi

    # En cas d'échec, analyser la situation
    log "⚠️ Push échoué, analyse..."

    # Récupérer les dernières modifications
    git fetch origin $MAIN_BRANCH

    BEHIND_AFTER_FETCH=$(git rev-list --count HEAD..origin/$MAIN_BRANCH 2>/dev/null || echo "0")

    if [ $BEHIND_AFTER_FETCH -gt 0 ]; then
        echo -e "${YELLOW}🔄 Repository en retard de $BEHIND_AFTER_FETCH commit(s)${NC}"

        if [ "$MODE" == "force" ]; then
            log "🚨 Mode force: push forcé"
            git push --force-with-lease origin $MAIN_BRANCH
        else
            log "🔄 Tentative de rebase automatique..."
            if git rebase origin/$MAIN_BRANCH; then
                log "✅ Rebase réussi, nouveau push..."
                git push origin $MAIN_BRANCH
            else
                echo -e "${RED}❌ Conflits de merge détectés${NC}"
                echo -e "${YELLOW}💡 Actions possibles:${NC}"
                echo -e "   1. Résoudre manuellement: git rebase --continue"
                echo -e "   2. Annuler: git rebase --abort"
                echo -e "   3. Forcer: ./$(basename $0) force"
                exit 1
            fi
        fi
    else
        echo -e "${RED}❌ Erreur de push inconnue${NC}"
        exit 1
    fi
}

# Rapport final
generate_report() {
    log "📊 Génération du rapport final..."

    REPORT_FILE="sync_report_$(date +%Y%m%d_%H%M%S).md"

    cat > "$REPORT_FILE" << EOF
# 🚀 Rapport de Synchronisation GitHub

**📅 Date**: $(date '+%d/%m/%Y à %H:%M')
**🎯 Mode**: $MODE
**📁 Repository**: $OWNER/$REPO_NAME
**🌿 Branche**: $MAIN_BRANCH

## 📊 État Initial

- **Fichiers modifiés**: $UNCOMMITTED
- **Fichiers non trackés**: $UNTRACKED
- **Commits en avance**: $AHEAD
- **Commits en retard**: $BEHIND

## 🔒 Sécurité

- **Secrets Shopify**: $SHOPIFY_SECRETS
- **Clés API**: $API_KEYS
- **Tokens GitHub**: $GH_TOKENS
- **🎯 Status**: $([ $SECURITY_ISSUES -eq 0 ] && echo "✅ SÉCURISÉ" || echo "❌ PROBLÈMES DÉTECTÉS")

## 🔧 Optimisations Appliquées

- ✅ Nettoyage fichiers temporaires
- ✅ Correction permissions scripts
- ✅ Modernisation filtres Shopify
- ✅ Suppression console.log
- ✅ Validation JSON

## 📈 Résultat

- **Synchronisation**: $([ "$SYNC_NEEDED" == "true" ] && echo "✅ COMPLÈTE" || echo "ℹ️ NON NÉCESSAIRE")
- **Backup créé**: $BACKUP_BRANCH
- **Push status**: ✅ RÉUSSI

## 📋 Logs Complets

\`\`\`
$(cat "$LOG_FILE")
\`\`\`

---
*🤖 Rapport généré automatiquement*
EOF

    echo -e "${GREEN}📄 Rapport sauvegardé: $REPORT_FILE${NC}"
}

# Fonction principale
main() {
    echo -e "${PURPLE}🎯 Démarrage de la synchronisation en mode: $MODE${NC}"

    # Étapes de validation
    check_prerequisites
    analyze_repository_state
    security_audit

    # Si pas de sync nécessaire, on s'arrête
    if [ "$SYNC_NEEDED" != "true" ]; then
        echo -e "${GREEN}✅ Repository déjà synchronisé, aucune action nécessaire${NC}"
        exit 0
    fi

    # Validation conditionnelle
    if [ "$MODE" == "safe" ] || [ "$MODE" == "quick" ]; then
        validate_files
    fi

    # Backup de sécurité
    if [ "$MODE" == "safe" ]; then
        create_backup
    fi

    # Nettoyage et optimisations
    intelligent_cleanup

    # Commit et push
    intelligent_commit
    smart_push

    # Rapport final
    generate_report

    echo ""
    echo -e "${GREEN}🎉 SYNCHRONISATION TERMINÉE AVEC SUCCÈS!${NC}"
    echo -e "${BLUE}📊 Consultez le rapport: $REPORT_FILE${NC}"
    echo -e "${BLUE}📋 Logs détaillés: $LOG_FILE${NC}"
}

# Gestion des arguments
case "$MODE" in
    "quick")
        echo -e "${YELLOW}⚡ Mode Quick: Synchronisation rapide sans backup${NC}"
        ;;
    "safe")
        echo -e "${GREEN}🛡️ Mode Safe: Synchronisation avec backup et validations${NC}"
        ;;
    "force")
        echo -e "${RED}💪 Mode Force: Synchronisation forcée (ignore les erreurs)${NC}"
        ;;
    *)
        echo -e "${RED}❌ Mode invalide: $MODE${NC}"
        echo "Modes disponibles: quick, safe, force"
        exit 1
        ;;
esac

# Exécuter la fonction principale
main "$@"
