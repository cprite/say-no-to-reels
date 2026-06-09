# Contributing

Thanks for your interest in improving Noreelsgram! It's a small, focused project, so contributing is easy.

## Project layout

```
SayNoToReels.xcodeproj/      ← open this in Xcode
SayNoToReels/
├── SayNoToReelsApp.swift    ← @main entry point + the hosting UIViewController
├── WebViewModel.swift       ← WKWebView config + Reels navigation blocking
├── InstagramBlocker.js      ← injected stylesheet that hides the Reels nav button
├── Info.plist
└── Assets.xcassets/         ← app icon + accent color
```

## How the Reels block works

Reels are blocked in two cheap layers:

1. **Navigation policy** — `WebViewModel`'s `decidePolicyFor` cancels any navigation
   whose path starts with `/reels` or `/reel/`. This is the hard guarantee: the Reels
   player never opens, even if a reel link is tapped.
2. **Static CSS** — `InstagramBlocker.js` is injected at `documentStart` and adds one
   stylesheet that hides the Reels button in the nav. It intentionally does **no** DOM
   scanning, has **no** `MutationObserver`, and uses **no** `:has()` selectors — an
   earlier version did, and it made the feed crawl by inspecting every post. CSS is
   reactive, so the rule keeps applying as Instagram re-renders the nav, for free.

Scope is deliberate: we remove the Reels *destination* (the nav button + the `/reels`
player), not individual reels inside the home feed. Filtering feed items reliably means
scanning every post, which is exactly the performance trap we're avoiding.

## When Instagram changes its markup

Instagram ships frequent web changes, so the Reels button may reappear. The fix is
almost always a one-line selector update in **`InstagramBlocker.js`** to match the new
nav markup. Keep selectors specific so you don't accidentally hide legitimate content,
and keep the script free of per-post scanning — performance is a feature here.

## Submitting changes

1. Fork and create a branch.
2. Make your change. Build and run on a real device or the simulator to confirm it works.
3. Open a PR describing what you changed and how you tested it. Before/after screenshots
   are very welcome for anything visual.

## Scope

This project intentionally stays minimal: an Instagram web shell with Reels removed.
Features that pull it toward being a full Instagram client are probably out of scope —
open an issue to discuss before building something large.
