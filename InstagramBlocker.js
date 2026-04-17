// ============================================================
// InstagramBlocker.js
// Injected into every page load via WKUserScript.
// Hides: Reels tab, Reels feed rows, Suggested Posts.
// Removes: Safari browser-chrome padding Instagram injects.
// ============================================================

(function () {
  'use strict';

  const CSS = `
    /* ── Reels nav tab ── */
    a[href="/reels/"],
    a[href*="/reels"],
    [aria-label="Reels"],
    svg[aria-label="Reels"] { display: none !important; }

    /* ── Reels in feed ── */
    article:has(svg[aria-label="Reel"]),
    article:has(a[href*="/reel/"]),
    div:has(> a[href*="/reel/"]) { display: none !important; }

    /* ── Suggested Posts ── */
    [data-testid="suggested-posts-header"],
    div[class*="SuggestedPosts"],
    article:has(span:is([class*="suggested"], [class*="Suggested"])) {
      display: none !important;
    }
  `;

  function injectCSS() {
    if (document.getElementById('sntr-style')) return;
    const s = document.createElement('style');
    s.id = 'sntr-style';
    s.textContent = CSS;
    (document.head || document.documentElement).appendChild(s);
  }

  function hideReels() {
    document.querySelectorAll('a[href*="/reel/"]').forEach(a => {
      const c = a.closest('article') || a.closest('li') || a.parentElement;
      if (c) c.style.display = 'none';
    });
    document.querySelectorAll('svg[aria-label="Reel"]').forEach(svg => {
      const c = svg.closest('article') || svg.closest('li') || svg.parentElement;
      if (c) c.style.display = 'none';
    });
    document.querySelectorAll('[data-testid="suggested-posts-header"]').forEach(el => {
      let node = el.closest('article') || el.parentElement;
      while (node) { node.style.display = 'none'; node = node.nextElementSibling; }
    });
  }

  // Strip only the bottom padding (tab bar chrome).
  // Keep top padding so Instagram's header stays below the status bar.
  function stripSafariPadding() {
    document.querySelectorAll('[style]').forEach(el => {
      const pb = parseFloat(el.style.paddingBottom);
      if (pb >= 30 && pb <= 100) el.style.paddingBottom = '0px';
    });
  }

  injectCSS();
  hideReels();
  [100, 300, 600, 1000, 1500, 2500, 4000].forEach(t => setTimeout(stripSafariPadding, t));

  const observer = new MutationObserver(() => {
    injectCSS();
    hideReels();
    stripSafariPadding();
  });
  observer.observe(document.documentElement, { childList: true, subtree: true });

  const _push = history.pushState.bind(history);
  history.pushState = function (...a) { _push(...a); setTimeout(hideReels, 300); };
  window.addEventListener('popstate', () => setTimeout(hideReels, 300));

})();
