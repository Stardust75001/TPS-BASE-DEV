#!/usr/bin/env node

/**
 * 🚀 ANALYTICS ENVIRONMENT INJECTOR - PROFESSIONAL EDITION
 * =========================================================
 *
 * Injecte les variables d'environnement dans les snippets Liquid.
 * Système de sécurisation et centralisation des tokens analytics.
 *
 * Fonctionnalités:
 * - Lecture sécurisée du fichier .env
 * - Injection automatique dans les snippets
 * - Validation des formats d'IDs
 * - Backup automatique des configurations
 * - Support multi-environnements
 *
 * Usage:
 * node analytics-env-injector.js
 *
 * Développé par Expert Shopify | Version: 2.0.0 | 3 octobre 2025
 */

const fs = require("fs");
const path = require("path");
const crypto = require("crypto");

// ===================================================================
// CONFIGURATION
// ===================================================================

// Charger dotenv si disponible
try {
  require("dotenv").config();
} catch (e) {
  console.warn("⚠️  dotenv non installé, utilisation des variables système");
}

// Mapping des variables d'environnement vers les noms Liquid
const CONFIG_MAPPING = {
  // Google Services
  GTM_CONTAINER_ID: "gtm_id",
  GA4_MEASUREMENT_ID: "ga4_id",
  GOOGLE_SITE_VERIFICATION: "google_site_verification",
  GOOGLE_API_KEY: "google_api_key",

  // Webmaster Tools
  AHREFS_SITE_VERIFICATION: "ahrefs_site_verification",
  BING_SITE_VERIFICATION: "bing_site_verification",
  YANDEX_SITE_VERIFICATION: "yandex_site_verification",

  // Social Media Pixels
  FACEBOOK_PIXEL_ID: "facebook_pixel_id",
  FACEBOOK_APP_ID: "facebook_app_id",
  PINTEREST_TAG_ID: "pinterest_tag_id",
  TIKTOK_PIXEL_ID: "tiktok_pixel_id",
  TWITTER_PIXEL_ID: "twitter_pixel_id",
  SNAPCHAT_PIXEL_ID: "snapchat_pixel_id",
  LINKEDIN_PARTNER_ID: "linkedin_partner_id",

  // Security & Anti-Bot
  TURNSTILE_SITE_KEY: "turnstile_site_key",
  TURNSTILE_ENABLED: "turnstile_enabled",
  TURNSTILE_THEME: "turnstile_theme",
  TURNSTILE_SIZE: "turnstile_size",
  RECAPTCHA_SITE_KEY: "recaptcha_site_key",

  // Monitoring & Analytics
  SENTRY_DSN: "sentry_dsn",
  SENTRY_ENVIRONMENT: "sentry_environment",
  SENTRY_SAMPLE_RATE: "sentry_sample_rate",
  HOTJAR_ID: "hotjar_id",
  MIXPANEL_TOKEN: "mixpanel_token",
  AMPLITUDE_API_KEY: "amplitude_api_key",
  SEGMENT_WRITE_KEY: "segment_write_key",

  // Configuration
  DEBUG_MODE: "analytics_debug",
  GDPR_COMPLIANCE: "gdpr_compliance",
  PERFORMANCE_MONITORING: "performance_monitoring",
};

// Validation des formats
const VALIDATION_PATTERNS = {
  gtm_id: /^GTM-[A-Z0-9]{6,8}$/,
  ga4_id: /^G-[A-Z0-9]{10}$/,
  facebook_pixel_id: /^\d{15,16}$/,
  google_site_verification: /^[a-zA-Z0-9_-]{20,50}$/,
  ahrefs_site_verification: /^[a-zA-Z0-9]{32}$/,
  turnstile_site_key: /^0x[A-Za-z0-9_-]{30,50}$/,
  sentry_dsn: /^https:\/\/[a-f0-9]{32}@[a-zA-Z0-9.-]+\/[0-9]+$/,
};

// ===================================================================
// CLASSE ANALYTICS ENV INJECTOR
// ===================================================================

class AnalyticsEnvInjector {
  constructor() {
    this.config = {};
    this.validationErrors = [];
    this.injectionResults = [];
    this.backupPath = null;
  }

  /**
   * Point d'entrée principal
   */
  async inject() {
    console.log("🚀 Analytics Environment Injector v2.0.0");
    console.log("==========================================\n");

    try {
      // Étapes d'injection
      this.loadConfiguration();
      this.validateConfiguration();
      this.createBackup();
      await this.injectIntoSnippets();
      await this.updateThemeLayout();
      this.generateReport();

      console.log("\n✅ Injection completed successfully!");
    } catch (error) {
      console.error("\n❌ Injection failed:", error.message);
      if (this.backupPath) {
        console.log("💾 Backup available at:", this.backupPath);
      }
      process.exit(1);
    }
  }

  /**
   * Charger la configuration depuis les variables d'environnement
   */
  loadConfiguration() {
    console.log("📋 Loading configuration from environment...");

    Object.entries(CONFIG_MAPPING).forEach(([envKey, configKey]) => {
      const value = process.env[envKey];
      if (value && value !== "" && value !== "undefined") {
        this.config[configKey] = value;
      }
    });

    console.log(
      `   Found ${Object.keys(this.config).length} configuration variables`
    );
  }

  /**
   * Valider la configuration
   */
  validateConfiguration() {
    console.log("🔍 Validating configuration...");

    Object.entries(this.config).forEach(([key, value]) => {
      if (VALIDATION_PATTERNS[key]) {
        const pattern = VALIDATION_PATTERNS[key];
        if (!pattern.test(value)) {
          this.validationErrors.push({
            key: key,
            value: value,
            pattern: pattern.toString(),
            message: `Invalid format for ${key}`,
          });
        }
      }
    });

    if (this.validationErrors.length > 0) {
      console.warn(
        `   ⚠️  Found ${this.validationErrors.length} validation warnings:`
      );
      this.validationErrors.forEach((error) => {
        console.warn(`     - ${error.key}: ${error.message}`);
      });
    } else {
      console.log("   ✅ All configurations valid");
    }
  }

  /**
   * Créer une sauvegarde des fichiers existants
   */
  createBackup() {
    console.log("💾 Creating backup...");

    const timestamp = new Date().toISOString().replace(/[:.]/g, "-");
    this.backupPath = path.join(__dirname, `backup-analytics-${timestamp}`);

    if (!fs.existsSync(this.backupPath)) {
      fs.mkdirSync(this.backupPath, { recursive: true });
    }

    // Sauvegarder les snippets existants
    const snippetsDir = path.join(__dirname, "snippets");
    const targetFiles = [
      "analytics-config.liquid",
      "analytics-tracking.liquid",
      "meta-tags.liquid",
    ];

    targetFiles.forEach((filename) => {
      const sourcePath = path.join(snippetsDir, filename);
      if (fs.existsSync(sourcePath)) {
        const backupFilePath = path.join(this.backupPath, filename);
        fs.copyFileSync(sourcePath, backupFilePath);
        console.log(`   📁 Backed up: ${filename}`);
      }
    });

    console.log(`   💾 Backup created: ${this.backupPath}`);
  }

  /**
   * Injecter dans les snippets Liquid
   */
  async injectIntoSnippets() {
    console.log("💉 Injecting into Liquid snippets...");

    const snippetsDir = path.join(__dirname, "snippets");
    const configSnippetPath = path.join(snippetsDir, "analytics-config.liquid");

    // Générer le contenu de configuration
    const configContent = this.generateConfigSnippet();

    // Écrire le fichier
    if (!fs.existsSync(snippetsDir)) {
      fs.mkdirSync(snippetsDir, { recursive: true });
    }

    fs.writeFileSync(configSnippetPath, configContent, "utf8");

    this.injectionResults.push({
      file: "snippets/analytics-config.liquid",
      status: "updated",
      size: configContent.length,
    });

    console.log("   ✅ Analytics configuration injected");
  }

  /**
   * Générer le contenu du snippet de configuration
   */
  generateConfigSnippet() {
    const timestamp = new Date().toISOString();
    const hash = crypto
      .createHash("md5")
      .update(JSON.stringify(this.config))
      .digest("hex")
      .substring(0, 8);

    let content = `{% comment %}
  🚀 ANALYTICS CONFIGURATION - AUTO-GENERATED
  ==========================================

  Generated by: Analytics Environment Injector v2.0.0
  Timestamp: ${timestamp}
  Configuration Hash: ${hash}

  ⚠️  WARNING: This file is auto-generated!
  Any manual changes will be lost on next injection.
  Update values in .env file instead.
{% endcomment %}

<script>
  window.analyticsEnvConfig = {`;

    // Ajouter les variables de configuration
    Object.entries(this.config).forEach(([key, value], index) => {
      const isLast = index === Object.entries(this.config).length - 1;
      const formattedValue = this.formatValue(value);
      content += `\n    ${key}: ${formattedValue}${isLast ? "" : ","}`;
    });

    content += `\n  };

  // Debug logging si activé
  if (window.analyticsEnvConfig.analytics_debug === 'true') {
    console.log('🚀 Analytics Environment Config loaded:', window.analyticsEnvConfig);
  }

  // Validation de la configuration
  if (typeof window.analyticsConfig !== 'undefined') {
    window.analyticsConfig.loadFromWindow();
  }
</script>

<!-- Meta tags automatiques pour discovery -->`;

    // Ajouter les meta tags de vérification
    const metaTags = [
      "google_site_verification",
      "ahrefs_site_verification",
      "bing_site_verification",
      "gtm_id",
      "ga4_id",
      "facebook_pixel_id",
    ];

    metaTags.forEach((tag) => {
      if (this.config[tag]) {
        const metaName = tag.replace("_", "-");
        content += `\n{% if settings.${tag} == blank %}<meta name="${metaName}" content="{{ '${this.config[tag]}' }}">{% endif %}`;
      }
    });

    return content;
  }

  /**
   * Formater une valeur pour JavaScript
   */
  formatValue(value) {
    // Booléens
    if (value === "true" || value === "false") {
      return value;
    }

    // Nombres
    if (/^\d+$/.test(value)) {
      return value;
    }

    // Chaînes (par défaut)
    return `'${value.replace(/'/g, "\\'")}'`;
  }

  /**
   * Mettre à jour le layout principal
   */
  async updateThemeLayout() {
    console.log("🎨 Updating theme layout...");

    const layoutPath = path.join(__dirname, "layout", "theme.liquid");

    if (!fs.existsSync(layoutPath)) {
      console.warn("   ⚠️  theme.liquid not found, skipping layout update");
      return;
    }

    let content = fs.readFileSync(layoutPath, "utf8");

    // Vérifier si déjà injecté
    if (content.includes("analytics-config")) {
      console.log("   ✅ Analytics already integrated in theme.liquid");
      return;
    }

    // Trouver le bon endroit pour injecter
    const headEndMatch = content.match(/<\/head>/);
    if (headEndMatch) {
      const injectionPoint = headEndMatch.index;
      const beforeHead = content.substring(0, injectionPoint);
      const afterHead = content.substring(injectionPoint);

      const injection = `
  {%- comment -%} Analytics Suite Professional - Auto-injected {%- endcomment -%}
  {% render 'analytics-config' %}
  {% render 'analytics-tracking' %}

`;

      content = beforeHead + injection + afterHead;
      fs.writeFileSync(layoutPath, content, "utf8");

      this.injectionResults.push({
        file: "layout/theme.liquid",
        status: "updated",
        changes: "Added analytics snippets integration",
      });

      console.log("   ✅ Theme layout updated");
    } else {
      console.warn("   ⚠️  Could not find </head> tag in theme.liquid");
    }
  }

  /**
   * Générer le rapport d'injection
   */
  generateReport() {
    console.log("\n📊 Injection Report");
    console.log("===================");

    console.log(`\n📋 Configuration Summary:`);
    console.log(`   Variables loaded: ${Object.keys(this.config).length}`);
    console.log(`   Validation errors: ${this.validationErrors.length}`);
    console.log(`   Files modified: ${this.injectionResults.length}`);

    if (Object.keys(this.config).length > 0) {
      console.log(`\n🔧 Loaded Services:`);
      Object.entries(this.config).forEach(([key, value]) => {
        const truncatedValue =
          value.length > 20 ? value.substring(0, 17) + "..." : value;
        console.log(`   ${key}: ${truncatedValue}`);
      });
    }

    if (this.injectionResults.length > 0) {
      console.log(`\n📁 Modified Files:`);
      this.injectionResults.forEach((result) => {
        console.log(`   ✅ ${result.file} - ${result.status}`);
      });
    }

    if (this.validationErrors.length > 0) {
      console.log(`\n⚠️  Validation Warnings:`);
      this.validationErrors.forEach((error) => {
        console.log(`   - ${error.key}: ${error.message}`);
      });
    }

    console.log(`\n💾 Backup: ${this.backupPath}`);

    // Instructions de test
    console.log(`\n🧪 Next Steps:`);
    console.log(`   1. Verify configuration in Shopify Admin`);
    console.log(`   2. Test analytics tracking in browser dev tools`);
    console.log(`   3. Check for console errors in debug mode`);
    console.log(`   4. Run theme check for validation`);
  }
}

// ===================================================================
// UTILITAIRES
// ===================================================================

/**
 * Lire le fichier .env et afficher un résumé
 */
function displayEnvSummary() {
  const envPath = path.join(__dirname, ".env");
  if (fs.existsSync(envPath)) {
    const envContent = fs.readFileSync(envPath, "utf8");
    const lines = envContent
      .split("\n")
      .filter(
        (line) => line.trim() && !line.startsWith("#") && line.includes("=")
      );

    console.log(`📁 Environment file: .env (${lines.length} variables)`);

    const analyticsVars = lines.filter((line) => {
      const key = line.split("=")[0];
      return Object.keys(CONFIG_MAPPING).includes(key);
    });

    console.log(
      `📊 Analytics variables: ${analyticsVars.length}/${
        Object.keys(CONFIG_MAPPING).length
      }`
    );
  } else {
    console.warn("⚠️  No .env file found");
  }
}

// ===================================================================
// EXÉCUTION
// ===================================================================

if (require.main === module) {
  // Mode CLI
  displayEnvSummary();

  const injector = new AnalyticsEnvInjector();
  injector.inject().catch((error) => {
    console.error("Fatal error:", error);
    process.exit(1);
  });
} else {
  // Mode module
  module.exports = AnalyticsEnvInjector;
}
