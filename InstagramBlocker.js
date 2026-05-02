// ============================================================
// InstagramBlocker.js
// Injected into every page load via WKUserScript.
// Blocks Reels via CSS + lightweight MutationObserver.
// ============================================================

(function () {
  'use strict';

  // ── CSS: hides reels nav tab and any already-rendered reel articles ──
  if (!document.getElementById('sntr-style')) {
    const s = document.createElement('style');
    s.id = 'sntr-style';
    s.textContent = `
      a[href="/reels/"],
      a[href*="/reels"],
      [aria-label="Reels"],
      svg[aria-label="Reels"] { display: none !important; }

      article:has(svg[aria-label="Reel"]),
      article:has(a[href*="/reel/"]),
      div:has(> a[href*="/reel/"]) { display: none !important; }
    `;
    (document.head || document.documentElement).appendChild(s);
  }

  // ── JS: catches reel articles that slip past CSS during dynamic loads ──
  function hideReelArticles() {
    document.querySelectorAll('article:not([data-sntr])').forEach(article => {
      article.setAttribute('data-sntr', '1');
      if (article.querySelector('a[href*="/reel/"], svg[aria-label="Reel"]')) {
        article.style.display = 'none';
      }
    });
  }

  hideReelArticles();

  // Debounced observer — only fires once per animation frame
  let rafPending = false;
  new MutationObserver(() => {
    if (!rafPending) {
      rafPending = true;
      requestAnimationFrame(() => {
        hideReelArticles();
        rafPending = false;
      });
    }
  }).observe(document.documentElement, { childList: true, subtree: true });

  // Re-scan on client-side navigation
  const _push = history.pushState.bind(history);
  history.pushState = function (...a) { _push(...a); setTimeout(hideReelArticles, 300); };
  window.addEventListener('popstate', () => setTimeout(hideReelArticles, 300));

})();
