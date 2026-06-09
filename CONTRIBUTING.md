# Contributing

Thanks for your interest in improving Noreelsgram! It's a small, focused project, so contributing is easy.

## Project layout

```
SayNoToReels.xcodeproj/      ← open this in Xcode
SayNoToReels/
├── SayNoToReelsApp.swift    ← @main entry point + the hosting UIViewController
├── WebViewModel.swift       ← WKWebView config + Reels navigation blocking
├── InstagramBlocker.js      ← injected script that hides Reels/ads in the DOM
├── Info.plist
└── Assets.xcassets/         ← app icon + accent color
```

## How the Reels block works

Reels are blocked in two complementary layers:

1. **Navigation policy** — `WebViewModel`'s `decidePolicyFor` cancels any navigation
   whose path starts with `/reels` or `/reel/`. This is the hard guarantee: a Reel
   can't open even if its entry point slips past the cosmetic filter.
2. **DOM hiding** — `InstagramBlocker.js` is injected at `documentStart` and hides
   reel tiles, the Reels nav tab, suggested posts, and ads using CSS plus a debounced
   `MutationObserver` that re-scans on Instagram's client-side navigations.

## When Instagram changes its markup

Instagram ships frequent web changes, so Reels or ads may start leaking through. The
fix is almost always in **`InstagramBlocker.js`** — update the CSS selectors or the
`hideReelArticles()` logic to match the new DOM. Keep selectors as specific as
possible to avoid hiding legitimate posts.

## Submitting changes

1. Fork and create a branch.
2. Make your change. Build and run on a real device or the simulator to confirm it works.
3. Open a PR describing what you changed and how you tested it. Before/after screenshots
   are very welcome for anything visual.

## Scope

This project intentionally stays minimal: an Instagram web shell with Reels removed.
Features that pull it toward being a full Instagram client are probably out of scope —
open an issue to discuss before building something large.
