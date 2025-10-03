#!/bin/bash

# 🚀 VSCODE AUTO-PUSH DAEMON - Expert Shopify System
# Surveillance en arrière-plan pour auto-push lors de fermeture VS Code

set -e

LOG_FILE="$HOME/.vscode-autopush.log"
PID_FILE="$HOME/.vscode-autopush.pid"
WORKSPACE_DIR="/Users/asc/Shopify/TPS BASE DEV"

echo "🔄 Démarrage surveillance auto-push VS Code..."

# Fonction de nettoyage
cleanup() {
    echo "🛑 Arrêt surveillance auto-push"
    rm -f "$PID_FILE"
    exit 0
}

# Trap pour cleanup propre
trap cleanup SIGTERM SIGINT

# Enregistrer PID pour contrôle
echo $$ > "$PID_FILE"

# Fonction de log
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Fonction auto-push
auto_push() {
    cd "$WORKSPACE_DIR"

    # Vérifier s'il y a des changements
    if [ -n "$(git status --porcelain)" ]; then
        log_message "📝 Changements détectés, exécution auto-push..."

        # Auto-commit et push
        git add -A
        git commit -m "🚀 AUTO-PUSH: Sauvegarde automatique fermeture VS Code ($(date '+%H:%M:%S'))"

        if git push origin main 2>/dev/null; then
            log_message "✅ AUTO-PUSH RÉUSSI: $(git rev-parse --short HEAD)"
        else
            log_message "⚠️  AUTO-PUSH ÉCHOUÉ: Problème connexion GitHub"
        fi
    else
        log_message "✅ Aucun changement détecté"
    fi
}

log_message "🚀 Surveillance VS Code active - PID: $$"

# Surveillance continue
while true; do
    # Vérifier si VS Code est en cours d'exécution
    if ! pgrep -f "Visual Studio Code" > /dev/null; then
        # VS Code fermé, attendre un peu puis vérifier à nouveau
        sleep 2

        if ! pgrep -f "Visual Studio Code" > /dev/null; then
            log_message "🔍 VS Code fermé détecté"
            auto_push

            # Attendre avant de vérifier à nouveau (éviter spam)
            sleep 10
        fi
    fi

    # Vérification toutes les 5 secondes
    sleep 5
done
