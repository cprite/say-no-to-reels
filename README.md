# Noreelsgram

Instagram without Reels. A simple iOS app that opens Instagram's website with Reels blocked — so you only see posts, stories, and DMs.

> Free to use for personal use. Not on the App Store.

---

## What it does

- ✅ Shows your Instagram feed (posts, stories, DMs)
- ❌ Blocks Reels completely — in the feed, in the nav bar, everywhere
- ❌ Blocks Suggested Posts
- ❌ Blocks Sponsored posts (ads)
- 🔒 Keeps you logged in between sessions

---

## How it works

It's a thin native shell around Instagram's mobile website (`WKWebView`). Reels are blocked in two layers:

1. **Navigation policy** (`WebViewModel.swift`) — hard-cancels any navigation to `/reels` or `/reel/...`, so a Reel can't open even if you tap one.
2. **DOM hiding** (`InstagramBlocker.js`) — injected at page load to hide reel tiles, the Reels nav tab, suggested posts, and ads from the feed.

> Instagram changes its markup often. If Reels start leaking through, the CSS selectors in `InstagramBlocker.js` are the place to update — PRs welcome.

---

## What you need

- A **Mac** with at least **20 GB of free space** (Xcode + iOS tools take ~18 GB)
- An **iPhone** + a **USB cable**
- A **free Apple ID** (the one you already use for the App Store)
- **Xcode** — free, download from the Mac App Store

---

## Installation guide

### Step 1 — Download the code

Click the green **Code** button at the top of this page → **Download ZIP**.

Once downloaded, double-click the ZIP to unzip it. You'll get a folder called `say-no-to-reels-main`.

> Prefer git? `git clone https://github.com/cprite/say-no-to-reels.git`

---

### Step 2 — Install Xcode

Open the **App Store** on your Mac, search for **Xcode**, and install it.

> It's about 10 GB — start the download and come back in a bit.

---

### Step 3 — Open the project

Inside the folder, double-click **`SayNoToReels.xcodeproj`**. Xcode opens with everything already set up — no need to create a project or add files by hand.

---

### Step 4 — Sign in with your Apple ID

1. In the menu bar: **Xcode → Settings → Accounts**
2. Click **+** in the bottom-left corner → choose **Apple ID** → sign in

---

### Step 5 — Set your signing team

1. In the left sidebar, click the blue **SayNoToReels** project icon at the very top
2. Under **TARGETS**, click **SayNoToReels**
3. Go to the **Signing & Capabilities** tab
4. Under **Team**, select your name — it will say something like "Your Name (Personal Team)"

> **If signing fails with "bundle identifier is not available":** change the **Bundle Identifier** field (just above Team) to something unique, e.g. `com.yourname.SayNoToReels`.

---

### Step 6 — Connect your iPhone

Plug your iPhone into your Mac with a USB cable.

When a popup appears on your iPhone asking **"Trust This Computer?"**, tap **Trust**.

---

### Step 7 — Enable Developer Mode on your iPhone

This is a one-time step required to install apps outside the App Store.

1. On your iPhone: **Settings → Privacy & Security → Developer Mode**
2. Toggle it **ON**
3. Tap **Restart**, then tap **Turn On** after your phone reboots

---

### Step 8 — Run the app

1. In Xcode, click the device name at the top of the window (it might say "iPhone" or "My Mac")
2. Select your iPhone from the list
3. Press the **▶ Play button** (or `Cmd + R`)

Xcode will build and install the app on your phone. The first time takes a couple of minutes.

---

### Step 9 — Trust the app on your iPhone

iOS will block the app the first time you open it. To fix this:

1. **Settings → General → VPN & Device Management**
2. Tap your Apple ID email
3. Tap **Trust**

Open **Noreelsgram** from your home screen — you're done! 🎉

---

## ⚠️ The 7-day limit

With a free Apple ID, the app expires every **7 days**. To renew it:

1. Plug your iPhone into your Mac
2. Open Xcode and press **▶ Run** again

That's it — takes about 30 seconds.

---

## Troubleshooting

**"Untrusted Developer" error when opening the app**
→ Go to **Settings → General → VPN & Device Management** → tap your Apple ID → tap **Trust**

**Reels are still showing**
→ Pull down to refresh, or tap the **↻ button** in the bottom-right corner of the app

**Can't see your iPhone in Xcode**
→ Make sure you tapped **Trust This Computer** on your iPhone, and that Developer Mode is turned on

**Build failed in Xcode**
→ Make sure your signing team is set (Step 5). If you see "bundle identifier is not available," change the Bundle Identifier to something unique like `com.yourname.SayNoToReels`.

---

## Contributing

Instagram changes its website often, so the Reels/ad filters need occasional updates — that's the most useful place to help. See [CONTRIBUTING.md](CONTRIBUTING.md) for the project layout and how the blocking works.

---

## Disclaimer

This is an unofficial, personal-use project and is not affiliated with or endorsed by Instagram or Meta. It loads Instagram's own website and hides Reels client-side; automating or modifying Instagram's web client may be against their Terms of Service. Use at your own risk. Licensed under [MIT](LICENSE).
