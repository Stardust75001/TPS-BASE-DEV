#!/bin/bash

# 📊 DASHBOARD MÉTRIQUE COMPLET - EXPERT SHOPIFY SYSTEM
# Dashboard central pour pilotage site et stratégie SEO/Communication

echo "🎯 DASHBOARD PILOTAGE SITE - EXPERT SHOPIFY SYSTEM"
echo "════════════════════════════════════════════════════════════"

cd "/Users/asc/Shopify/TPS BASE DEV"

# Configuration du site (à personnaliser selon votre domaine)
SITE_DOMAIN="thepetsociety-paris.com"  # Remplacer par votre domaine
SITE_URL="https://$SITE_DOMAIN"

echo "🌐 Site analysé: $SITE_URL"
echo ""

echo "📊 DASHBOARD MÉTRIQUES & ANALYTICS"
echo "═══════════════════════════════════════════════════════════"

echo ""
echo "1. 🔍 SEO & ANALYSE DE PERFORMANCE"
echo "──────────────────────────────────────────"

echo "📈 Google Analytics & Search Console:"
echo "   ├── 🔗 Google Analytics 4: https://analytics.google.com/analytics/web/"
echo "   ├── 🔍 Search Console: https://search.google.com/search-console"
echo "   ├── 📊 Search Console (site): https://search.google.com/search-console?resource_id=sc-domain:$SITE_DOMAIN"
echo "   └── 📈 Tag Manager: https://tagmanager.google.com/"

echo ""
echo "🚀 PageSpeed & Core Web Vitals:"
echo "   ├── ⚡ PageSpeed Desktop: https://pagespeed.web.dev/analysis?url=$SITE_URL"
echo "   ├── 📱 PageSpeed Mobile: https://pagespeed.web.dev/analysis?url=$SITE_URL&form_factor=mobile"
echo "   └── 🎯 Core Web Vitals: https://web.dev/measure/?url=$SITE_URL"

echo ""
echo "🔎 Outils SEO Avancés:"
echo "   ├── 🌟 Ahrefs Site Explorer: https://ahrefs.com/site-explorer/overview/v2/subdomains/live?target=$SITE_DOMAIN"
echo "   ├── 📊 Ahrefs Keywords Explorer: https://ahrefs.com/keywords-explorer/"
echo "   ├── 🔍 SEMrush Domain Overview: https://www.semrush.com/analytics/overview/?q=$SITE_DOMAIN"
echo "   ├── 🎯 Moz Link Explorer: https://moz.com/link-explorer/search?q=$SITE_DOMAIN"
echo "   └── 📈 Ubersuggest: https://neilpatel.com/ubersuggest/?keyword=$SITE_DOMAIN"

echo ""
echo "2. 🛡️ INFRASTRUCTURE & SÉCURITÉ"
echo "─────────────────────────────────────────"

echo "☁️ Cloudflare Dashboard:"
echo "   ├── 🌐 Analytics: https://dash.cloudflare.com/analytics"
echo "   ├── 🛡️ Security: https://dash.cloudflare.com/security"
echo "   ├── 📊 Speed: https://dash.cloudflare.com/speed"
echo "   ├── 🔍 DNS Records: https://dash.cloudflare.com/dns"
echo "   └── 🚀 Performance: https://dash.cloudflare.com/speed/optimization"

echo ""
echo "🔒 Monitoring & Sécurité:"
echo "   ├── 🛡️ SSL Labs Test: https://www.ssllabs.com/ssltest/analyze.html?d=$SITE_DOMAIN"
echo "   ├── 🔍 Security Headers: https://securityheaders.com/?q=$SITE_URL"
echo "   ├── 📊 GTmetrix: https://gtmetrix.com/?url=$SITE_URL"
echo "   └── ⚡ Pingdom: https://tools.pingdom.com/#!/$SITE_URL"

echo ""
echo "3. 📱 SOCIAL MEDIA & COMMUNICATION"
echo "──────────────────────────────────────────"

echo "📊 Analytics Réseaux Sociaux:"
echo "   ├── 📘 Facebook Analytics: https://www.facebook.com/analytics/"
echo "   ├── 📸 Instagram Insights: https://business.instagram.com/insights/"
echo "   ├── 🐦 Twitter Analytics: https://analytics.twitter.com/"
echo "   ├── 💼 LinkedIn Analytics: https://www.linkedin.com/analytics/"
echo "   └── 📌 Pinterest Analytics: https://analytics.pinterest.com/"

echo ""
echo "🎯 Outils de Communication:"
echo "   ├── 📧 Mailchimp: https://us1.admin.mailchimp.com/reports/"
echo "   ├── 📬 Klaviyo: https://www.klaviyo.com/analytics/dashboard"
echo "   ├── 🔔 OneSignal: https://app.onesignal.com/"
echo "   └── 💬 Intercom: https://app.intercom.com/analytics"

echo ""
echo "4. 🛒 E-COMMERCE & CONVERSION"
echo "─────────────────────────────────────────"

echo "🏪 Shopify Analytics:"
echo "   ├── 📊 Admin Dashboard: https://admin.shopify.com/store/dashboard"
echo "   ├── 📈 Analytics: https://admin.shopify.com/analytics"
echo "   ├── 💰 Sales Reports: https://admin.shopify.com/analytics/reports"
echo "   ├── 👥 Customer Analytics: https://admin.shopify.com/customers/analytics"
echo "   └── 🛍️ Product Analytics: https://admin.shopify.com/products/analytics"

echo ""
echo "💳 Conversion & Tracking:"
echo "   ├── 🎯 Hotjar: https://insights.hotjar.com/"
echo "   ├── 🔥 Crazy Egg: https://app.crazyegg.com/"
echo "   ├── 📊 Mixpanel: https://mixpanel.com/report/"
echo "   └── 🎨 Optimizely: https://app.optimizely.com/"

echo ""
echo "5. 📊 MÉTRIQUES TECHNIQUES"
echo "──────────────────────────────────"

echo "🔧 Monitoring Technique:"
echo "   ├── 📈 New Relic: https://one.newrelic.com/"
echo "   ├── 📊 DataDog: https://app.datadoghq.com/"
echo "   ├── 🔍 Google Lighthouse: https://developers.google.com/web/tools/lighthouse/"
echo "   └── ⚡ WebPageTest: https://www.webpagetest.org/"

echo ""
echo "🌐 CDN & Performance:"
echo "   ├── ☁️ Cloudflare Analytics: https://dash.cloudflare.com/$SITE_DOMAIN/analytics"
echo "   ├── 🚀 KeyCDN Performance Test: https://tools.keycdn.com/performance?url=$SITE_URL"
echo "   └── 📊 CDN Planet: https://www.cdnplanet.com/tools/cdnperfcheck/"

echo ""
echo "6. 🎯 CONCURRENCE & VEILLE"
echo "──────────────────────────────────"

echo "🔍 Analyse Concurrentielle:"
echo "   ├── 📊 SimilarWeb: https://www.similarweb.com/website/$SITE_DOMAIN/"
echo "   ├── 🔎 Alexa (Archive): https://web.archive.org/"
echo "   ├── 🎯 SpyFu: https://www.spyfu.com/overview/domain?query=$SITE_DOMAIN"
echo "   └── 📈 SEMrush Traffic Analytics: https://www.semrush.com/analytics/traffic/overview/?q=$SITE_DOMAIN"

echo ""
echo "🔔 Veille & Alertes:"
echo "   ├── 🚨 Google Alerts: https://www.google.com/alerts"
echo "   ├── 📢 Mention: https://web.mention.com/"
echo "   ├── 👁️ Brand24: https://brand24.com/"
echo "   └── 🔍 TalkWalker: https://www.talkwalker.com/"

echo ""
echo "7. 📋 RAPPORTS AUTOMATISÉS"
echo "──────────────────────────────────"

# Récupérer les informations du repo GitHub
REPO_URL=$(git config --get remote.origin.url 2>/dev/null | sed 's/\.git$//' | sed 's/git@github.com:/https:\/\/github.com\//')

if [ -n "$REPO_URL" ]; then
    echo "🤖 GitHub Actions (Automatisation):"
    echo "   ├── 🔗 Actions Dashboard: $REPO_URL/actions"
    echo "   ├── 📊 Workflows: $REPO_URL/actions/workflows"
    echo "   ├── 📈 Runs History: $REPO_URL/actions/runs"
    echo "   └── ⚙️ Configuration: $REPO_URL/tree/main/.github/workflows"

    echo ""
    echo "🕐 Planning Automatique:"
    echo "   ├── 🗓️ Lundi 10h: Optimisation SEO hebdomadaire"
    echo "   ├── ☀️ Quotidien 11h: Health check & monitoring"
    echo "   ├── 📅 Vendredi 18h: Sync & backup intelligent"
    echo "   └── ⚡ Sur push: Tests & validation temps réel"
fi

echo ""
echo "8. 🎯 ACTIONS RAPIDES"
echo "─────────────────────────"

echo "🚀 Tests Rapides:"
echo "   ├── 🧪 Test complet site: curl -I $SITE_URL"
echo "   ├── 📊 Validation HTML: https://validator.w3.org/nu/?doc=$SITE_URL"
echo "   ├── 🎨 Validation CSS: https://jigsaw.w3.org/css-validator/validator?uri=$SITE_URL"
echo "   └── 🔍 Test Mobile: https://search.google.com/test/mobile-friendly?url=$SITE_URL"

# Menu interactif
echo ""
echo "🎯 ACTIONS DISPONIBLES:"
echo "1. 🌐 Ouvrir Google Analytics"
echo "2. 🔍 Ouvrir Search Console"
echo "3. ☁️ Ouvrir Cloudflare Dashboard"
echo "4. 📊 Ouvrir Ahrefs Site Explorer"
echo "5. 🛒 Ouvrir Shopify Admin"
echo "6. ⚡ Test PageSpeed complet"
echo "7. 📋 Générer rapport PDF"
echo "0. ❌ Retour"
echo ""

read -p "Choisir une action (0-7): " action_choice

case $action_choice in
    1)
        echo "🌐 Ouverture Google Analytics..."
        open "https://analytics.google.com/analytics/web/" 2>/dev/null || echo "URL: https://analytics.google.com/analytics/web/"
        ;;
    2)
        echo "🔍 Ouverture Search Console..."
        open "https://search.google.com/search-console?resource_id=sc-domain:$SITE_DOMAIN" 2>/dev/null || echo "URL: https://search.google.com/search-console"
        ;;
    3)
        echo "☁️ Ouverture Cloudflare..."
        open "https://dash.cloudflare.com/" 2>/dev/null || echo "URL: https://dash.cloudflare.com/"
        ;;
    4)
        echo "📊 Ouverture Ahrefs..."
        open "https://ahrefs.com/site-explorer/overview/v2/subdomains/live?target=$SITE_DOMAIN" 2>/dev/null || echo "URL: https://ahrefs.com/site-explorer/"
        ;;
    5)
        echo "🛒 Ouverture Shopify Admin..."
        open "https://admin.shopify.com/" 2>/dev/null || echo "URL: https://admin.shopify.com/"
        ;;
    6)
        echo "⚡ Test PageSpeed en cours..."
        open "https://pagespeed.web.dev/analysis?url=$SITE_URL" 2>/dev/null || echo "URL: https://pagespeed.web.dev/analysis?url=$SITE_URL"
        ;;
    7)
        echo "📋 Génération rapport PDF..."
        # Créer un rapport HTML qui peut être converti en PDF
        ./generate-dashboard-report.sh 2>/dev/null || echo "Script de rapport non disponible"
        ;;
    0)
        echo "👋 Retour au menu principal"
        ;;
    *)
        echo "❌ Option invalide"
        ;;
esac

echo ""
echo "🎯 DASHBOARD MÉTRIQUES - Expert Shopify System"
echo "📊 Tous vos outils de pilotage centralisés !"
echo "🔗 Pour relancer: ./dashboard-metrics-complete.sh"
