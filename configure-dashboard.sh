#!/bin/bash

# ⚙️ CONFIGURATION DASHBOARD - Expert Shopify System
# Configure le domaine et les URLs pour votre site

echo "⚙️ CONFIGURATION DASHBOARD MÉTRIQUE"
echo "═════════════════════════════════════════════════"

cd "/Users/asc/Shopify/TPS BASE DEV"

CONFIG_FILE=".dashboard-config"

echo "🎯 Configuration du dashboard pour votre site"
echo ""

# Charger config existante si disponible
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
    echo "📋 Configuration actuelle trouvée:"
    echo "   └── Domaine: $SITE_DOMAIN"
    echo "   └── URL: $SITE_URL"
    echo ""
fi

# Demander le domaine
echo "🌐 Configuration domaine du site:"
read -p "Entrez votre domaine (ex: monsite.com): " new_domain

if [ -n "$new_domain" ]; then
    # Nettoyer le domaine
    new_domain=$(echo "$new_domain" | sed 's|https\?://||' | sed 's|/.*||')
    new_url="https://$new_domain"

    echo ""
    echo "✅ Configuration détectée:"
    echo "   ├── Domaine: $new_domain"
    echo "   └── URL: $new_url"

    read -p "Confirmer cette configuration? (y/N): " confirm

    if [[ $confirm =~ ^[Yy]$ ]]; then
        # Sauvegarder la configuration
        cat > "$CONFIG_FILE" << EOF
# Configuration Dashboard Métrique - Expert Shopify
SITE_DOMAIN="$new_domain"
SITE_URL="$new_url"
CONFIG_DATE="$(date)"
EOF

        echo "💾 Configuration sauvegardée dans $CONFIG_FILE"

        # Mettre à jour les scripts existants
        echo "🔄 Mise à jour des scripts..."

        # Mettre à jour dashboard-metrics-complete.sh
        if [ -f "dashboard-metrics-complete.sh" ]; then
            sed -i '' "s/SITE_DOMAIN=\".*\"/SITE_DOMAIN=\"$new_domain\"/" dashboard-metrics-complete.sh
            echo "   ├── ✅ dashboard-metrics-complete.sh mis à jour"
        fi

        # Mettre à jour generate-dashboard-report.sh
        if [ -f "generate-dashboard-report.sh" ]; then
            sed -i '' "s/SITE_DOMAIN=\".*\"/SITE_DOMAIN=\"$new_domain\"/" generate-dashboard-report.sh
            echo "   ├── ✅ generate-dashboard-report.sh mis à jour"
        fi

        echo "   └── ✅ Configuration appliquée"

        echo ""
        echo "🎯 URLS DE TEST GÉNÉRÉES:"
        echo "──────────────────────────"
        echo "🔍 Google Search Console: https://search.google.com/search-console?resource_id=sc-domain:$new_domain"
        echo "⚡ PageSpeed Desktop: https://pagespeed.web.dev/analysis?url=$new_url"
        echo "📱 PageSpeed Mobile: https://pagespeed.web.dev/analysis?url=$new_url&form_factor=mobile"
        echo "📊 Ahrefs: https://ahrefs.com/site-explorer/overview/v2/subdomains/live?target=$new_domain"
        echo "🔒 SSL Test: https://www.ssllabs.com/ssltest/analyze.html?d=$new_domain"

        echo ""
        read -p "Tester une URL maintenant? (y/N): " test_url

        if [[ $test_url =~ ^[Yy]$ ]]; then
            echo "🚀 Test PageSpeed en cours..."
            open "https://pagespeed.web.dev/analysis?url=$new_url" 2>/dev/null || echo "URL: https://pagespeed.web.dev/analysis?url=$new_url"
        fi

    else
        echo "❌ Configuration annulée"
    fi
else
    echo "❌ Domaine non fourni"
fi

echo ""
echo "📋 PROCHAINES ÉTAPES:"
echo "1. 📊 Lancer le dashboard: ./dashboard-metrics-complete.sh"
echo "2. 📋 Générer rapport: ./generate-dashboard-report.sh"
echo "3. 🔍 Consulter rapports: ./view-all-reports.sh"

echo ""
echo "✅ CONFIGURATION TERMINÉE - Expert Shopify System"
