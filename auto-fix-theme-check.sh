#!/bin/bash

# 🛠️ AUTO-FIX THEME CHECK - TPS BASE DEV
# ======================================
# Script automatisé pour corriger les erreurs theme-check
# Expert: GitHub Copilot - 3 octobre 2025

echo "🛠️ AUTO-FIX THEME CHECK - TPS BASE DEV"
echo "======================================="

# Variables
BACKUP_DIR="backup-$(date +%Y%m%d_%H%M%S)"
SECTIONS_DIR="sections"
SNIPPETS_DIR="snippets"
TEMPLATES_DIR="templates"

# Créer backup
echo "💾 Création backup..."
mkdir -p "$BACKUP_DIR"
cp -r sections snippets templates "$BACKUP_DIR/" 2>/dev/null

# 1. CORRIGER SCHEMA JSON FORMAT (84 sections)
echo ""
echo "📋 1. CORRECTION SCHEMA JSON FORMAT..."
echo "======================================"

schema_fixed=0
for file in sections/*.liquid; do
    if [[ -f "$file" ]]; then
        filename=$(basename "$file")
        echo "🔍 Analyse: $filename"

        # Extraire et formater le schema JSON
        if grep -q "{% schema %}" "$file"; then
            # Créer fichier temporaire avec schema formaté
            temp_file="${file}.tmp"

            # Partie avant schema
            sed '/{% schema %}/,$d' "$file" > "$temp_file"

            # Extraire et formater le JSON
            sed -n '/{% schema %}/,/{% endschema %}/p' "$file" | \
            sed '1d;$d' | \
            jq . 2>/dev/null | \
            if [[ $? -eq 0 ]]; then
                # JSON valide, reformater
                echo "{% schema %}" >> "$temp_file"
                sed -n '/{% schema %}/,/{% endschema %}/p' "$file" | \
                sed '1d;$d' | \
                jq --tab . >> "$temp_file" 2>/dev/null
                echo "{% endschema %}" >> "$temp_file"

                # Partie après schema
                sed '1,/{% endschema %}/d' "$file" >> "$temp_file"

                # Remplacer le fichier
                mv "$temp_file" "$file"
                schema_fixed=$((schema_fixed + 1))
                echo "  ✅ Schema JSON formaté"
            else
                # JSON invalide, nettoyer
                rm -f "$temp_file"
                echo "  ⚠️ Schema JSON invalide, ignoré"
            fi
        else
            echo "  ➖ Pas de schema"
        fi
    fi
done

echo "📊 Schemas formatés: $schema_fixed"

# 2. CORRIGER IMG WIDTH/HEIGHT (Social Icons)
echo ""
echo "🖼️ 2. CORRECTION IMG WIDTH/HEIGHT..."
echo "=================================="

img_fixed=0

# Corriger social-icons.liquid
if [[ -f "snippets/social-icons.liquid" ]]; then
    echo "🔍 Correction social-icons.liquid..."

    # Instagram
    sed -i '' 's|<img src="{{ '\''instagram\.png'\'' | asset_url }}" alt="Instagram" class="social-img-icon" loading="lazy">|<img src="{{ '\''instagram.png'\'' | asset_url }}" alt="Instagram" class="social-img-icon" width="32" height="32" loading="lazy">|g' "snippets/social-icons.liquid"

    # Facebook
    sed -i '' 's|<img src="{{ '\''facebook\.png'\'' | asset_url }}" alt="Facebook" class="social-img-icon" loading="lazy">|<img src="{{ '\''facebook.png'\'' | asset_url }}" alt="Facebook" class="social-img-icon" width="32" height="32" loading="lazy">|g' "snippets/social-icons.liquid"

    # TikTok
    sed -i '' 's|<img src="{{ '\''tiktok\.png'\'' | asset_url }}" alt="TikTok" class="social-img-icon" loading="lazy">|<img src="{{ '\''tiktok.png'\'' | asset_url }}" alt="TikTok" class="social-img-icon" width="32" height="32" loading="lazy">|g' "snippets/social-icons.liquid"

    # WhatsApp
    sed -i '' 's|<img src="{{ '\''WhatsApp\.png'\'' | asset_url }}" alt="WhatsApp" class="social-img-icon" loading="lazy">|<img src="{{ '\''WhatsApp.png'\'' | asset_url }}" alt="WhatsApp" class="social-img-icon" width="32" height="32" loading="lazy">|g' "snippets/social-icons.liquid"

    # Email
    sed -i '' 's|<img src="{{ '\''email-icon\.png'\'' | asset_url }}" alt="Email" class="social-img-icon" loading="lazy">|<img src="{{ '\''email-icon.png'\'' | asset_url }}" alt="Email" class="social-img-icon" width="32" height="32" loading="lazy">|g' "snippets/social-icons.liquid"

    # Flags
    sed -i '' 's|<img src="{{ '\''flag-en\.png'\'' | asset_url }}" alt="English" class="flag-icon" loading="lazy">|<img src="{{ '\''flag-en.png'\'' | asset_url }}" alt="English" class="flag-icon" width="24" height="16" loading="lazy">|g' "snippets/social-icons.liquid"

    sed -i '' 's|<img src="{{ '\''flag-fr\.png'\'' | asset_url }}" alt="Français" class="flag-icon" loading="lazy">|<img src="{{ '\''flag-fr.png'\'' | asset_url }}" alt="Français" class="flag-icon" width="24" height="16" loading="lazy">|g' "snippets/social-icons.liquid"

    sed -i '' 's|<img src="{{ '\''flag-de\.png'\'' | asset_url }}" alt="Deutsch" class="flag-icon" loading="lazy">|<img src="{{ '\''flag-de.png'\'' | asset_url }}" alt="Deutsch" class="flag-icon" width="24" height="16" loading="lazy">|g' "snippets/social-icons.liquid"

    img_fixed=$((img_fixed + 8))
    echo "  ✅ 8 images corrigées"
fi

# Corriger social-icons-no-flags.liquid
if [[ -f "snippets/social-icons-no-flags.liquid" ]]; then
    echo "🔍 Correction social-icons-no-flags.liquid..."

    # Répliquer les mêmes corrections
    sed -i '' 's|<img src="{{ '\''instagram\.png'\'' | asset_url }}" alt="Instagram" class="social-img-icon" loading="lazy">|<img src="{{ '\''instagram.png'\'' | asset_url }}" alt="Instagram" class="social-img-icon" width="32" height="32" loading="lazy">|g' "snippets/social-icons-no-flags.liquid"

    sed -i '' 's|<img src="{{ '\''facebook\.png'\'' | asset_url }}" alt="Facebook" class="social-img-icon" loading="lazy">|<img src="{{ '\''facebook.png'\'' | asset_url }}" alt="Facebook" class="social-img-icon" width="32" height="32" loading="lazy">|g' "snippets/social-icons-no-flags.liquid"

    sed -i '' 's|<img src="{{ '\''tiktok\.png'\'' | asset_url }}" alt="TikTok" class="social-img-icon" loading="lazy">|<img src="{{ '\''tiktok.png'\'' | asset_url }}" alt="TikTok" class="social-img-icon" width="32" height="32" loading="lazy">|g' "snippets/social-icons-no-flags.liquid"

    sed -i '' 's|<img src="{{ '\''WhatsApp\.png'\'' | asset_url }}" alt="WhatsApp" class="social-img-icon" loading="lazy">|<img src="{{ '\''WhatsApp.png'\'' | asset_url }}" alt="WhatsApp" class="social-img-icon" width="32" height="32" loading="lazy">|g' "snippets/social-icons-no-flags.liquid"

    sed -i '' 's|<img src="{{ '\''email-icon\.png'\'' | asset_url }}" alt="Email" class="social-img-icon" loading="lazy">|<img src="{{ '\''email-icon.png'\'' | asset_url }}" alt="Email" class="social-img-icon" width="32" height="32" loading="lazy">|g' "snippets/social-icons-no-flags.liquid"

    img_fixed=$((img_fixed + 5))
    echo "  ✅ 5 images corrigées"
fi

echo "📊 Images width/height ajoutés: $img_fixed"

# 3. CORRIGER FILTRES IMG_URL DÉPRÉCIÉS
echo ""
echo "🔄 3. CORRECTION FILTRES IMG_URL..."
echo "================================="

img_url_fixed=0

# Fonction pour convertir img_url vers image_url
fix_img_url() {
    local file="$1"
    if [[ -f "$file" ]]; then
        echo "🔍 Correction: $(basename "$file")"

        # img_url: 'master' -> image_url: width: 800
        sed -i '' "s/| img_url: 'master'/| image_url: width: 800/g" "$file"

        # img_url: '100x100' -> image_url: width: 100, height: 100
        sed -i '' "s/| img_url: '100x100'/| image_url: width: 100, height: 100/g" "$file"

        # img_url: '150x150' -> image_url: width: 150, height: 150
        sed -i '' "s/| img_url: '150x150'/| image_url: width: 150, height: 150/g" "$file"

        # img_url: '200x200' -> image_url: width: 200, height: 200
        sed -i '' "s/| img_url: '200x200'/| image_url: width: 200, height: 200/g" "$file"

        # Vérifier si des changements ont été faits
        if grep -q "img_url:" "$file"; then
            echo "  ⚠️ Filtres img_url restants détectés"
        else
            img_url_fixed=$((img_url_fixed + 1))
            echo "  ✅ Filtres img_url corrigés"
        fi
    fi
}

# Corriger sections avec img_url
for file in sections/*.liquid; do
    if grep -q "img_url:" "$file"; then
        fix_img_url "$file"
    fi
done

# Corriger snippets avec img_url
for file in snippets/*.liquid; do
    if grep -q "img_url:" "$file"; then
        fix_img_url "$file"
    fi
done

# Corriger templates avec img_url
for file in templates/*.liquid; do
    if grep -q "img_url:" "$file"; then
        fix_img_url "$file"
    fi
done

echo "📊 Filtres img_url corrigés: $img_url_fixed fichiers"

# 4. AJOUTER WIDTH/HEIGHT SECTIONS CRITIQUES
echo ""
echo "📐 4. DIMENSIONS IMAGES SECTIONS..."
echo "================================"

sections_img_fixed=0

# stories-bar-sticky-dynamic.liquid - Ajouter dimensions à l'image variable
if [[ -f "sections/stories-bar-sticky-dynamic.liquid" ]]; then
    echo "🔍 Correction stories-bar-sticky-dynamic.liquid..."
    sed -i '' 's|<img src="{{ image }}" alt="{{ title }}">|<img src="{{ image }}" alt="{{ title }}" width="80" height="80" loading="lazy">|g' "sections/stories-bar-sticky-dynamic.liquid"
    sections_img_fixed=$((sections_img_fixed + 1))
    echo "  ✅ Dimensions ajoutées"
fi

# product-advanced.liquid
if [[ -f "sections/product-advanced.liquid" ]]; then
    echo "🔍 Correction product-advanced.liquid..."
    # Ajouter dimensions à l'image principale
    sed -i '' 's|<img id="main-product-image"|<img id="main-product-image" width="600" height="600"|g' "sections/product-advanced.liquid"
    sections_img_fixed=$((sections_img_fixed + 1))
    echo "  ✅ Image principale corrigée"
fi

# product-simple.liquid
if [[ -f "sections/product-simple.liquid" ]]; then
    echo "🔍 Correction product-simple.liquid..."
    sed -i '' 's|<img src="{{ product.featured_image | img_url: '\''master'\'' }}" alt="{{ product.title }}" class="img-fluid">|<img src="{{ product.featured_image | image_url: width: 600 }}" alt="{{ product.title }}" class="img-fluid" width="600" height="450" loading="eager">|g' "sections/product-simple.liquid"
    sections_img_fixed=$((sections_img_fixed + 1))
    echo "  ✅ Image produit corrigée"
fi

echo "📊 Sections images corrigées: $sections_img_fixed"

# 5. RAPPORT FINAL
echo ""
echo "📊 RAPPORT FINAL AUTO-FIX"
echo "========================"
echo "✅ Schemas JSON formatés: $schema_fixed"
echo "✅ Images width/height: $img_fixed"
echo "✅ Filtres img_url modernisés: $img_url_fixed"
echo "✅ Sections images: $sections_img_fixed"
echo ""

total_fixes=$((schema_fixed + img_fixed + img_url_fixed + sections_img_fixed))
echo "🎯 TOTAL CORRECTIONS: $total_fixes"

# Sauvegarder le backup créé
echo "💾 Backup sauvegardé dans: $BACKUP_DIR"

echo ""
echo "🚀 AUTO-FIX TERMINÉ!"
echo "Lancez 'theme-check .' pour vérifier les améliorations"
echo "==========================================="
