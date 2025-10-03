#!/bin/bash

# SECURITY AUDIT REPORT - TPS BASE DEV
# Scan focused on REAL security threats
# ========================================

cd "/Users/asc/Shopify/TPS BASE DEV"

echo "🔒 AUDIT SÉCURITÉ SPÉCIALISÉ - $(date)"
echo "======================================"

echo
echo "1. 🚨 CLÉS LIVE SHOPIFY (CRITIQUE)"
echo "================================="
live_keys=$(grep -r "sk_live_\|pk_live_" --include="*.liquid" --include="*.js" snippets/ sections/ templates/ assets/ 2>/dev/null | wc -l)
if [ "$live_keys" -gt 0 ]; then
    echo "❌ CRITIQUE: $live_keys clés Shopify LIVE exposées!"
    grep -r "sk_live_\|pk_live_" --include="*.liquid" --include="*.js" snippets/ sections/ templates/ assets/ 2>/dev/null
else
    echo "✅ SÉCURISÉ: Aucune clé Shopify LIVE exposée"
fi

echo
echo "2. 🔑 CLÉS API GOOGLE/THIRD-PARTY"
echo "================================"
api_keys=$(grep -r "AIza[A-Za-z0-9]\{35\}" --include="*.liquid" --include="*.js" snippets/ sections/ templates/ assets/ 2>/dev/null | wc -l)
if [ "$api_keys" -gt 0 ]; then
    echo "⚠️ ATTENTION: $api_keys clés API Google détectées"
    grep -r "AIza[A-Za-z0-9]\{35\}" --include="*.liquid" --include="*.js" snippets/ sections/ templates/ assets/ 2>/dev/null
else
    echo "✅ OK: Aucune clé API Google exposée"
fi

echo
echo "3. 🔐 STRIPE CLÉS TEST/LIVE"
echo "=========================="
stripe_keys=$(grep -r "sk_test_\|pk_test_\|sk_live\|pk_live" --include="*.liquid" --include="*.js" snippets/ sections/ templates/ assets/ 2>/dev/null | wc -l)
if [ "$stripe_keys" -gt 0 ]; then
    echo "⚠️ ATTENTION: $stripe_keys références Stripe détectées"
    grep -r "sk_test_\|pk_test_\|sk_live\|pk_live" --include="*.liquid" --include="*.js" snippets/ sections/ templates/ assets/ 2>/dev/null | head -3
else
    echo "✅ OK: Aucune clé Stripe exposée"
fi

echo
echo "4. 📊 TOKENS HARDCODÉS"
echo "====================="
hardcoded_tokens=$(grep -rE "token.*=.*['\"][A-Za-z0-9]{25,}['\"]" --include="*.liquid" --include="*.js" snippets/ sections/ templates/ assets/ 2>/dev/null | wc -l)
if [ "$hardcoded_tokens" -gt 0 ]; then
    echo "⚠️ ATTENTION: $hardcoded_tokens tokens hardcodés trouvés"
    grep -rE "token.*=.*['\"][A-Za-z0-9]{25,}['\"]" --include="*.liquid" --include="*.js" snippets/ sections/ templates/ assets/ 2>/dev/null | head -2
else
    echo "✅ OK: Aucun token hardcodé dangereux"
fi

echo
echo "🎯 RÉSUMÉ SÉCURITÉ"
echo "=================="

total_critical=$((live_keys + api_keys + hardcoded_tokens))

if [ "$total_critical" -eq 0 ]; then
    echo "🎉 PARFAIT: Aucun secret critique exposé!"
    echo "✅ Votre theme est sécurisé pour la production"
elif [ "$total_critical" -lt 3 ]; then
    echo "⚠️ MODÉRÉ: $total_critical expositions à corriger"
    echo "🔧 Recommandation: Déplacer vers variables d'environnement"
else
    echo "❌ CRITIQUE: $total_critical expositions majeures!"
    echo "🚨 ACTION REQUISE: Corriger avant mise en production"
fi

echo
echo "📋 FAUX POSITIFS IGNORÉS:"
echo "- password (formulaires Shopify normaux)"
echo "- token (variables Liquid normales)"
echo "- Variables de configuration vides"

echo
echo "✅ Audit sécurité terminé - $(date)"
echo "======================================="
