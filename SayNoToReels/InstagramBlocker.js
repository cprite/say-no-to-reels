// ============================================================
// InstagramBlocker.js
// Injected at document start. Hides the Reels button from
// Instagram's navigation with a single static stylesheet.
//
// Deliberately lightweight: no DOM scanning, no MutationObserver,
// no :has() selectors — so the feed scrolls at full speed. CSS is
// reactive, so the rule keeps applying as Instagram re-renders the
// nav during client-side navigation, with zero ongoing JS cost.
//
// Opening a Reel by URL is blocked separately (and for free) by the
// navigation policy in WebViewModel.swift.
// ============================================================

(function () {
  'use strict';

  if (document.getElementById('sntr-style')) return;

  const style = document.createElement('style');
  style.id = 'sntr-style';
  style.textContent = `
    a[href="/reels/"],
    [aria-label="Reels"] { display: none !important; }
  `;
  (document.head || document.documentElement).appendChild(style);
})();
