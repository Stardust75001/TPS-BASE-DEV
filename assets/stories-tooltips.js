/**
 * Stories Tooltips - TPS BASE DEV
 * Système d'infobulles centré précisément au-dessus des icônes
 */

function debug(...args) {
  if (typeof isDev !== "undefined" && isDev) {
    console.debug("[Stories Tooltip]", ...args);
  }
}

document.addEventListener("DOMContentLoaded", function () {
  const isMobile = window.matchMedia("(hover: none)").matches;
  debug("isMobile:", isMobile);

  document.querySelectorAll(".animated-stories-link").forEach((link) => {
    const tooltip = link.querySelector(".tooltip-bubble");
    if (!tooltip) return;

    // Desktop : hover = tooltip, clic = navigation directe
    if (!isMobile) {
      link.addEventListener(
        "mouseenter",
        () => {
          tooltip.classList.add("hover-visible");
          debug("Hover enter on", link);
          setTimeout(() => adjustTooltipPosition(tooltip), 0);
        },
        { passive: true }
      );

      link.addEventListener(
        "mouseleave",
        () => {
          tooltip.classList.remove("hover-visible");
          debug("Hover leave on", link);
          resetTooltipPosition(tooltip);
        },
        { passive: true }
      );

      // Pas besoin de bloquer le clic → navigation normale
    }

    // Mobile : 1er clic affiche tooltip, 2e clic déclenche navigation
    else {
      let tappedOnce = false;

      link.addEventListener("click", (e) => {
        if (!tappedOnce) {
          e.preventDefault();
          debug("1er tap on", link);

          // Cache autres infobulles
          document
            .querySelectorAll(".tooltip-bubble.tap-visible")
            .forEach((el) => {
              el.classList.remove("tap-visible");
            });

          tooltip.classList.add("tap-visible");
          setTimeout(() => adjustTooltipPosition(tooltip), 0);
          tappedOnce = true;

          // Reset si pas de second clic
          setTimeout(() => {
            tooltip.classList.remove("tap-visible");
            tappedOnce = false;
            resetTooltipPosition(tooltip);
          }, 2000);
        } else {
          debug("2e tap - navigating");
          // Laisse le lien s'ouvrir normalement
        }
      });
    }
  });
});

// Ajustement position tooltip (évite débordement)
function adjustTooltipPosition(tooltip) {
  // Positionne au-dessus de l'icône, centré horizontalement
  tooltip.style.left = "50%";
  tooltip.style.top = "-45px"; // Au-dessus de l'icône
  tooltip.style.transform = "translateX(-50%)";

  // Vérification débordement écran
  const rect = tooltip.getBoundingClientRect();
  const viewportWidth = window.innerWidth;

  // Ajustement si débordement à droite
  if (rect.right > viewportWidth - 10) {
    tooltip.style.left = "auto";
    tooltip.style.right = "0";
    tooltip.style.transform = "translateX(0)";
  }
  // Ajustement si débordement à gauche
  else if (rect.left < 10) {
    tooltip.style.left = "0";
    tooltip.style.right = "auto";
    tooltip.style.transform = "translateX(0)";
  }
}

function resetTooltipPosition(tooltip) {
  // Remet position par défaut au-dessus de l'icône
  tooltip.style.left = "50%";
  tooltip.style.top = "-45px";
  tooltip.style.transform = "translateX(-50%)";
  tooltip.style.right = "auto";
}

// Gestion des redimensionnements de fenêtre
window.addEventListener("resize", function () {
  document
    .querySelectorAll(
      ".tooltip-bubble.hover-visible, .tooltip-bubble.tap-visible"
    )
    .forEach((tooltip) => {
      adjustTooltipPosition(tooltip);
    });
});

// Reset global sur changement de page
window.addEventListener("beforeunload", function () {
  document.querySelectorAll(".tooltip-bubble").forEach((tooltip) => {
    tooltip.classList.remove("hover-visible", "tap-visible");
  });
});

debug("Stories Tooltips initialized - Positioning: ABOVE icons");
