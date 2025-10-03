# 🔧 CONFIGURATION WORKFLOW SHOPIFY
# ===================================

# Seuils de performance (ajustez selon vos besoins)
THRESHOLD_IMAGES_NO_DIMENSIONS=50
THRESHOLD_CONSOLE_LOGS=10
THRESHOLD_SECURITY_ISSUES=0
THRESHOLD_H1_TAGS=5

# Seuils de scoring
SCORE_EXCELLENT=90
SCORE_BON=70
SCORE_CRITIQUE=50

# Exclusions
EXCLUDE_DIRS="backup-*,node_modules,test-results,playwright-report"
EXCLUDE_FILES="*.min.js,*.min.css,vendor-*.js"

# Commandes personnalisées
THEME_CHECK_CMD="theme-check ."
JSON_VALIDATOR="python3 -m json.tool"
SECURITY_PATTERNS="sk_live_|pk_live_|AIza[A-Za-z0-9]{35}"

# Git configuration
AUTO_COMMIT_ENABLED=true
COMMIT_MESSAGE_PREFIX="🎯 Auto-fix:"

# Notifications (optionnel)
SLACK_WEBHOOK_URL=""
EMAIL_NOTIFICATIONS=false

# Déploiement
BACKUP_DIR="../backups"
MAX_BACKUPS=10

# Performance monitoring
LIGHTHOUSE_ENABLED=false
LIGHTHOUSE_URL="https://yourstore.com"
LIGHTHOUSE_CATEGORIES="performance,accessibility,seo"

# Extensions VS Code recommandées
VSCODE_EXTENSIONS="
sissel.shopify-liquid,
ms-vscode.vscode-json,
bradlc.vscode-tailwindcss,
formulahendry.auto-rename-tag,
ms-python.python
"

# Workflows GitHub Actions
GITHUB_WORKFLOWS_ENABLED=true
CI_ON_PUSH=true
DAILY_SECURITY_SCAN=true
WEEKLY_BACKUP=true

# API Keys (variables d'environnement - NE PAS COMMITTER)
# export SHOPIFY_API_KEY="your_key_here"
# export GOOGLE_API_KEY="your_key_here"
# export AMPLITUDE_API_KEY="your_key_here"

# Metafields et données sensibles
SENSITIVE_PATTERNS="
password
secret
token
api_key
private_key
auth_token
access_token
"

echo "✅ Configuration chargée - Workflow Shopify Professional"
