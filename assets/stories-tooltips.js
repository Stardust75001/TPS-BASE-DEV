/*function debug(...args) {

 * Stories Tooltips - TPS BASE DEV  if (typeof isDev !== 'undefined' && // Ajustement position tooltip (évite débordement)

 * Système d'infobulles centré précisément au-dessus des icônesfunction adjustTooltipPosition(tooltip) {

 */  // Positionne au-dessus de l'icône, centré horizontalement

  tooltip.style.left = "50%";

function debug(...args) {  tooltip.style.top = "-45px"; // Au-dessus de l'icône

  if (typeof isDev !== 'undefined' && isDev) {  tooltip.style.transform = "translateX(-50%)";

    console.debug('[Stories Tooltip]', ...args);  

  }  // Vérification débordement écran

}  const rect = tooltip.getBoundingClientRect();

  const viewportWidth = window.innerWidth;

document.addEventListener("DOMContentLoaded", function () {  

  const isMobile = window.matchMedia("(hover: none)").matches;  // Ajustement si débordement à droite

  debug("isMobile:", isMobile);  if (rect.right > viewportWidth - 10) {

    tooltip.style.left = "auto";

  document.querySelectorAll(".animated-stories-link").forEach(link => {    tooltip.style.right = "0";

    const tooltip = link.querySelector(".tooltip-bubble");    tooltip.style.transform = "translateX(0)";

    if (!tooltip) return;  }

  // Ajustement si débordement à gauche

    // Desktop : hover = tooltip, clic = navigation directe  else if (rect.left < 10) {

    if (!isMobile) {    tooltip.style.left = "0";

      link.addEventListener("mouseenter", () => {    tooltip.style.right = "auto";

        tooltip.classList.add("hover-visible");    tooltip.style.transform = "translateX(0)";

        debug("Hover enter on", link);  }

        setTimeout(() => adjustTooltipPosition(tooltip), 0);}

      }, { passive: true });

function resetTooltipPosition(tooltip) {

      link.addEventListener("mouseleave", () => {  // Reset vers position par défaut (au-dessus, centré)

        tooltip.classList.remove("hover-visible");  tooltip.style.left = "50%";

        debug("Hover leave on", link);  tooltip.style.top = "-45px";

        resetTooltipPosition(tooltip);  tooltip.style.right = "auto";

      }, { passive: true });  tooltip.style.transform = "translateX(-50%)";

    }}console.debug('[Stories Tooltip]', ...args);

  }

    // Mobile : 1er clic affiche tooltip, 2e clic déclenche navigation}

    else {

      let tappedOnce = false;document.addEventListener("DOMContentLoaded", function () {

  const isMobile = window.matchMedia("(hover: none)").matches;

      link.addEventListener("click", e => {  debug("isMobile:", isMobile);

        if (!tappedOnce) {

          e.preventDefault();  document.querySelectorAll(".animated-stories-link").forEach(link => {

          debug("1er tap on", link);    const tooltip = link.querySelector(".tooltip-bubble");

    if (!tooltip) return;

          // Cache autres infobulles

          document.querySelectorAll(".tooltip-bubble.tap-visible").forEach(el => {    // Desktop : hover = tooltip, clic = navigation directe

            el.classList.remove("tap-visible");    if (!isMobile) {

          });      link.addEventListener("mouseenter", () => {

        tooltip.classList.add("hover-visible");

          tooltip.classList.add("tap-visible");        debug("Hover enter on", link);

          setTimeout(() => adjustTooltipPosition(tooltip), 0);        setTimeout(() => adjustTooltipPosition(tooltip), 0);

          tappedOnce = true;      }, { passive: true });



          // Reset si pas de second clic      link.addEventListener("mouseleave", () => {

          setTimeout(() => {        tooltip.classList.remove("hover-visible");

            tooltip.classList.remove("tap-visible");        debug("Hover leave on", link);

            tappedOnce = false;        resetTooltipPosition(tooltip);

            resetTooltipPosition(tooltip);      }, { passive: true });

          }, 2000);

        } else {      // Pas besoin de bloquer le clic → navigation normale

          debug("2e tap - navigating");    }

          // Laisse le lien s'ouvrir normalement

        }    // Mobile : 1er clic affiche tooltip, 2e clic déclenche navigation

      });    else {

    }      let tappedOnce = false;

  });

});      link.addEventListener("click", e => {

        if (!tappedOnce) {

// Positionnement précis au-dessus de l'icône          e.preventDefault();

function adjustTooltipPosition(tooltip) {          debug("1er tap on", link);

  // Position de base : au-dessus de l'icône, centré horizontalement

  tooltip.style.left = "50%";          // Cache autres infobulles

  tooltip.style.top = "-45px";          document.querySelectorAll(".tooltip-bubble.tap-visible").forEach(el => {

  tooltip.style.transform = "translateX(-50%)";            el.classList.remove("tap-visible");

  tooltip.style.right = "auto";          });

  

  // Vérifier débordement après rendu          tooltip.classList.add("tap-visible");

  setTimeout(() => {          setTimeout(() => adjustTooltipPosition(tooltip), 0);

    const rect = tooltip.getBoundingClientRect();          tappedOnce = true;

    const viewportWidth = window.innerWidth;

              // Reset si pas de second clic

    // Ajustement si débordement à droite          setTimeout(() => {

    if (rect.right > viewportWidth - 10) {            tooltip.classList.remove("tap-visible");

      tooltip.style.left = "auto";            tappedOnce = false;

      tooltip.style.right = "0";            resetTooltipPosition(tooltip);

      tooltip.style.transform = "translateX(0)";          }, 2000);

    }        } else {

    // Ajustement si débordement à gauche            debug("2e tap - navigating");

    else if (rect.left < 10) {          // Laisse le lien s'ouvrir normalement

      tooltip.style.left = "0";        }

      tooltip.style.right = "auto";      });

      tooltip.style.transform = "translateX(0)";    }

    }  });

  }, 10);});

}

// Ajustement position tooltip (évite débordement)

function resetTooltipPosition(tooltip) {function adjustTooltipPosition(tooltip) {

  // Reset vers position par défaut  // Positionne toujours au centre de l’icône

  tooltip.style.left = "50%";  tooltip.style.left = "50%";

  tooltip.style.top = "-45px";  tooltip.style.top = "50%";

  tooltip.style.right = "auto";  tooltip.style.transform = "translate(-50%, -50%)";

  tooltip.style.transform = "translateX(-50%)";}

}
function resetTooltipPosition(tooltip) {
  tooltip.style.left = "50%";
  tooltip.style.top = "50%";
  tooltip.style.transform = "translate(-50%, -50%)";
}