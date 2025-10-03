#!/bin/bash

# 🔐 CONFIGURATION SECRETS GITHUB - TPS BASE DEV
# Script pour configurer automatiquement tous les secrets requis

set -euo pipefail

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔐 CONFIGURATION SECRETS GITHUB - TPS BASE DEV${NC}"
echo "=================================================="
echo ""

# Vérifier si .env existe
if [[ ! -f .env ]]; then
    echo -e "${RED}❌ Fichier .env non trouvé${NC}"
    echo "Veuillez d'abord configurer le fichier .env avec vos tokens"
    exit 1
fi

# Charger les variables depuis .env
source .env

# Vérifier si GitHub CLI est installé
if ! command -v gh &> /dev/null; then
    echo -e "${RED}❌ GitHub CLI (gh) n'est pas installé${NC}"
    echo "Installation: brew install gh"
    exit 1
fi

# Vérifier l'authentification GitHub
if ! gh auth status &> /dev/null; then
    echo -e "${YELLOW}⚠️ Authentification GitHub requise${NC}"
    echo "Lancement: gh auth login"
    gh auth login
fi

echo -e "${GREEN}✅ GitHub CLI configuré${NC}"
echo ""

# Fonction pour configurer un secret
configure_secret() {
    local name="$1"
    local value="$2"
    local description="$3"

    if [[ -n "$value" ]]; then
        echo -e "${BLUE}📝 Configuration: $name${NC}"
        echo "   Description: $description"

        # Configurer le secret (masque la valeur)
        echo "$value" | gh secret set "$name" --body -

        if [[ $? -eq 0 ]]; then
            echo -e "${GREEN}   ✅ Secret configuré${NC}"
        else
            echo -e "${RED}   ❌ Erreur configuration${NC}"
        fi
    else
        echo -e "${YELLOW}   ⚠️ $name: Variable vide dans .env${NC}"
    fi
    echo ""
}

echo -e "${BLUE}🚀 Configuration des secrets GitHub...${NC}"
echo ""

# === SHOPIFY CONFIGURATION ===
echo -e "${BLUE}🛍️ SHOPIFY CONFIGURATION${NC}"
configure_secret "SHOPIFY_STORE" "$SHOPIFY_STORE_DOMAIN" "Domaine du store Shopify"
configure_secret "SHOPIFY_ADMIN_TOKEN" "$SHOPIFY_ADMIN_TOKEN" "Token Admin API (shpat_)"
configure_secret "SHOPIFY_CLI_THEME_TOKEN" "$SHOPIFY_CLI_THEME_TOKEN" "Token Theme Access (shptka_)"
configure_secret "THEME_ID" "$THEME_ID" "ID du thème de production"

# === ANALYTICS & MONITORING ===
echo -e "${BLUE}📊 ANALYTICS & MONITORING${NC}"
configure_secret "GTM_ID" "$GTM_ID" "Google Tag Manager ID"
configure_secret "GA4_ID" "$GA4_ID" "Google Analytics 4 ID"
configure_secret "GOOGLE_PSI_API_KEY" "$GOOGLE_PSI_API_KEY" "Google PageSpeed Insights API"
configure_secret "SENTRY_DSN" "$SENTRY_DSN" "Sentry Error Monitoring DSN"

# === CONFIGURATION & TESTING ===
echo -e "${BLUE}⚙️ CONFIGURATION & TESTING${NC}"
configure_secret "ENABLE_THEME_DEPLOY" "true" "Activer déploiement automatique"
configure_secret "VARIANT_ID_1" "$VARIANT_ID_TEST_1" "ID variant pour tests add-to-cart"
configure_secret "VARIANT_ID_2" "$VARIANT_ID_TEST_2" "ID variant pour tests add-to-cart"

echo -e "${GREEN}✅ Configuration terminée !${NC}"
echo ""

# Vérification des secrets configurés
echo -e "${BLUE}🔍 Vérification des secrets...${NC}"
echo ""

secrets_count=$(gh secret list | wc -l)
echo -e "${GREEN}📊 $secrets_count secrets configurés${NC}"

echo ""
echo -e "${BLUE}📋 Secrets configurés:${NC}"
gh secret list --json name,updatedAt | jq -r '.[] | "- \(.name) (mis à jour: \(.updatedAt))"'

echo ""
echo -e "${BLUE}🎯 PROCHAINES ÉTAPES${NC}"
echo "=================="
echo ""
echo "1. 🔄 Vérifier que tous les secrets sont présents:"
echo "   Repository → Settings → Secrets and variables → Actions"
echo ""
echo "2. ✅ Activer les workflows GitHub Actions:"
echo "   Repository → Actions → Enable workflows"
echo ""
echo "3. 🧪 Tester un workflow manuellement:"
echo "   Actions → 'CI/CD Principal' → Run workflow"
echo ""
echo "4. 📊 Vérifier les permissions GitHub Actions:"
echo "   Settings → Actions → General → Workflow permissions"
echo ""

# Génération du résumé de configuration
cat > .github/SECRETS_CONFIGURED.md << EOF
# 🔐 SECRETS GITHUB CONFIGURÉS - $(date)

## ✅ Secrets Configurés

$(gh secret list --json name,updatedAt | jq -r '.[] | "- **\(.name)** - Mis à jour: \(.updatedAt)"')

## 🎯 Configuration Complète

- **Total:** $secrets_count secrets
- **Date:** $(date '+%Y-%m-%d %H:%M:%S')
- **Configuré par:** $(gh api user --jq '.login')

## 📊 Workflows Disponibles

1. **CI/CD Principal** - Build, tests, déploiement
2. **Backup Hebdomadaire** - Sauvegarde automatique
3. **SEO & Sitemap** - Audit SEO hebdomadaire
4. **Monitoring Quotidien** - Surveillance continue

## 🚀 Actions Suivantes

1. Tester les workflows manuellement
2. Vérifier les permissions GitHub Actions
3. Surveiller les premiers rapports automatiques

---

**Généré automatiquement par setup-github-secrets.sh**
EOF

echo -e "${GREEN}📄 Rapport généré: .github/SECRETS_CONFIGURED.md${NC}"
echo ""
echo -e "${GREEN}🎉 Configuration GitHub Actions terminée avec succès !${NC}"
