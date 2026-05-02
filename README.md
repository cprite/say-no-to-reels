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

---

### Step 2 — Install Xcode

Open the **App Store** on your Mac, search for **Xcode**, and install it.

> It's about 10 GB — start the download and come back in a bit.

---

### Step 3 — Create a new Xcode project

1. Open **Xcode**
2. Click **Create New Project**
3. Select **iOS → App** and click **Next**
4. Fill in the fields:
   - **Product Name**: `SayNoToReels`
   - **Interface**: `SwiftUI`
   - **Language**: `Swift`
5. Click **Next**, choose where to save it (e.g. your Desktop), and click **Create**

---

### Step 4 — Add the app files

1. In the left sidebar of Xcode, **right-click** the yellow `SayNoToReels` folder
2. Select **"Add Files to 'SayNoToReels'..."**
3. Navigate to the `say-no-to-reels-main` folder you downloaded
4. Select all these files:
   - `ContentView.swift`
   - `SayNoToReelsApp.swift`
   - `WebViewModel.swift`
   - `WebViewRepresentable.swift`
   - `InstagramBlocker.js`
5. Make sure **"Copy items if needed"** is checked
6. Click **Add**

> If Xcode asks about replacing existing files, click **Replace**.

---

### Step 4b — Add the app icon (optional)

1. In the left sidebar, click **Assets.xcassets**
2. Click **AppIcon** in the middle panel
3. Drag the app icon image from the `say-no-to-reels-main` folder into the icon slots

> If you don't have an icon, you can skip this — the app will use a default icon.

---

### Step 5 — Sign in with your Apple ID

1. In the menu bar: **Xcode → Settings → Accounts**
2. Click **+** in the bottom-left corner → choose **Apple ID** → sign in

---

### Step 6 — Set your signing team

1. In the left sidebar, click **SayNoToReels** (the icon at the very top of the list)
2. Under **TARGETS**, click **SayNoToReels**
3. Go to the **Signing & Capabilities** tab
4. Under **Team**, select your name — it will say something like "Your Name (Personal Team)"

---

### Step 7 — Connect your iPhone

Plug your iPhone into your Mac with a USB cable.

When a popup appears on your iPhone asking **"Trust This Computer?"**, tap **Trust**.

---

### Step 8 — Enable Developer Mode on your iPhone

This is a one-time step required to install apps outside the App Store.

1. On your iPhone: **Settings → Privacy & Security → Developer Mode**
2. Toggle it **ON**
3. Tap **Restart**, then tap **Turn On** after your phone reboots

---

### Step 9 — Run the app

1. In Xcode, click the device name at the top of the window (it might say "iPhone" or "My Mac")
2. Select your iPhone from the list
3. Press the **▶ Play button** (or `Cmd + R`)

Xcode will build and install the app on your phone. The first time takes a couple of minutes.

---

### Step 10 — Trust the app on your iPhone

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
→ Make sure all 5 files were added in Step 4, and that your signing team is set in Step 6
