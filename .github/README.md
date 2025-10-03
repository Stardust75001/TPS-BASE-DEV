# 🚀 ACTIONS GITHUB - TPS BASE DEV

**Configuration complète des workflows automatisés pour TPS BASE DEV**

## 📋 WORKFLOWS DISPONIBLES

### 1. 🚀 CI/CD Principal (`ci-cd-main.yml`)

**Déclencheurs:**
- Push sur `main` ou `development`
- Pull Request vers `main`
- Déclenchement manuel (avec options)

**Actions:**
- ✅ **Build & Validation** - Structure du thème
- 🧪 **Tests de Fumée** - HTTP, Add-to-Cart, Performance
- 🎨 **Theme Check** - Validation Shopify
- 🔑 **Test API Admin** - Vérification des tokens
- 💾 **Backup Automatique** - Sauvegarde avant déploiement  
- 🚀 **Déploiement** - Push vers Shopify (si activé)

### 2. 💾 Backup Hebdomadaire (`backup-weekly.yml`)

**Déclencheurs:**
- **Automatique:** Tous les dimanches à 2h00 UTC
- **Manuel:** Avec choix du type de backup

**Types de Sauvegarde:**
- **Complete:** Thèmes + Produits + Collections + Settings + Metaobjects
- **Themes Only:** Sauvegarde des thèmes uniquement
- **Settings Only:** Paramètres et configuration

**Rétention:** 30 jours dans GitHub Artifacts

### 3. 🗺️ SEO & Sitemap (`sitemap-seo.yml`)

**Déclencheurs:**
- **Automatique:** Tous les mardis à 6h00 UTC  
- **Manuel:** Avec choix du type d'audit

**Vérifications:**
- 🗺️ **Analyse Sitemap** - Nombre d'URLs, validité
- 🤖 **Robots.txt** - Vérification et référence sitemap
- ⚡ **Performance** - PageSpeed Insights (Mobile)
- 🔍 **Test URLs** - Vérification échantillon d'URLs

**Rétention:** 90 jours pour analyse des tendances

### 4. 📊 Monitoring Quotidien (`monitoring-daily.yml`)

**Déclencheurs:**
- **Automatique:** Tous les jours à 8h00 UTC
- **Manuel:** Avec choix du type de monitoring

**Surveillance:**
- 🔍 **Uptime** - Disponibilité des pages critiques
- 📊 **Analytics** - Présence GTM, GA4, Facebook Pixel, Suite TPS
- 🐛 **Erreurs** - Détection 404, ressources manquantes
- 🚀 **Performance** - Temps de réponse

**Alertes:** Rapport quotidien avec recommandations

## ⚙️ CONFIGURATION REQUISE

### Secrets GitHub à Configurer

```bash
# Shopify Configuration
SHOPIFY_STORE="f6d72e-0f.myshopify.com"
SHOPIFY_ADMIN_TOKEN="shpat_xxx"           # Token Admin API
SHOPIFY_CLI_THEME_TOKEN="shptka_xxx"      # Token Theme Access
THEME_ID="187147125084"                   # ID du thème de production

# Analytics & Monitoring  
GTM_ID="GTM-P9SBYVC4"                     # Google Tag Manager
GA4_ID="G-LM1PJ22ZM3"                     # Google Analytics 4
GOOGLE_PSI_API_KEY="xxx"                  # PageSpeed Insights API
SENTRY_DSN="https://xxx@sentry.io/xxx"    # Monitoring erreurs

# Configuration
ENABLE_THEME_DEPLOY="true"                # Activer déploiement auto
VARIANT_ID_1="54558367276478"             # ID variant pour tests
VARIANT_ID_2="44739827382621"             # ID variant pour tests
```

### 🔧 Comment Configurer

1. **GitHub Repository** → **Settings** → **Secrets and variables** → **Actions**
2. **New repository secret** pour chaque variable ci-dessus
3. **Vérifier les permissions** : Repository → Settings → Actions → Général
4. **Activer les workflows** : Actions → Enable workflows

## 📊 RAPPORTS GÉNÉRÉS

### Structure des Rapports

```
reports/
├── seo/
│   └── YYYYMMDD_HHMMSS/
│       ├── SEO_REPORT.md
│       ├── sitemap.xml
│       ├── robots.txt
│       ├── psi_report.json
│       └── sample_urls.txt
├── monitoring/  
│   └── YYYYMMDD_HHMMSS/
│       ├── MONITORING_REPORT.md
│       ├── uptime.csv
│       └── errors.csv
└── backups/
    └── YYYYMMDD_HHMMSS/
        ├── BACKUP_REPORT.md
        ├── themes/
        ├── products/
        ├── collections/
        ├── settings/
        └── metaobjects/
```

### 📥 Accès aux Rapports

1. **GitHub Repository** → **Actions**
2. **Cliquer sur un workflow** terminé
3. **Artifacts** en bas de page
4. **Download** le rapport désiré

## 🎯 UTILISATION QUOTIDIENNE

### Déclenchement Manuel

```bash
# Backup complet immédiat
Repository → Actions → "Backup Hebdomadaire" → Run workflow → Complete

# Audit SEO uniquement  
Repository → Actions → "SEO & Sitemap" → Run workflow → sitemap_only

# Monitoring spécifique
Repository → Actions → "Monitoring Quotidien" → Run workflow → analytics_only

# Déploiement seul (sans tests)
Repository → Actions → "CI/CD Principal" → Run workflow → deploy_only: true
```

### Surveillance des Alertes

**Notifications automatiques via:**
- 📧 **Email** - Si workflow échoue
- 📊 **GitHub** - Summary dans Actions
- 📱 **Mobile** - GitHub Mobile App

## 🛠️ MAINTENANCE

### Actions Hebdomadaires

1. **Vérifier les rapports de backup** (Dimanche)
2. **Analyser l'audit SEO** (Mardi) 
3. **Réviser les métriques de monitoring** (Vendredi)

### Actions Mensuelles

1. **Nettoyer les artifacts** anciens (>30 jours)
2. **Revoir les seuils d'alerte** 
3. **Mettre à jour les tokens** si nécessaire

### Troubleshooting

**Workflow échoue ?**
1. Vérifier les **secrets** GitHub
2. Contrôler les **permissions** Shopify
3. Tester les **tokens** manuellement avec `./manage-tokens.sh test-all`

**Backup incomplet ?**
1. Vérifier le **token Admin API**
2. Contrôler les **scopes** de l'app Shopify
3. Augmenter le **timeout** si nécessaire

## 🎉 BÉNÉFICES

### 🔄 Automatisation Complète
- **Zéro intervention** pour surveillance quotidienne
- **Backups réguliers** sans oubli
- **Déploiements sécurisés** avec validation

### 📊 Visibilité Totale
- **Métriques de performance** continues  
- **Alertes proactives** sur les problèmes
- **Historique complet** pour analyse

### 🛡️ Sécurité & Fiabilité
- **Sauvegarde automatique** avant déploiement
- **Tests systématiques** avant mise en production
- **Monitoring 24/7** des services critiques

---

**🎯 Résultat:** Infrastructure DevOps professionnelle avec monitoring, backups et déploiements automatisés pour TPS BASE DEV.