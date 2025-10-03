#!/bin/bash

# 🚀 CONTRÔLEUR AUTO-PUSH SYSTÈME - Expert Shopify System
# Gestion centralisée de l'auto-push VS Code

set -e

DAEMON_SCRIPT="./vscode-autopush-daemon.sh"
PID_FILE="$HOME/.vscode-autopush.pid"
LOG_FILE="$HOME/.vscode-autopush.log"

# Couleurs pour output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 CONTRÔLEUR AUTO-PUSH VS CODE${NC}"
echo "════════════════════════════════════════"

# Fonction pour vérifier le statut
check_status() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p $PID > /dev/null 2>&1; then
            echo -e "${GREEN}✅ AUTO-PUSH ACTIF${NC} (PID: $PID)"
            return 0
        else
            echo -e "${RED}❌ PID file existe mais processus mort${NC}"
            rm -f "$PID_FILE"
            return 1
        fi
    else
        echo -e "${YELLOW}⚪ AUTO-PUSH INACTIF${NC}"
        return 1
    fi
}

# Menu principal
show_menu() {
    echo ""
    echo "📋 OPTIONS DISPONIBLES:"
    echo "1) ▶️  Démarrer auto-push"
    echo "2) ⏹️  Arrêter auto-push"
    echo "3) 📊 Statut actuel"
    echo "4) 📜 Voir logs récents"
    echo "5) 🧹 Nettoyer logs"
    echo "6) 🧪 Test manuel auto-push"
    echo "7) ❌ Quitter"
    echo ""
}

# Démarrer le daemon
start_daemon() {
    if check_status > /dev/null 2>&1; then
        echo -e "${YELLOW}⚠️  Auto-push déjà actif${NC}"
        return
    fi
    
    echo -e "${BLUE}🚀 Démarrage auto-push daemon...${NC}"
    
    # Démarrer en arrière-plan
    nohup "$DAEMON_SCRIPT" > /dev/null 2>&1 &
    sleep 2
    
    if check_status > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Auto-push démarré avec succès${NC}"
    else
        echo -e "${RED}❌ Échec démarrage auto-push${NC}"
    fi
}

# Arrêter le daemon
stop_daemon() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        echo -e "${BLUE}🛑 Arrêt auto-push (PID: $PID)...${NC}"
        
        kill $PID 2>/dev/null || true
        sleep 2
        
        if ! ps -p $PID > /dev/null 2>&1; then
            rm -f "$PID_FILE"
            echo -e "${GREEN}✅ Auto-push arrêté${NC}"
        else
            kill -9 $PID 2>/dev/null || true
            rm -f "$PID_FILE"
            echo -e "${YELLOW}⚠️  Auto-push forcé à l'arrêt${NC}"
        fi
    else
        echo -e "${YELLOW}⚪ Aucun auto-push en cours${NC}"
    fi
}

# Afficher logs
show_logs() {
    if [ -f "$LOG_FILE" ]; then
        echo -e "${BLUE}📜 LOGS AUTO-PUSH (10 dernières lignes):${NC}"
        echo "──────────────────────────────────────"
        tail -10 "$LOG_FILE"
    else
        echo -e "${YELLOW}📜 Aucun log disponible${NC}"
    fi
}

# Nettoyer logs
clean_logs() {
    if [ -f "$LOG_FILE" ]; then
        > "$LOG_FILE"
        echo -e "${GREEN}🧹 Logs nettoyés${NC}"
    else
        echo -e "${YELLOW}🧹 Aucun log à nettoyer${NC}"
    fi
}

# Test manuel
test_manual() {
    echo -e "${BLUE}🧪 Test manuel auto-push...${NC}"
    
    if [ -n "$(git status --porcelain)" ]; then
        echo -e "${GREEN}📝 Changements détectés, test push...${NC}"
        ./auto-push-on-close.sh
    else
        echo -e "${YELLOW}✅ Aucun changement détecté${NC}"
    fi
}

# Menu interactif
while true; do
    show_menu
    read -p "🎯 Choisir une option (1-7): " choice
    
    case $choice in
        1) start_daemon ;;
        2) stop_daemon ;;
        3) check_status ;;
        4) show_logs ;;
        5) clean_logs ;;
        6) test_manual ;;
        7) echo -e "${GREEN}👋 Au revoir!${NC}"; exit 0 ;;
        *) echo -e "${RED}❌ Option invalide${NC}" ;;
    esac
    
    echo ""
    read -p "Appuyer sur Entrée pour continuer..."
    clear
done