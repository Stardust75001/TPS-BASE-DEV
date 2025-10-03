# 🚀 GUIDE PRATIQUE - WORKFLOW QUOTIDIEN SHOPIFY

## ⚡ COMMANDES RAPIDES (Copy-Paste)

### 🔒 1. AUDIT SÉCURITÉ (30 secondes)
```bash
# Clés Shopify LIVE (0 tolérance)
grep -r "sk_live_\|pk_live_" --include="*.liquid" --include="*.js" snippets/ sections/ templates/ assets/ || echo "✅ Aucune clé LIVE"

# Clés API réelles
grep -r "AIza[A-Za-z0-9]\{35\}" --include="*.liquid" --include="*.js" snippets/ sections/ templates/ assets/ || echo "✅ Aucune clé API"

# Audit complet sécurité
./security-audit.sh
```

### 📝 2. VALIDATION JSON (1 minute)
```bash
# Test tous les JSON
for file in locales/*.json; do python3 -m json.tool "$file" > /dev/null && echo "✅ $(basename $file)" || echo "❌ $(basename $file)"; done

# Count des erreurs
for file in locales/*.json; do python3 -m json.tool "$file" > /dev/null 2>&1 || echo "ERREUR: $file"; done | wc -l
```

### ⚡ 3. PERFORMANCE CHECK (2 minutes)
```bash
# Images sans dimensions (impact CLS)
grep -r "<img" --include="*.liquid" snippets/ sections/ | grep -v -E "width=|height=" | wc -l

# Console.log production cleanup
grep -r "console\." --include="*.liquid" snippets/ sections/ | wc -l

# Filtres dépréciés
find . -name "*.liquid" -not -path "./backup*" -exec grep -l "img_url" {} \; | wc -l

# Images sans ALT (accessibilité)
grep -r "<img" --include="*.liquid" snippets/ sections/ | grep -v "alt=" | wc -l
```

### 🛠️ 4. CORRECTIONS AUTOMATIQUES
```bash
# Auto-fix complet
./auto-fix-theme-check.sh

# Quick debug
./quick-debug-shopify.sh

# Validation rapide
./fast-theme-validation.sh
```

### 📁 5. GIT WORKFLOW
```bash
# Status propre
git status --porcelain | wc -l

# Commit optimisations
git add .
git commit -m "🎯 Theme optimizations: $(date +%Y%m%d)"
git push origin main
```

---

## 🎯 CHECKLIST DÉPLOIEMENT (5 minutes)

### Phase 1: Sécurité Critique
- [ ] `./security-audit.sh` → Aucun secret exposé
- [ ] `grep -r "sk_live" .` → Aucun résultat
- [ ] Variables sensibles → Centralisées

### Phase 2: Validation Technique
- [ ] JSON: `for f in locales/*.json; do python3 -m json.tool "$f" >/dev/null || echo "❌ $f"; done`
- [ ] Theme-check: `./quick-debug-shopify.sh`
- [ ] Filtres modernes: `find . -name "*.liquid" -exec grep -l "img_url" {} \; | wc -l` → 0

### Phase 3: Performance
- [ ] Images dimensions: `grep -r "<img" --include="*.liquid" . | grep -v "width=" | wc -l` < 50
- [ ] Console cleanup: `grep -r "console\." --include="*.liquid" . | wc -l` < 10
- [ ] Alt attributes: `grep -r "<img" --include="*.liquid" . | grep -v "alt=" | wc -l` < 20

### Phase 4: Production Ready
- [ ] Backup: `cp -r . ../backup-$(date +%Y%m%d_%H%M%S)`
- [ ] Git clean: `git status --porcelain | wc -l` → 0
- [ ] Score final: `./fast-theme-validation.sh`

---

## 📊 MÉTRIQUES CIBLES

| Critère | Cible | Commande |
|---------|-------|----------|
| **Secrets exposés** | 0 | `./security-audit.sh` |
| **JSON errors** | 0 | `for f in locales/*.json; do python3 -m json.tool "$f" >/dev/null \|\| echo $f; done` |
| **Images sans dim** | < 50 | `grep -r "<img" --include="*.liquid" . \| grep -v "width=" \| wc -l` |
| **Console.log** | < 10 | `grep -r "console\." --include="*.liquid" . \| wc -l` |
| **Filtres obsolètes** | 0 | `find . -name "*.liquid" -exec grep -l "img_url" {} \\; \| wc -l` |
| **Git uncommitted** | 0 | `git status --porcelain \| wc -l` |

---

## 🔧 SCRIPTS DISPONIBLES

### Scripts principaux
- `./quick-debug-shopify.sh` - Audit complet 5min ⭐
- `./security-audit.sh` - Scan sécurité spécialisé ⭐
- `./auto-fix-theme-check.sh` - Corrections automatiques
- `./fast-theme-validation.sh` - Validation rapide

### Usage quotidien
```bash
# Morning workflow (2min)
./security-audit.sh && ./fast-theme-validation.sh

# Pre-commit workflow (5min)
./quick-debug-shopify.sh && git add . && git commit -m "🎯 Daily optimizations"

# Pre-deploy workflow (10min)
./security-audit.sh && ./quick-debug-shopify.sh && cp -r . ../backup-$(date +%Y%m%d)
```

---

## 🚨 ALERTES CRITIQUES

### 🔴 BLOQUANTS (Arrêter le déploiement)
```bash
# Secrets exposés
if [ $(grep -r "sk_live\|pk_live" --include="*.liquid" . | wc -l) -gt 0 ]; then echo "🚨 SECRETS EXPOSÉS!"; fi

# JSON corrompus
for f in locales/*.json; do python3 -m json.tool "$f" >/dev/null || echo "🚨 JSON CORROMPU: $f"; done
```

### 🟡 WARNINGS (Optimisation recommandée)
```bash
# Performance impact
if [ $(grep -r "<img" --include="*.liquid" . | grep -v "width=" | wc -l) -gt 100 ]; then echo "⚠️ Trop d'images sans dimensions"; fi
```

---

## 🎉 AUTOMATISATIONS CONFIGURÉES

✅ Scripts de validation créés
✅ Audit sécurité spécialisé
✅ Configuration workflow
✅ Checklist production
✅ Métriques et seuils définis

**Prêt pour un workflow professionnel quotidien ! 🚀**
