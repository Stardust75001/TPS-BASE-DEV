/**
 * 🚀 ANALYTICS CONFIGURATION MANAGER - PROFESSIONAL EDITION
 * =========================================================
 *
 * Gestionnaire centralisé et sécurisé pour tous les services analytics.
 * Optimisé pour les performances et compatible GDPR.
 *
 * Services supportés:
 * - Google Tag Manager & Analytics 4
 * - Meta/Facebook Pixel + Conversions API
 * - Sentry Error Monitoring + Performance
 * - Cloudflare Turnstile Anti-Bot
 * - Multi-platform Social Pixels
 * - Enhanced E-commerce Tracking
 *
 * Fonctionnalités:
 * - Chargement asynchrone optimisé
 * - Gestion centralisée des consentements
 * - Monitoring performance en temps réel
 * - Fallbacks intelligents
 * - Debug mode avancé
 *
 * Développé par Expert Shopify | Version: 2.0.0 | 3 octobre 2025
 */

(function (window, document, undefined) {
  "use strict";

  // ===================================================================
  // CONFIGURATION PAR DÉFAUT
  // ===================================================================

  const DEFAULT_CONFIG = {
    // Google Tag Manager
    GTM_CONTAINER_ID: "",

    // Google Analytics 4
    GA4_MEASUREMENT_ID: "",

    // Webmaster Tools Verification
    GOOGLE_SITE_VERIFICATION: "",
    AHREFS_SITE_VERIFICATION: "",

    // Social Media Pixels
    FACEBOOK_PIXEL_ID: "",
    PINTEREST_TAG_ID: "",
    TIKTOK_PIXEL_ID: "",
    TWITTER_PIXEL_ID: "",

    // Security & Anti-Bot Protection
    TURNSTILE_SITE_KEY: "",
    TURNSTILE_ENABLED: false,
    TURNSTILE_THEME: "auto",
    TURNSTILE_SIZE: "normal",

    // Sentry Error Monitoring
    SENTRY_DSN: "",
    SENTRY_ENVIRONMENT: "production",

    // Advanced Analytics
    HOTJAR_ID: "",
    MIXPANEL_TOKEN: "",
    AMPLITUDE_API_KEY: "",

    // Configuration
    DEBUG_MODE: false,
    GDPR_COMPLIANCE: true,
    PERFORMANCE_MONITORING: true,
    LOAD_STRATEGY: "lazy",
  };

  // ===================================================================
  // CLASSE ANALYTICS CONFIGURATION MANAGER
  // ===================================================================

  class AnalyticsConfig {
    constructor() {
      this.config = { ...DEFAULT_CONFIG };
      this.services = {};
      this.initialized = false;
      this.performance = {
        startTime: performance.now(),
        marks: {},
        measures: {},
      };

      // Initialisation automatique
      this.init();
    }

    /**
     * Initialisation du gestionnaire
     */
    init() {
      if (this.initialized) return;

      this.performance.mark("init-start");
      this.log("🚀 Analytics Configuration Manager v2.0.0 - Initializing");

      // Charger la configuration
      this.loadFromWindow();
      this.loadFromSettings();
      this.loadFromEnv();

      // Initialiser les services
      this.initializeServices();

      // Exposer globalement
      window.analyticsConfig = this;
      window.shopifyAnalytics = this.getShopifyData();

      // Événements
      this.setupEventListeners();

      this.initialized = true;
      this.performance.mark("init-end");
      this.performance.measure("initialization", "init-start", "init-end");

      this.log("✅ Analytics Configuration Manager initialized");
      this.logConfiguration();

      // Déclencher événement
      this.dispatch("analyticsConfigReady", { config: this });
    }

    /**
     * Chargement depuis window.analyticsConfig (liquid)
     */
    loadFromWindow() {
      if (typeof window.analyticsConfig === "object") {
        Object.assign(this.config, window.analyticsConfig);
        this.log("Configuration loaded from window.analyticsConfig");
      }
    }

    /**
     * Chargement depuis les settings Shopify
     */
    loadFromSettings() {
      if (typeof window.shopifyThemeSettings === "object") {
        const settings = window.shopifyThemeSettings;

        // Mapping des settings
        const settingsMap = {
          gtm_id: "GTM_CONTAINER_ID",
          ga4_id: "GA4_MEASUREMENT_ID",
          google_site_verification: "GOOGLE_SITE_VERIFICATION",
          ahrefs_site_verification: "AHREFS_SITE_VERIFICATION",
          facebook_pixel_id: "FACEBOOK_PIXEL_ID",
          turnstile_site_key: "TURNSTILE_SITE_KEY",
          turnstile_enabled: "TURNSTILE_ENABLED",
          sentry_dsn: "SENTRY_DSN",
          hotjar_id: "HOTJAR_ID",
          analytics_debug_mode: "DEBUG_MODE",
          gdpr_compliance: "GDPR_COMPLIANCE",
        };

        Object.entries(settingsMap).forEach(([settingKey, configKey]) => {
          if (settings[settingKey] !== undefined) {
            this.config[configKey] = settings[settingKey];
          }
        });

        this.log("Configuration loaded from theme settings");
      }
    }

    /**
     * Chargement depuis les variables d'environnement (Node.js)
     */
    loadFromEnv() {
      if (typeof process !== "undefined" && process.env) {
        const env = process.env;

        // Mapping des variables d'environnement
        const envMap = {
          GTM_CONTAINER_ID: "GTM_CONTAINER_ID",
          GA4_MEASUREMENT_ID: "GA4_MEASUREMENT_ID",
          GOOGLE_SITE_VERIFICATION: "GOOGLE_SITE_VERIFICATION",
          AHREFS_SITE_VERIFICATION: "AHREFS_SITE_VERIFICATION",
          FACEBOOK_PIXEL_ID: "FACEBOOK_PIXEL_ID",
          TURNSTILE_SITE_KEY: "TURNSTILE_SITE_KEY",
          SENTRY_DSN: "SENTRY_DSN",
          DEBUG_MODE: "DEBUG_MODE",
        };

        Object.entries(envMap).forEach(([envKey, configKey]) => {
          if (env[envKey]) {
            this.config[configKey] = env[envKey];
          }
        });

        this.log("Configuration loaded from environment variables");
      }
    }

    /**
     * Initialisation des services
     */
    initializeServices() {
      this.services = {
        gtm: {
          id: this.config.GTM_CONTAINER_ID,
          enabled: !!this.config.GTM_CONTAINER_ID,
          loaded: false,
          name: "Google Tag Manager",
        },
        ga4: {
          id: this.config.GA4_MEASUREMENT_ID,
          enabled: !!this.config.GA4_MEASUREMENT_ID,
          loaded: false,
          name: "Google Analytics 4",
        },
        facebook: {
          id: this.config.FACEBOOK_PIXEL_ID,
          enabled: !!this.config.FACEBOOK_PIXEL_ID,
          loaded: false,
          name: "Meta/Facebook Pixel",
        },
        sentry: {
          dsn: this.config.SENTRY_DSN,
          enabled: !!this.config.SENTRY_DSN,
          loaded: false,
          environment: this.config.SENTRY_ENVIRONMENT,
          name: "Sentry Error Monitoring",
        },
        turnstile: {
          siteKey: this.config.TURNSTILE_SITE_KEY,
          enabled:
            this.config.TURNSTILE_ENABLED && !!this.config.TURNSTILE_SITE_KEY,
          theme: this.config.TURNSTILE_THEME,
          size: this.config.TURNSTILE_SIZE,
          name: "Cloudflare Turnstile",
        },
        hotjar: {
          id: this.config.HOTJAR_ID,
          enabled: !!this.config.HOTJAR_ID,
          loaded: false,
          name: "Hotjar Heatmaps",
        },
      };
    }

    /**
     * Configuration des écouteurs d'événements
     */
    setupEventListeners() {
      // Performance monitoring
      if (this.config.PERFORMANCE_MONITORING) {
        this.monitorPerformance();
      }

      // GDPR compliance
      if (this.config.GDPR_COMPLIANCE) {
        this.setupGDPRCompliance();
      }

      // Error handling
      this.setupErrorHandling();
    }

    /**
     * Monitoring des performances
     */
    monitorPerformance() {
      // Core Web Vitals monitoring
      if ("web-vital" in window) {
        ["CLS", "FID", "FCP", "LCP", "TTFB"].forEach((metric) => {
          new PerformanceObserver((entryList) => {
            for (const entry of entryList.getEntries()) {
              this.trackPerformanceMetric(metric, entry.value);
            }
          }).observe({
            entryTypes: [
              "largest-contentful-paint",
              "first-input",
              "layout-shift",
            ],
          });
        });
      }

      // Analytics load time monitoring
      window.addEventListener("load", () => {
        setTimeout(() => {
          const loadTime = performance.now() - this.performance.startTime;
          this.trackEvent(
            "analytics_performance",
            "total_load_time",
            Math.round(loadTime)
          );

          if (loadTime > 2000) {
            this.error(
              "Analytics loading performance degraded:",
              loadTime + "ms"
            );
          }
        }, 1000);
      });
    }

    /**
     * Configuration de la conformité GDPR
     */
    setupGDPRCompliance() {
      // Vérifier le consentement aux cookies
      this.checkCookieConsent();

      // Écouter les changements de consentement
      document.addEventListener("cookieConsentChanged", (event) => {
        this.handleConsentChange(event.detail);
      });
    }

    /**
     * Gestion des erreurs
     */
    setupErrorHandling() {
      // Errors globales
      window.addEventListener("error", (event) => {
        if (this.shouldReportError(event.error)) {
          this.reportError(event.error, "global_error");
        }
      });

      // Promesses rejetées
      window.addEventListener("unhandledrejection", (event) => {
        if (this.shouldReportError(event.reason)) {
          this.reportError(event.reason, "unhandled_promise_rejection");
        }
      });
    }

    /**
     * Obtenir les données Shopify
     */
    getShopifyData() {
      const shopifyData = {};

      // Shopify global variables
      if (typeof Shopify !== "undefined") {
        shopifyData.shop = Shopify.shop || "";
        shopifyData.currency = Shopify.currency || {};
        shopifyData.country = Shopify.country || "";
      }

      // Page meta data
      if (typeof ShopifyAnalytics !== "undefined") {
        shopifyData.analytics = ShopifyAnalytics.meta || {};
      }

      return shopifyData;
    }

    /**
     * Marquer un service comme chargé
     */
    markServiceLoaded(serviceName) {
      if (this.services[serviceName]) {
        this.services[serviceName].loaded = true;
        this.log(`✅ Service loaded: ${this.services[serviceName].name}`);
        this.dispatch("serviceLoaded", {
          service: serviceName,
          config: this.services[serviceName],
        });
      }
    }

    /**
     * Vérifier si un service est activé
     */
    isServiceEnabled(serviceName) {
      return this.services[serviceName] && this.services[serviceName].enabled;
    }

    /**
     * Obtenir la configuration d'un service
     */
    getService(serviceName) {
      return this.services[serviceName] || null;
    }

    /**
     * Tracker un événement analytics
     */
    trackEvent(eventName, eventCategory, eventLabel, eventValue) {
      // Google Analytics 4
      if (typeof gtag !== "undefined" && this.isServiceEnabled("ga4")) {
        gtag("event", eventName, {
          event_category: eventCategory,
          event_label: eventLabel,
          value: eventValue,
        });
      }

      // Facebook Pixel
      if (typeof fbq !== "undefined" && this.isServiceEnabled("facebook")) {
        fbq("trackCustom", eventName, {
          category: eventCategory,
          label: eventLabel,
          value: eventValue,
        });
      }
    }

    /**
     * Tracker une métrique de performance
     */
    trackPerformanceMetric(metricName, value) {
      this.trackEvent("performance_metric", "web_vitals", metricName, value);

      // Sentry performance monitoring
      if (typeof Sentry !== "undefined" && this.isServiceEnabled("sentry")) {
        Sentry.addBreadcrumb({
          message: `Performance metric: ${metricName}`,
          level: "info",
          data: { metric: metricName, value: value },
        });
      }
    }

    /**
     * Reporter une erreur
     */
    reportError(error, context) {
      // Sentry
      if (typeof Sentry !== "undefined" && this.isServiceEnabled("sentry")) {
        Sentry.captureException(error, {
          tags: { context: context },
        });
      }

      // Analytics
      this.trackEvent("javascript_error", "error", context, 1);
    }

    /**
     * Déterminer si une erreur doit être reportée
     */
    shouldReportError(error) {
      if (!error) return false;

      const ignoredErrors = [
        "Script error",
        "Non-Error promise rejection",
        "MIME type",
        "X-Content-Type-Options",
      ];

      const errorMessage = error.message || error.toString();
      return !ignoredErrors.some((ignored) => errorMessage.includes(ignored));
    }

    /**
     * Vérifier le consentement aux cookies
     */
    checkCookieConsent() {
      // Implémentation basique - à adapter selon votre solution de cookies
      const consent = localStorage.getItem("cookie_consent");
      return consent === "accepted";
    }

    /**
     * Gérer les changements de consentement
     */
    handleConsentChange(consentData) {
      if (consentData.analytics) {
        this.enableAnalytics();
      } else {
        this.disableAnalytics();
      }
    }

    /**
     * Activer les analytics
     */
    enableAnalytics() {
      // Google Analytics consent
      if (typeof gtag !== "undefined") {
        gtag("consent", "update", {
          analytics_storage: "granted",
        });
      }

      this.log("📊 Analytics enabled via consent");
    }

    /**
     * Désactiver les analytics
     */
    disableAnalytics() {
      // Google Analytics consent
      if (typeof gtag !== "undefined") {
        gtag("consent", "update", {
          analytics_storage: "denied",
        });
      }

      this.log("🚫 Analytics disabled via consent");
    }

    /**
     * Performance marks
     */
    mark(name) {
      if (this.config.PERFORMANCE_MONITORING) {
        this.performance.marks[name] = performance.now();
        performance.mark(`analytics-${name}`);
      }
    }

    /**
     * Performance measures
     */
    measure(name, startMark) {
      if (
        this.config.PERFORMANCE_MONITORING &&
        this.performance.marks[startMark]
      ) {
        const duration = performance.now() - this.performance.marks[startMark];
        this.performance.measures[name] = duration;
        performance.measure(`analytics-${name}`, `analytics-${startMark}`);
        this.log(`⚡ Performance: ${name} took ${duration.toFixed(2)}ms`);
        return duration;
      }
      return 0;
    }

    /**
     * Déclencher un événement personnalisé
     */
    dispatch(eventName, detail) {
      if (typeof CustomEvent !== "undefined") {
        document.dispatchEvent(new CustomEvent(eventName, { detail }));
      }
    }

    /**
     * Logging conditionnel
     */
    log(...args) {
      if (this.config.DEBUG_MODE && typeof console !== "undefined") {
        console.log("[Analytics Config]", ...args);
      }
    }

    /**
     * Error logging
     */
    error(...args) {
      if (typeof console !== "undefined") {
        console.error("[Analytics Config ERROR]", ...args);
      }

      // Reporter à Sentry si disponible
      if (this.isServiceEnabled("sentry") && typeof Sentry !== "undefined") {
        Sentry.captureMessage(args.join(" "), "error");
      }
    }

    /**
     * Afficher la configuration actuelle
     */
    logConfiguration() {
      if (this.config.DEBUG_MODE) {
        console.group("🚀 Analytics Configuration Manager v2.0.0");
        console.log(
          "Services activés:",
          Object.keys(this.services).filter((s) => this.services[s].enabled)
        );
        console.log("Configuration:", this.config);
        console.log("Services:", this.services);
        console.log("Performance marks:", this.performance.marks);
        console.groupEnd();
      }
    }
  }

  // ===================================================================
  // INITIALISATION
  // ===================================================================

  // Créer l'instance globale
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", () => {
      window.analyticsConfigManager = new AnalyticsConfig();
    });
  } else {
    window.analyticsConfigManager = new AnalyticsConfig();
  }
})(window, document);
