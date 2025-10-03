# 🚀 CHECKLIST DEBUG SHOPIFY - TPS BASE DEV

**Version:** 1.0 | **Date:** 3 octobre 2025
**Expert:** GitHub Copilot Shopify Specialist
**Usage:** À coller dans vos PR & avant chaque déploiement

---

## 🛠️ **STACK DEV SHOPIFY - CONFIGURATION COMPLÈTE**

### ✅ **VS Code Extensions Installées**

```vscode-extensions
shopify.theme-check-vscode,sissel.shopify-liquid,killalau.vscode-liquid-snippets,kirchner-trevor.shopify-liquid-preview,neilding.language-liquid
```

### 🔧 **CLI & Outils Requis**

| **Outil** | **Status** | **Usage** | **Installation** |
|-----------|------------|-----------|------------------|
| **Theme Check** | ✅ Installé | Linter Liquid/JSON | `gem install theme-check` |
| **Shopify CLI** | ❓ À vérifier | Dev server, push/pull | `npm install -g @shopify/cli` |
| **Lighthouse** | 🔧 Browser | Performance audit | Extension Chrome |
| **Theme Inspector** | 🔧 Browser | Profile Liquid | Extension Chrome |

### 📋 **Commandes de Base Shopify**

```bash
# Développement local
shopify theme dev         # serveur dev + hot reload
shopify theme check       # linter le thème complet
shopify theme push        # déployer sur store

# Maintenance
theme-check              # alternative locale (Ruby gem)
lighthouse --view        # audit performance
```

---

## ✅ **CHECKLIST DEBUGGING 10 POINTS CRITIQUE**

### **1. 🔄 LIQUID - Performance & Logique**

- [ ] **Boucles optimisées** - Aucun `for` imbriqué ou `render` dans boucle
- [ ] **Variables efficaces** - `assign` plutôt que `capture` quand possible
- [ ] **Conditions propres** - `unless` évité, logique claire
- [ ] **Filters modernes** - `image_url` au lieu de `img_url` déprécié

**Test:**
```bash
grep -r "img_url\|for.*for\|render.*for" --include="*.liquid" .
```

### **2. 🌍 TRADUCTIONS - Internationalisation**

- [ ] **Toutes clés traduites** - {{ 'key' | t }} pour tous textes visibles
- [ ] **Fichiers JSON complets** - en.default.json, fr.json, de.json cohérents
- [ ] **Pas de texte hardcodé** - Aucun texte français/anglais en dur dans Liquid
- [ ] **Clés organisées** - Structure logique par section/fonctionnalité

**Test:**
```bash
# Validation JSON
for file in locales/*.json; do
  python3 -m json.tool "$file" > /dev/null || echo "❌ Erreur: $file"
done

# Texte hardcodé
grep -r '"[A-Za-z ]{3,}"' --include="*.liquid" sections/ snippets/
```

### **3. 📋 JSON SCHEMA - Configuration Sections**

- [ ] **JSON valide** - Aucune erreur syntaxe, pas de virgules finales
- [ ] **IDs uniques** - Tous les `"id"` différents dans settings
- [ ] **Presets cohérents** - `max_blocks` respecté dans presets
- [ ] **Types corrects** - `url`, `image_picker`, `text` bien typés

**Test:**
```bash
# Vérifier schema sections
find sections/ -name "*.liquid" -exec grep -l "{% schema %}" {} \; | \
xargs -I {} sh -c 'echo "=== {} ===" && sed -n "/{% schema %}/,/{% endschema %}/p" {} | sed "1d;\$d" | jq .'
```

### **4. 🎨 CSS - Style & Responsive**

- [ ] **Pas de !important global** - Utilisé uniquement pour overrides critiques
- [ ] **Classes namespées** - Préfixe `.tps-` pour éviter conflits
- [ ] **Responsive complet** - Mobile-first, breakpoints cohérents
- [ ] **CSS optimisé** - Pas de règles inutiles ou dupliquées

**Test:**
```bash
# Détection !important excessif
grep -r "!important" --include="*.css" --include="*.scss" assets/ | wc -l

# Vérification responsive
grep -r "@media\|mobile\|tablet\|desktop" --include="*.css" assets/
```

### **5. ⚡ JAVASCRIPT - Fonctionnalité & Performance**

- [ ] **Console propre** - Aucune erreur JS dans DevTools
- [ ] **Imports corrects** - ES6 modules ou scripts chargés proprement
- [ ] **Scripts essentiels** - Suppression code mort, analytics optimisé
- [ ] **Events optimisés** - Debouncing sur scroll/resize, listeners nettoyés

**Test:**
```bash
# Détection console.log oubliés
grep -r "console\." --include="*.js" --include="*.liquid" .

# Scripts analysés
find assets/ -name "*.js" -exec echo "=== {} ===" \; -exec head -10 {} \;
```

### **6. ♿ ACCESSIBILITÉ - A11y Compliance**

- [ ] **Alt complets** - Tous `<img>` ont `alt` descriptif ou `alt=""`
- [ ] **Structure H1-H6** - Hiérarchie logique, 1 seul H1 par page
- [ ] **Focus visible** - Tabulation navigable, outline sur éléments interactifs
- [ ] **Contraste suffisant** - WCAG AA respecté (4.5:1 minimum)

**Test:**
```bash
# Images sans alt
grep -r "<img" --include="*.liquid" . | grep -v "alt="

# Structure headings
grep -rE "<h[1-6]" --include="*.liquid" sections/ | head -10

# Focus states
grep -r "focus\|outline" --include="*.css" assets/
```

### **7. 🖼️ IMAGES - Performance & Formats**

- [ ] **Dimensions explicites** - `width` et `height` sur toutes images
- [ ] **Loading intelligent** - `loading="lazy"` partout sauf LCP (`fetchpriority="high"`)
- [ ] **Formats optimaux** - WebP avec fallback JPEG, tailles adaptées
- [ ] **Responsive images** - `srcset` pour différentes résolutions

**Test:**
```bash
# Images sans dimensions
grep -r "<img" --include="*.liquid" . | grep -v 'width=\|height='

# Loading attributes
grep -r "loading=" --include="*.liquid" . | head -5

# Formats images
find assets/ -name "*.webp" -o -name "*.jpg" -o -name "*.png" | wc -l
```

### **8. 📈 PERFORMANCE - Core Web Vitals**

- [ ] **Lighthouse Score >90** - Mobile ET Desktop
- [ ] **LCP <2.5s** - Image hero optimisée, CSS critique inline
- [ ] **CLS <0.1** - Dimensions réservées, pas de layout shift
- [ ] **FID <100ms** - JavaScript non-bloquant, interactions rapides

**Test:**
```bash
# Audit Lighthouse (nécessite Chrome + lighthouse CLI)
lighthouse https://votre-store.myshopify.com --only-categories=performance

# Métriques critiques
echo "🔍 Vérifiez manuellement:"
echo "- Page Speed Insights: https://pagespeed.web.dev/"
echo "- Chrome DevTools > Performance tab"
```

### **9. 🔍 SEO - Référencement & Structure**

- [ ] **Title dynamique** - `<title>` unique par page, 50-60 caractères
- [ ] **Meta descriptions** - Uniques, 150-160 caractères, avec mots-clés
- [ ] **URLs canoniques** - `rel="canonical"` correct sur toutes pages
- [ ] **Structure données** - Schema.org pour produits/avis si applicable

**Test:**
```bash
# Title tags
grep -r "<title>" --include="*.liquid" layout/ templates/

# Meta descriptions
grep -r 'name="description"' --include="*.liquid" .

# Canonical URLs
grep -r 'rel="canonical"' --include="*.liquid" .
```

### **10. 🚀 DÉPLOIEMENT - Production Ready**

- [ ] **Theme Check clean** - `theme-check` sans erreurs critiques
- [ ] **Git commits propres** - Messages clairs, pas de fichiers temp
- [ ] **Test pré-prod** - Validation sur thème staging avant publication
- [ ] **Backup theme** - Sauvegarde avant push vers production

**Test:**
```bash
# Theme check final
~/.rbenv/shims/theme-check --list

# Status Git
git status --porcelain

# Fichiers sensibles non trackés
echo "Vérifiez .gitignore pour:"
echo "- *.log, *.tmp"
echo "- .env, config.yml"
echo "- node_modules/, .DS_Store"
```

---

## 🧪 **TESTS AUTOMATISÉS RECOMMANDÉS**

### **A. Accessibilité & Responsive**

```bash
# Installation axe-core CLI
npm install -g @axe-core/cli

# Audit accessibilité
axe https://votre-store.myshopify.com --tags=wcag2a,wcag2aa

# Test responsive (différentes tailles)
# Mobile: 375x667 (iPhone SE)
# Tablet: 768x1024 (iPad)
# Desktop: 1920x1080 (Full HD)
```

### **B. Performance & Métriques**

```bash
# Lighthouse CI (intégration continue)
npm install -g @lhci/cli
lhci autorun --upload.target=temporary-public-storage

# Core Web Vitals monitoring
# Utilisez: Google Search Console > Expérience > Core Web Vitals
```

### **C. Sécurité & Variables Sensibles**

```bash
# Scan secrets (git-secrets ou truffleHog)
npm install -g detect-secrets
detect-secrets scan --all-files .

# Variables d'environnement
grep -r "sk_\|pk_\|secret\|password\|token" --include="*.liquid" --include="*.js" .
```

---

## ⚡ **COMMANDES RAPIDES - DAILY WORKFLOW**

### **Pré-commit Hook (recommandé)**

```bash
# .git/hooks/pre-commit
#!/bin/sh
echo "🔍 Theme Check..."
~/.rbenv/shims/theme-check --list || exit 1

echo "📝 JSON Validation..."
for file in locales/*.json; do
  python3 -m json.tool "$file" > /dev/null || exit 1
done

echo "🖼️ Images Check..."
missing_alt=$(grep -r "<img" --include="*.liquid" . | grep -v "alt=" | wc -l)
if [ "$missing_alt" -gt 0 ]; then
  echo "❌ $missing_alt images sans attribut alt"
  exit 1
fi

echo "✅ Pre-commit checks passed!"
```

### **Debug Rapide (5min)**

```bash
# Script de validation rapide
#!/bin/bash
echo "🚀 QUICK DEBUG TPS BASE DEV"

# 1. Theme check
echo "1. Theme Check..."
~/.rbenv/shims/theme-check --list | head -20

# 2. JSON validation
echo "2. JSON Locales..."
for file in locales/*.json; do
  python3 -m json.tool "$file" > /dev/null && echo "✅ $(basename $file)" || echo "❌ $(basename $file)"
done

# 3. Images dimensions
echo "3. Images sans dimensions:"
grep -r "<img" --include="*.liquid" . | grep -v 'width=\|height=' | wc -l

# 4. Sécurité
echo "4. Scan secrets:"
grep -r "sk_\|pk_\|secret.*=" --include="*.liquid" --include="*.js" . | wc -l

# 5. Performance hints
echo "5. Loading attributes:"
grep -r "loading=" --include="*.liquid" . | wc -l

echo "✅ Quick debug completed!"
```

---

## 📊 **MONITORING EN PRODUCTION**

### **Métriques à Surveiller**

1. **Core Web Vitals** (Google Search Console)
2. **Lighthouse CI** (GitHub Actions)
3. **Uptime monitoring** (Pingdom, UptimeRobot)
4. **Error tracking** (Sentry pour JS)
5. **Performance** (SpeedCurve, GTmetrix)

### **Alertes Recommandées**

- 📉 Lighthouse Score < 85
- ⚠️ CLS > 0.15 (Layout shift)
- 🐌 LCP > 3s (Loading performance)
- ❌ Erreurs JS > 5/jour
- 📱 Mobile usability errors (Search Console)

---

**💡 TIPS PRO:**

- 🔄 Lancez cette checklist à chaque PR
- 🎯 Focalisez sur les erreurs critiques avant les suggestions
- 📱 Testez toujours mobile-first
- ⚡ Optimisez d'abord le LCP (Largest Contentful Paint)
- 🔒 Ne committez JAMAIS de tokens/secrets

**🚀 Avec cette checklist, votre thème Shopify sera production-ready à 100% !**
