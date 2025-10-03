#!/bin/bash

# 📊 GÉNÉRATEUR RAPPORT DASHBOARD - Expert Shopify System
# Créé un rapport HTML/PDF pour aide à la décision

echo "📋 GÉNÉRATION RAPPORT DASHBOARD MÉTRIQUE"
echo "═════════════════════════════════════════════════════"

cd "/Users/asc/Shopify/TPS BASE DEV"

# Configuration
SITE_DOMAIN="thepetsociety-paris.com"
SITE_URL="https://$SITE_DOMAIN"
REPORT_DATE=$(date "+%Y-%m-%d_%H-%M")
REPORT_FILE="DASHBOARD_REPORT_$REPORT_DATE.html"

echo "🎯 Génération rapport pour: $SITE_URL"
echo "📄 Fichier de sortie: $REPORT_FILE"

# Générer le rapport HTML
cat > "$REPORT_FILE" << EOF
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Métrique - $SITE_DOMAIN - $(date "+%d/%m/%Y")</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        h1 { color: #2c3e50; text-align: center; border-bottom: 3px solid #3498db; padding-bottom: 10px; }
        h2 { color: #34495e; border-left: 4px solid #3498db; padding-left: 15px; margin-top: 30px; }
        h3 { color: #7f8c8d; }
        .section { margin-bottom: 30px; padding: 20px; background: #f8f9fa; border-radius: 8px; }
        .url-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 15px; margin: 20px 0; }
        .url-card { background: white; padding: 15px; border-radius: 6px; border-left: 4px solid #3498db; }
        .url-card h4 { margin: 0 0 10px 0; color: #2980b9; }
        .url-list { list-style: none; padding: 0; }
        .url-list li { padding: 8px 0; border-bottom: 1px solid #ecf0f1; }
        .url-list li:last-child { border-bottom: none; }
        .url-list a { color: #3498db; text-decoration: none; font-weight: 500; }
        .url-list a:hover { text-decoration: underline; }
        .metric-box { display: inline-block; background: #3498db; color: white; padding: 10px 20px; border-radius: 5px; margin: 5px; text-decoration: none; }
        .metric-box:hover { background: #2980b9; color: white; }
        .status { padding: 5px 10px; border-radius: 15px; font-size: 12px; font-weight: bold; }
        .status.good { background: #2ecc71; color: white; }
        .status.warning { background: #f39c12; color: white; }
        .status.critical { background: #e74c3c; color: white; }
        .quick-actions { text-align: center; margin: 30px 0; }
        .timestamp { text-align: center; color: #7f8c8d; font-style: italic; margin-top: 30px; }
        @media print { body { background: white; } .container { box-shadow: none; } }
    </style>
</head>
<body>
    <div class="container">
        <h1>📊 Dashboard Métrique Complet</h1>
        <p style="text-align: center; font-size: 18px; color: #34495e;">
            <strong>Site:</strong> $SITE_URL<br>
            <strong>Rapport généré le:</strong> $(date "+%d/%m/%Y à %H:%M")
        </p>

        <div class="section">
            <h2>🔍 SEO & Performance</h2>
            <div class="url-grid">
                <div class="url-card">
                    <h4>📈 Google Analytics & Search</h4>
                    <ul class="url-list">
                        <li><a href="https://analytics.google.com/analytics/web/" target="_blank">Google Analytics 4</a></li>
                        <li><a href="https://search.google.com/search-console" target="_blank">Search Console</a></li>
                        <li><a href="https://search.google.com/search-console?resource_id=sc-domain:$SITE_DOMAIN" target="_blank">Search Console (Site)</a></li>
                        <li><a href="https://tagmanager.google.com/" target="_blank">Tag Manager</a></li>
                    </ul>
                </div>
                <div class="url-card">
                    <h4>⚡ PageSpeed & Core Web Vitals</h4>
                    <ul class="url-list">
                        <li><a href="https://pagespeed.web.dev/analysis?url=$SITE_URL" target="_blank">PageSpeed Desktop</a></li>
                        <li><a href="https://pagespeed.web.dev/analysis?url=$SITE_URL&form_factor=mobile" target="_blank">PageSpeed Mobile</a></li>
                        <li><a href="https://web.dev/measure/?url=$SITE_URL" target="_blank">Core Web Vitals</a></li>
                    </ul>
                </div>
                <div class="url-card">
                    <h4>🔎 Outils SEO Avancés</h4>
                    <ul class="url-list">
                        <li><a href="https://ahrefs.com/site-explorer/overview/v2/subdomains/live?target=$SITE_DOMAIN" target="_blank">Ahrefs Site Explorer</a></li>
                        <li><a href="https://www.semrush.com/analytics/overview/?q=$SITE_DOMAIN" target="_blank">SEMrush Domain</a></li>
                        <li><a href="https://moz.com/link-explorer/search?q=$SITE_DOMAIN" target="_blank">Moz Link Explorer</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="section">
            <h2>☁️ Infrastructure & Sécurité</h2>
            <div class="url-grid">
                <div class="url-card">
                    <h4>🌐 Cloudflare Dashboard</h4>
                    <ul class="url-list">
                        <li><a href="https://dash.cloudflare.com/analytics" target="_blank">Analytics Cloudflare</a></li>
                        <li><a href="https://dash.cloudflare.com/security" target="_blank">Sécurité</a></li>
                        <li><a href="https://dash.cloudflare.com/speed" target="_blank">Performance</a></li>
                        <li><a href="https://dash.cloudflare.com/dns" target="_blank">DNS Records</a></li>
                    </ul>
                </div>
                <div class="url-card">
                    <h4>🔒 Tests Sécurité</h4>
                    <ul class="url-list">
                        <li><a href="https://www.ssllabs.com/ssltest/analyze.html?d=$SITE_DOMAIN" target="_blank">SSL Labs Test</a></li>
                        <li><a href="https://securityheaders.com/?q=$SITE_URL" target="_blank">Security Headers</a></li>
                        <li><a href="https://gtmetrix.com/?url=$SITE_URL" target="_blank">GTmetrix</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="section">
            <h2>🛒 E-Commerce & Analytics</h2>
            <div class="url-grid">
                <div class="url-card">
                    <h4>🏪 Shopify Analytics</h4>
                    <ul class="url-list">
                        <li><a href="https://admin.shopify.com/store/dashboard" target="_blank">Dashboard Admin</a></li>
                        <li><a href="https://admin.shopify.com/analytics" target="_blank">Analytics Shopify</a></li>
                        <li><a href="https://admin.shopify.com/analytics/reports" target="_blank">Rapports Ventes</a></li>
                        <li><a href="https://admin.shopify.com/customers/analytics" target="_blank">Analytics Client</a></li>
                    </ul>
                </div>
                <div class="url-card">
                    <h4>💳 Conversion & Tracking</h4>
                    <ul class="url-list">
                        <li><a href="https://insights.hotjar.com/" target="_blank">Hotjar Insights</a></li>
                        <li><a href="https://app.crazyegg.com/" target="_blank">Crazy Egg</a></li>
                        <li><a href="https://mixpanel.com/report/" target="_blank">Mixpanel</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="section">
            <h2>📱 Social Media & Communication</h2>
            <div class="url-grid">
                <div class="url-card">
                    <h4>📊 Réseaux Sociaux</h4>
                    <ul class="url-list">
                        <li><a href="https://www.facebook.com/analytics/" target="_blank">Facebook Analytics</a></li>
                        <li><a href="https://business.instagram.com/insights/" target="_blank">Instagram Insights</a></li>
                        <li><a href="https://analytics.twitter.com/" target="_blank">Twitter Analytics</a></li>
                        <li><a href="https://www.linkedin.com/analytics/" target="_blank">LinkedIn Analytics</a></li>
                    </ul>
                </div>
                <div class="url-card">
                    <h4>📧 Email & Communication</h4>
                    <ul class="url-list">
                        <li><a href="https://us1.admin.mailchimp.com/reports/" target="_blank">Mailchimp Reports</a></li>
                        <li><a href="https://www.klaviyo.com/analytics/dashboard" target="_blank">Klaviyo Analytics</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="section">
            <h2>🎯 Analyse Concurrentielle</h2>
            <div class="url-grid">
                <div class="url-card">
                    <h4>🔍 Veille Concurrence</h4>
                    <ul class="url-list">
                        <li><a href="https://www.similarweb.com/website/$SITE_DOMAIN/" target="_blank">SimilarWeb</a></li>
                        <li><a href="https://www.spyfu.com/overview/domain?query=$SITE_DOMAIN" target="_blank">SpyFu</a></li>
                        <li><a href="https://www.semrush.com/analytics/traffic/overview/?q=$SITE_DOMAIN" target="_blank">SEMrush Traffic</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="quick-actions">
            <h2>🚀 Actions Rapides</h2>
            <a href="https://pagespeed.web.dev/analysis?url=$SITE_URL" class="metric-box" target="_blank">⚡ Test PageSpeed</a>
            <a href="https://search.google.com/test/mobile-friendly?url=$SITE_URL" class="metric-box" target="_blank">📱 Test Mobile</a>
            <a href="https://validator.w3.org/nu/?doc=$SITE_URL" class="metric-box" target="_blank">🔍 Validation HTML</a>
            <a href="https://jigsaw.w3.org/css-validator/validator?uri=$SITE_URL" class="metric-box" target="_blank">🎨 Validation CSS</a>
        </div>

        <div class="section">
            <h2>📋 Checklist Pilotage SEO & Communication</h2>
            <h3>🔍 SEO Hebdomadaire:</h3>
            <ul>
                <li>✅ Vérifier position mots-clés (Ahrefs/SEMrush)</li>
                <li>✅ Analyser trafic organique (Google Analytics)</li>
                <li>✅ Contrôler erreurs Search Console</li>
                <li>✅ Vérifier vitesse site (PageSpeed)</li>
                <li>✅ Analyser Core Web Vitals</li>
            </ul>

            <h3>📱 Communication & Social:</h3>
            <ul>
                <li>✅ Analyser engagement réseaux sociaux</li>
                <li>✅ Contrôler taux ouverture emails (Klaviyo)</li>
                <li>✅ Vérifier conversion e-commerce</li>
                <li>✅ Analyser comportement utilisateurs (Hotjar)</li>
            </ul>

            <h3>🛡️ Technique & Sécurité:</h3>
            <ul>
                <li>✅ Vérifier certificats SSL</li>
                <li>✅ Contrôler performance Cloudflare</li>
                <li>✅ Analyser logs serveur</li>
                <li>✅ Tester sauvegardes automatiques</li>
            </ul>
        </div>

        <div class="timestamp">
            📊 Rapport généré automatiquement par Expert Shopify System<br>
            Dernière mise à jour: $(date "+%d/%m/%Y à %H:%M:%S")
        </div>
    </div>
</body>
</html>
EOF

echo "✅ Rapport HTML généré: $REPORT_FILE"

# Tenter d'ouvrir le rapport
if command -v open &> /dev/null; then
    echo "🌐 Ouverture du rapport dans le navigateur..."
    open "$REPORT_FILE"
elif command -v xdg-open &> /dev/null; then
    echo "🌐 Ouverture du rapport dans le navigateur..."
    xdg-open "$REPORT_FILE"
else
    echo "📄 Rapport disponible dans: $PWD/$REPORT_FILE"
fi

echo ""
echo "💡 CONSEIL: Ce rapport peut être:"
echo "   ├── 📧 Partagé par email avec l'équipe"
echo "   ├── 🖨️ Imprimé en PDF depuis le navigateur"
echo "   ├── 📋 Utilisé comme checklist hebdomadaire"
echo "   └── 🔗 Bookmarqué pour accès rapide aux outils"

echo ""
echo "✅ Génération rapport terminée - Expert Shopify System"
