# Harbor App - Super Simple Guide for Beginners

**Read this if you just want to get the app running without understanding code!**

---

## What You Need
- Mac with Xcode installed
- GitHub account (you have one!)
- 10 minutes

---

## Step 1: Download the App Files

1. Go to: https://github.com/jennyelena12/harbor-reading-app
2. Look for the green **CODE** button (top right area)
3. Click it → Click **Download ZIP**
4. A file called `harbor-reading-app-main.zip` downloads
5. **Double-click** the ZIP file to unzip it
6. You now have a folder called `harbor-reading-app-main`

**Stop here.** Keep this folder open in Finder.

---

## Step 2: Create an Empty Xcode Project

This is your container that will hold all the app code.

1. **Open Xcode** (find it in Applications folder)
2. Click **File** (top menu)
3. Click **New**
4. Click **Project**

A window appears. Look for a big list of options.

5. Find and click **App** (under iOS section)
6. Click **Next**

A form appears:

| Field | What to Type |
|-------|--------------|
| Product Name | `Harbor` |
| Organization Identifier | `com.yourname` |
| Interface | Select **SwiftUI** from dropdown |
| Language | Select **Swift** from dropdown |

7. Click **Next**
8. Click **Create**
9. **IMPORTANT:** When it asks "Where do you want to save?", navigate to your `harbor-reading-app-main` folder and save it there
10. Xcode opens with an empty project

**You now have a blank Xcode project!**

---

## Step 3: Copy the App Code (The Important Part!)

This is where all the magic goes.

### In Finder (the file manager):
- Open your `harbor-reading-app-main` folder
- You should see several folders: `Models`, `Managers`, `Views`, `Components`, `Constants`
- You should also see a file called `HarborApp.swift`

### In Xcode (on the left side):
- You should see a file navigator (left panel)
- Look for a folder icon labeled **Harbor**

### Now drag and drop:

**Do this 5 times** (once for each folder):

1. **In Finder:** Click and hold on the `Models` folder
2. Drag it to Xcode (left side panel, under the **Harbor** folder)
3. Release it
4. A popup appears with options:
   - ☑️ Check the box: **"Copy items if needed"**
   - ☑️ Check the box: **"Create groups"**
   - Make sure **Harbor** is selected at the bottom
   - Click **Finish**

Repeat this for:
- `Managers` folder
- `Views` folder
- `Components` folder
- `Constants` folder

Finally, drag `HarborApp.swift` the same way.

**After all 5 drags, you should see in Xcode's left panel:**

```
Harbor
├── Models
├── Managers
├── Views
├── Components
├── Constants
└── HarborApp.swift
```

**This is correct!** ✅

---

## Step 4: Add 3 Permission Lines (Copy-Paste This!)

Your app needs permission to use the phone's microphone and camera.

1. In Xcode, click on the **Harbor** project (top of left panel)
2. Click the **Info** tab
3. Right-click in the empty area below existing items
4. Click **Add Row**

Do this **3 times**, copy-pasting these exact lines:

### First Permission:
- Left column: `NSMicrophoneUsageDescription`
- Right column: `Harbor needs microphone access for voice commands`

### Second Permission:
- Left column: `NSMotionUsageDescription`
- Right column: `Harbor uses motion sensors for adaptive brightness`

### Third Permission:
- Left column: `NSCameraUsageDescription`
- Right column: `Harbor uses camera to detect ambient light`

---

## Step 5: Run the App!

1. At the very top of Xcode, look for a **dropdown** that says something like "iPhone 15 Pro"
2. Click it
3. Select **iPhone 17** (or iPhone 17 Pro)
4. Look for the **▶️ Play button** (top left area)
5. Click it!

**The app builds and opens in the simulator!**

---

## What You're Looking At

### Home Screen
- You see book covers
- Click a book to start reading

### Reading Screen
- Text of the book
- **Left edge:** Tap to go to previous page
- **Right edge:** Tap to go to next page
- **Microphone icon:** Tap and say "next page" or "previous page"
- **Heart icon:** Click to save favorite quotes

### That's it!

---

## Troubleshooting

**"I don't see the ▶️ Play button"**
- Make sure you selected a device (iPhone 17)
- The button should appear at top left

**"Drag and drop isn't working"**
- Make sure you're dragging TO the left panel in Xcode (not the center)
- Make sure "Create groups" is checked

**"The app won't build"**
- Make sure you added all 3 permissions in Step 4
- Make sure all files are under the Harbor folder

---

## Need Help?

Check that you have:
- ✅ Downloaded the ZIP file
- ✅ Created a new Xcode project called Harbor
- ✅ Dragged all 5 folders + HarborApp.swift into Xcode
- ✅ Added 3 permission lines
- ✅ Selected iPhone 17 simulator
- ✅ Clicked the Play button

If something is wrong, screenshot it and we can fix it!
