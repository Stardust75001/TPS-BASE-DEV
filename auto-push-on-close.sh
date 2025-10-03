#!/bin/bash

# 🚀 AUTO-PUSH ON CLOSE - Expert Shopify System
# Auto-sauvegarde lors de fermeture workspace/VS Code

set -e

echo "🔄 AUTO-PUSH: Détection fermeture workspace..."

# Vérifier si on est dans un repo git
if [ ! -d ".git" ]; then
    echo "❌ Pas un repository Git - Auto-push ignoré"
    exit 0
fi

# Vérifier s'il y a des changements
if [ -z "$(git status --porcelain)" ]; then
    echo "✅ Aucun changement détecté - Auto-push non nécessaire"
    exit 0
fi

echo "📝 Changements détectés, préparation auto-push..."

# Obtenir timestamp pour message de commit
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Auto-add tous les fichiers modifiés
git add -A

# Commit avec message automatique
git commit -m "🚀 AUTO-PUSH: Sauvegarde automatique workspace ($TIMESTAMP)"

# Push vers GitHub
if git push origin main 2>/dev/null; then
    echo "✅ AUTO-PUSH RÉUSSI: Changements sauvegardés sur GitHub"

    # Log de l'auto-push
    echo "[$TIMESTAMP] AUTO-PUSH SUCCESS: $(git rev-parse --short HEAD)" >> .auto-push.log
else
    echo "⚠️  AUTO-PUSH ÉCHOUÉ: Vérifier connexion GitHub"

    # Log de l'échec
    echo "[$TIMESTAMP] AUTO-PUSH FAILED: Connexion GitHub" >> .auto-push.log
fi

echo "🏁 AUTO-PUSH terminé"
