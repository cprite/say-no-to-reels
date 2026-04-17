# Noreelsgram

Instagram without Reels. A simple iOS app that opens Instagram's website with Reels blocked — so you only see posts, stories, and DMs.

> Free to use for personal use. Not on the App Store.

---

## What it does

- ✅ Shows your Instagram feed (posts, stories, DMs)
- ❌ Blocks Reels completely — in the feed, in the nav bar, everywhere
- ❌ Blocks Suggested Posts
- 🔒 Keeps you logged in between sessions

---

## Requirements

- A **Mac** with **Xcode** installed (free on the App Store)
- An **iPhone** with a USB cable
- A **free Apple ID** (the one you use for the App Store)

---

## Step-by-step setup

### Step 1 — Download the code

Click the green **Code** button on this page → **Download ZIP**, then unzip it.

Or if you have Git:
```
git clone https://github.com/YOUR_USERNAME/noreelsgram.git
```

---

### Step 2 — Install Xcode

Open the **App Store** on your Mac, search for **Xcode**, and install it. It's free but large (~10 GB), so give it some time.

---

### Step 3 — Open the project

Inside the downloaded folder, open:
```
SayNoToReels/SayNoToReels.xcodeproj
```
Double-click it — it will open in Xcode.

---

### Step 4 — Sign in with your Apple ID

1. In the menu bar: **Xcode → Settings → Accounts**
2. Click **+** in the bottom left → **Apple ID** → sign in with your Apple ID

---

### Step 5 — Set your signing team

1. In the left sidebar, click **SayNoToReels** (the blue icon at the top)
2. Under **TARGETS**, click **SayNoToReels**
3. Go to the **Signing & Capabilities** tab
4. Under **Team**, select your name (it will say "Personal Team")

---

### Step 6 — Connect your iPhone

Plug your iPhone into your Mac with a USB cable.

When prompted on your iPhone, tap **Trust This Computer**.

---

### Step 7 — Enable Developer Mode on your iPhone

This is required for installing apps outside the App Store.

1. On your iPhone: **Settings → Privacy & Security → Developer Mode**
2. Toggle it **ON**
3. Tap **Restart**, then **Turn On** after reboot

---

### Step 8 — Run the app

1. In Xcode, click the device selector at the top (it may say "iPhone" or a simulator name)
2. Select your iPhone from the list
3. Press the **▶ Play button** (or `Cmd + R`)
4. Xcode will build and install the app on your phone

> First time may take a few minutes to compile.

---

### Step 9 — Trust the developer certificate on your iPhone

After the app installs, iOS will block it until you trust it:

1. **Settings → General → VPN & Device Management**
2. Tap your Apple ID email
3. Tap **Trust**

Now open **Noreelsgram** from your home screen — done! 🎉

---

## ⚠️ The 7-day limit

With a free Apple ID, the app expires every **7 days**. To renew it:

1. Plug your iPhone back into your Mac
2. Open Xcode and press **▶ Run** again

That's it — takes about 30 seconds.

**Want to avoid this?** Use [AltStore](https://altstore.io) — it auto-renews the app in the background for free.

---

## How it works (technical)

| Component | Role |
|---|---|
| `WKWebView` | Loads `instagram.com` in a full-screen web view |
| `InstagramBlocker.js` | Injected at page load — hides Reels via CSS and DOM manipulation |
| `WKNavigationDelegate` | Blocks navigation to `/reels/` URLs at the network level |
| `WKWebsiteDataStore.default()` | Keeps your login session saved between app launches |

---

## Troubleshooting

**"Untrusted Developer" error on iPhone**
→ Go to Settings → General → VPN & Device Management → trust your Apple ID

**Reels still showing**
→ Pull down to refresh or tap the ↻ button in the bottom-right corner

**Build errors in Xcode**
→ Make sure you selected your iPhone under TARGETS (not PROJECT) when setting the Team

---

## Blocked content

| Content | Blocked by |
|---|---|
| Reels tab in bottom nav | CSS `display:none` |
| Reel posts in home feed | CSS `:has(a[href*="/reel/"])` + MutationObserver |
| Suggested Posts section | CSS + JS DOM walk |
| Direct `/reels/` URL navigation | `WKNavigationDelegate` policy cancel |

### Optional blocks (uncomment in `InstagramBlocker.js` / `WebViewModel.swift`)

- Explore / Search tab
- Stories strip

---

## Updating the blocker

Instagram's HTML structure changes frequently. If something breaks:

1. Open `InstagramBlocker.js`.
2. Use Safari's Web Inspector (connect iPhone → Safari → Develop menu) to
   inspect the live DOM and find the new class names / aria-labels.
3. Update the CSS selectors and save — no Xcode rebuild needed if you're
   loading the file from the bundle at runtime (current setup).

---

## Limitations

- Instagram's mobile web occasionally prompts "Open in App" banners —
  the JS blocker dismisses most of them, but you may need to tap "Not now".
- Push notifications are **not** supported (web push on iOS requires explicit
  user permission and a service worker; Instagram's PWA does support it but
  you'll need to allow it in Settings).
- This is a web wrapper, not a native client. Performance is slightly lower
  than the official app.
