#!/bin/bash

# FAST THEME VALIDATION - Alternative to theme-check
# When theme-check hangs due to complex Liquid syntax
# ==========================================

set -e
cd "/Users/asc/Shopify/TPS BASE DEV"

echo "🚀 FAST THEME VALIDATION - $(date)"
echo "=================================="

# Initialize counters
total_issues=0

echo
echo "1. 🔍 CRITICAL ISSUES CHECK..."
echo "============================"

# Check for img_url (deprecated filters)
img_url_count=$(find . -name "*.liquid" -not -path "./backup*" -exec grep -l "img_url" {} \; 2>/dev/null | wc -l | tr -d ' ')
if [ "$img_url_count" -gt 0 ]; then
    echo "❌ DEPRECATED FILTERS: $img_url_count files with img_url"
    find . -name "*.liquid" -not -path "./backup*" -exec grep -l "img_url" {} \; 2>/dev/null | head -5
    total_issues=$((total_issues + img_url_count))
else
    echo "✅ DEPRECATED FILTERS: No img_url filters found"
fi

# Check for missing alt attributes
missing_alt=$(grep -r "<img" --include="*.liquid" snippets/ sections/ templates/ 2>/dev/null | grep -v "alt=" | wc -l | tr -d ' ')
echo "⚠️ IMAGES WITHOUT ALT: $missing_alt images"
if [ "$missing_alt" -gt 50 ]; then
    total_issues=$((total_issues + 20))
fi

# Check for missing width/height
missing_dimensions=$(grep -r "<img" --include="*.liquid" snippets/ sections/ templates/ 2>/dev/null | grep -v "width=" | wc -l | tr -d ' ')
echo "⚠️ IMAGES WITHOUT DIMENSIONS: $missing_dimensions images"
if [ "$missing_dimensions" -gt 100 ]; then
    total_issues=$((total_issues + 15))
fi

echo
echo "2. 📝 JSON VALIDATION..."
echo "======================"

json_errors=0
for file in locales/*.json; do
    if ! python3 -m json.tool "$file" > /dev/null 2>&1; then
        echo "❌ $(basename $file) - Invalid JSON"
        json_errors=$((json_errors + 1))
    else
        echo "✅ $(basename $file) - Valid JSON"
    fi
done

if [ "$json_errors" -eq 0 ]; then
    echo "✅ All JSON files are valid"
else
    echo "❌ $json_errors JSON files have syntax errors"
    total_issues=$((total_issues + json_errors * 5))
fi

echo
echo "3. 🔒 SECURITY SCAN..."
echo "===================="

# Check for REAL exposed secrets (not false positives)
real_secrets_count=$(grep -r "sk_live_\|pk_live_\|AIza[A-Za-z0-9]\{35\}\|sk_test_[A-Za-z0-9]\{50\}\|pk_test_[A-Za-z0-9]\{50\}" --include="*.liquid" --include="*.js" snippets/ sections/ templates/ assets/ 2>/dev/null | wc -l | tr -d ' ')

# Check for hardcoded API keys with actual values
api_keys_count=$(grep -rE "(api.*key.*=.*['\"][A-Za-z0-9]{20,}['\"]|secret.*=.*['\"][A-Za-z0-9]{20,}['\"])" --include="*.liquid" --include="*.js" snippets/ sections/ templates/ assets/ 2>/dev/null | wc -l | tr -d ' ')

total_security_issues=$((real_secrets_count + api_keys_count))

if [ "$total_security_issues" -gt 0 ]; then
    echo "❌ SECURITY: $total_security_issues REAL secret exposures detected"
    echo "  🔑 Live keys: $real_secrets_count"
    echo "  🔐 API keys: $api_keys_count"
    total_issues=$((total_issues + total_security_issues * 10))
else
    echo "✅ SECURITY: No critical secret exposures"
fi

echo
echo "4. 🐛 PRODUCTION CLEANUP..."
echo "========================="

# Check for console.log statements
console_count=$(grep -r "console\." --include="*.liquid" --include="*.js" snippets/ sections/ templates/ assets/ 2>/dev/null | grep -v "vendor\|min\." | wc -l | tr -d ' ')
if [ "$console_count" -gt 50 ]; then
    echo "⚠️ DEBUG CODE: $console_count console statements (clean for production)"
    total_issues=$((total_issues + 5))
else
    echo "✅ DEBUG CODE: Minimal console statements"
fi

echo
echo "5. ♿ BASIC ACCESSIBILITY..."
echo "=========================="

# Check for too many H1 tags
h1_count=$(grep -r "<h1" --include="*.liquid" sections/ templates/ layout/ 2>/dev/null | wc -l | tr -d ' ')
if [ "$h1_count" -gt 5 ]; then
    echo "⚠️ HEADINGS: $h1_count H1 tags found (SEO: max 1 per page recommended)"
    total_issues=$((total_issues + 3))
else
    echo "✅ HEADINGS: Good H1 usage"
fi

echo
echo "6. 📁 FILE ORGANIZATION..."
echo "========================"

# Check git status
uncommitted=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
if [ "$uncommitted" -gt 0 ]; then
    echo "⚠️ GIT: $uncommitted uncommitted files"
    total_issues=$((total_issues + 2))
else
    echo "✅ GIT: All files committed"
fi

echo
echo "🎯 VALIDATION SUMMARY"
echo "===================="

# Calculate score
max_score=100
penalty_score=$(echo "scale=0; $total_issues * 2" | bc 2>/dev/null || echo $((total_issues * 2)))
final_score=$(echo "scale=0; $max_score - $penalty_score" | bc 2>/dev/null || echo $((max_score - penalty_score)))

if [ "$final_score" -lt 0 ]; then
    final_score=0
fi

if [ "$total_issues" -eq 0 ]; then
    echo "🎉 PERFECT SCORE: No critical issues detected!"
    echo "✅ Theme is production-ready"
elif [ "$total_issues" -lt 10 ]; then
    echo "✅ GOOD: $total_issues minor issues detected"
    echo "🎯 Theme Score: $final_score/100"
elif [ "$total_issues" -lt 25 ]; then
    echo "⚠️ MODERATE: $total_issues issues need attention"
    echo "🎯 Theme Score: $final_score/100"
else
    echo "❌ CRITICAL: $total_issues issues require immediate fixes"
    echo "🎯 Theme Score: $final_score/100"
fi

echo
echo "🔧 RECOMMENDATIONS:"
if [ "$img_url_count" -gt 0 ]; then
    echo "1. Run manual img_url filter corrections"
fi
if [ "$json_errors" -gt 0 ]; then
    echo "2. Fix JSON syntax errors in locale files"
fi
if [ "$secrets_count" -gt 0 ]; then
    echo "3. Review and secure exposed secrets"
fi
if [ "$missing_dimensions" -gt 100 ]; then
    echo "4. Add width/height to images for better CLS scores"
fi

echo
echo "✅ Fast validation completed! $(date)"
echo "================================================"

exit 0
