# 🚀 CHECKLIST 10 POINTS - PRODUCTION READY
**Voici votre checklist à coller dans chaque PR :**

## ✅ CHECKLIST DEBUG SHOPIFY - PR

### Technique
- [ ] **theme-check** sans erreurs ✅
- [ ] **JSON schema valide** (pas de virgules en trop) ✅
- [ ] **Files .js ajoutées** → présentes ✅
- [ ] **Images avec width/height + loading="lazy"** ⚠️

### Performance
- [ ] **LCP optimisé** (image hero avec priority/eager)
- [ ] **Pas de render blocking** dans `<head>`
- [ ] **Filtres img_url → image_url modernes** ✅

### Accessibilité
- [ ] **Alt attributes sur toutes images**
- [ ] **Ordre H1-H2 correct, 1 seul H1/page**
- [ ] **Test responsive mobile/desktop**

### Sécurité
- [ ] **Aucun token/secret exposé** ✅
- [ ] **Variables sensibles centralisées**

---

# 🛠️ COMMANDES DAILY WORKFLOW

## Quick Debug (5min)
```bash
./quick-debug-shopify.sh
```

## Corrections Automatiques
```bash
./auto-fix-theme-check.sh
```

## Validation JSON
```bash
for file in locales/*.json; do
  python3 -m json.tool "$file" > /dev/null && echo "✅ $(basename $file)" || echo "❌ $(basename $file)"
done
```

## Scan Sécurité
```bash
grep -r "sk_\|pk_\|secret.*=" --include="*.liquid" --include="*.js" .
```

## Validation Images
```bash
# Vérifier images sans dimensions
grep -r "<img" --include="*.liquid" snippets/ sections/ | grep -v "width=" | wc -l

# Vérifier images sans alt
grep -r "<img" --include="*.liquid" snippets/ sections/ | grep -v "alt=" | wc -l

# Vérifier filtres dépréciés
find . -name "*.liquid" -exec grep -l "img_url" {} \;
```

## Performance Check
```bash
# Console.log à nettoyer (production)
grep -r "console\." --include="*.js" --include="*.liquid" assets/ snippets/ | wc -l

# Vérifier H1 multiples
grep -r "<h1" --include="*.liquid" sections/ templates/ | wc -l
```

## Git Workflow
```bash
# Status des modifications
git status --porcelain | wc -l

# Commit optimisations
git add .
git commit -m "🎯 Theme optimizations: performance + security + accessibility"
git push origin main
```

---

# 📋 VALIDATION RAPIDE PRE-DEPLOY

## 1. Sécurité Critique (0 tolérance)
```bash
# Clés Shopify LIVE exposées
grep -r "sk_live_\|pk_live_" --include="*.liquid" --include="*.js" .

# Clés API réelles
grep -r "AIza[A-Za-z0-9]\{35\}" --include="*.liquid" --include="*.js" .

# Tokens hardcodés longs
grep -rE "['\"][A-Za-z0-9]{30,}['\"]" --include="*.liquid" .
```

## 2. JSON Syntax (Bloquant)
```bash
for f in locales/*.json; do python3 -m json.tool "$f" >/dev/null || echo "❌ $f BROKEN"; done
```

## 3. Performance Critical
```bash
# Images sans dimensions (impact CLS)
grep -r "<img" --include="*.liquid" snippets/ sections/ | grep -v -E "width=|height=" | wc -l

# Filtres dépréciés (compatibilité future)
find . -name "*.liquid" -not -path "./backup*" -exec grep -l "img_url" {} \; | wc -l
```

## 4. Production Clean
```bash
# Console.log statements
grep -r "console\." --include="*.js" assets/ | grep -v ".min.js" | wc -l

# Debug code
grep -r "debugger\|console\.log" --include="*.liquid" snippets/ sections/ | wc -l
```

---

# 🎯 SCORES CIBLES PRODUCTION

| Critère | Cible | Commande de vérification |
|---------|-------|-------------------------|
| **Theme-check errors** | 0 | `theme-check . 2>/dev/null \| grep "error" \| wc -l` |
| **JSON files** | 100% valid | `./quick-debug-shopify.sh \| grep "JSON"` |
| **Security exposures** | 0 | `./security-audit.sh` |
| **Images sans dimensions** | <50 | `grep -r "<img" --include="*.liquid" . \| grep -v "width=" \| wc -l` |
| **Console.log production** | <10 | `grep -r "console\." --include="*.liquid" . \| wc -l` |
| **Deprecated filters** | 0 | `find . -name "*.liquid" -exec grep -l "img_url" {} \; \| wc -l` |

---

# ⚡ AUTOMATISATIONS DISPONIBLES

## Scripts créés
- `./quick-debug-shopify.sh` - Audit complet 5min
- `./auto-fix-theme-check.sh` - Corrections automatiques
- `./security-audit.sh` - Scan sécurité spécialisé
- `./fast-theme-validation.sh` - Validation rapide

## Extensions VS Code
- **Shopify Liquid** - Syntax highlighting
- **theme-check-vscode** - Linting en temps réel
- **Liquid snippets** - Autocomplétion

## Workflows GitHub
- **CI/CD automatique** sur push
- **Security monitoring** quotidien
- **Performance monitoring**
- **Backup weekly** des thèmes

---

# 🚨 CHECKLIST DÉPLOIEMENT FINAL

Avant chaque mise en production :

```bash
# 1. Audit complet
./quick-debug-shopify.sh

# 2. Sécurité
./security-audit.sh

# 3. Performance
lighthouse --chrome-flags="--headless" --output=json --output-path=./report.json https://yourstore.com

# 4. Git clean
git status --porcelain | wc -l  # Doit être 0

# 5. Backup
cp -r . ../backup-$(date +%Y%m%d_%H%M%S)
```

**✅ Tous verts = PRODUCTION READY! 🚀**
