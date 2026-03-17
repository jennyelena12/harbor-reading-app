# 🚀 HARBOR - START HERE

## You Have Two Options to Get Started

### ✅ Option 1: Automated Setup (2 Minutes) - **RECOMMENDED**

Perfect if you have Homebrew installed on Mac:

```bash
# 1. Open Terminal
# 2. Navigate to Harbor folder:
cd path/to/Harbor

# 3. Run the setup script:
bash setup.sh

# 4. Script will:
#    - Check for XcodeGen (install if needed via Homebrew)
#    - Generate Harbor.xcodeproj automatically
#    - Show you next steps

# 5. Open the project:
open Harbor.xcodeproj
```

**That's it!** Xcode opens with a fully configured project ready to run.

---

### ✅ Option 2: Manual Setup in Xcode (5 Minutes)

If you don't have Homebrew or prefer doing it manually:

#### 2a. Create New Xcode Project

```
1. Open Xcode
2. File → New → Project
3. Choose: iOS → App
4. Fill in:
   - Product Name: Harbor
   - Organization Identifier: com.yourname
   - Interface: SwiftUI
5. Click Create
6. Choose a location to save
```

#### 2b. Delete Default Files

In Xcode's left sidebar:
- Right-click `ContentView.swift` → Delete → Remove Reference

#### 2c. Create Folder Structure

Right-click "Harbor" project → New Group:
- `Constants`
- `Models`
- `Managers`
- `Views`
- `Components`

#### 2d. Add All Swift Files

For **each file** in the Harbor folder:

1. Right-click the appropriate folder in Xcode
2. Select **"Add Files to Harbor..."**
3. Navigate to the downloaded Harbor source folder
4. Select the file → Click **Add**
5. **✓ CHECK**: "Copy items if needed" is checked
6. **✓ CHECK**: "Harbor" target is selected

**Files to add (in this order):**

```
Constants/
  └── Colors.swift

Models/
  └── Book.swift

Managers/
  ├── BookManager.swift
  ├── AmbientLightManager.swift
  ├── SpeechManager.swift
  └── FavoritesManager.swift

Components/
  ├── WaveAnimation.swift
  └── AnimationModifiers.swift

Views/
  ├── HomeView.swift
  ├── ReadingView.swift
  ├── FavoriteCaptureView.swift
  └── ChapterSelectorView.swift

Harbor/ (root)
  └── HarborApp.swift
```

#### 2e. Add Permissions

1. In Xcode, select project → **Harbor** target → **Info** tab
2. Click the **+ button** to add 3 keys:

```
NSMicrophoneUsageDescription
  → "Harbor needs microphone access for voice commands"

NSMotionUsageDescription
  → "Harbor uses motion sensors to adapt reading brightness"

NSCameraUsageDescription
  → "Harbor uses camera to detect ambient light"
```

#### 2f. Enable Capabilities

1. Select **Harbor** target → **Signing & Capabilities** tab
2. Click **+ Capability**
3. Add:
   - **Microphone**
   - **Camera**

#### 2g. Set iOS Version

1. Select **Harbor** target → **General** tab
2. Under **Minimum Deployments**: Set to **iOS 17.0**

#### 2h. Build & Run

1. Select **iPhone 17** simulator
2. Press **Cmd+R** or click ▶ Run button

✅ **Harbor launches!**

---

## Troubleshooting

### "XcodeGen not found" (Option 1)

**Solution**: Install Homebrew first:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then run `bash setup.sh` again.

---

### "Cannot find 'Book' in scope" (Option 2)

**Solution**: 
1. Click `Book.swift` in Xcode
2. In right panel (File Inspector), check **Target Membership**
3. Ensure ✓ **Harbor** is checked

---

### "No microphone/camera permissions on simulator"

**Solution**:
1. iPhone simulator → Settings app
2. Privacy → Microphone → Harbor: **Allow**
3. Privacy → Camera → Harbor: **Allow**
4. Privacy → Motion & Fitness → Harbor: **Allow**

---

### "Voice commands not working"

**Solution**:
1. Grant microphone permission (above)
2. Simulator may need internet for better speech recognition
3. Try speaking slowly and clearly
4. Keywords: "next page", "previous page", "chapter 2"
5. **Better on real device** - simulator has limitations

---

### "Brightness not adapting"

**Solution**:
1. Grant camera permission (see above)
2. On simulator, uses screen brightness + heuristics
3. **Much better on real device** - has actual ambient light sensor
4. Try in a dark room to see the effect

---

## What You Get

✅ **3 Pre-loaded Books** with sample content
✅ **Ocean-Themed UI** with animated waves  
✅ **Reading Screen** with smooth page transitions
✅ **Tap Navigation** - left/right edges for pages
✅ **Voice Commands** - "next page", "chapter 3", etc.
✅ **Adaptive Brightness** - auto-adjusts to light/dark
✅ **Favorite Quotes** - capture and save sentences
✅ **Haptic Feedback** - vibrations on interactions
✅ **Dark Mode** - automatic theme switching
✅ **Smooth Animations** - 0.3s transitions

---

## Quick Features Demo

| Feature | How to Use |
|---------|-----------|
| **Start Reading** | Tap any book on home screen |
| **Next Page** | Tap right edge of screen |
| **Previous Page** | Tap left edge of screen |
| **Voice Command** | Tap 🎤 button, say "Next page" |
| **Jump to Chapter** | Tap book icon, select chapter |
| **Save Quote** | Long-press text or tap ❤️ icon |
| **View Favorites** | Tap "Favorites" from menu |
| **Auto Dark Mode** | App darkens in low light |

---

## Project Structure

```
Harbor/
├── HarborApp.swift                      [App entry point]
├── Models/Book.swift                    [Books + sample data]
├── Managers/
│   ├── BookManager.swift                [Book logic]
│   ├── AmbientLightManager.swift        [Brightness sensor]
│   ├── SpeechManager.swift              [Voice recognition]
│   └── FavoritesManager.swift           [Save quotes]
├── Views/
│   ├── HomeView.swift                   [Library + waves]
│   ├── ReadingView.swift                [Main reading]
│   ├── FavoriteCaptureView.swift        [Save quotes modal]
│   └── ChapterSelectorView.swift        [Jump chapters]
├── Components/
│   ├── WaveAnimation.swift              [Ocean visualization]
│   └── AnimationModifiers.swift         [Animations + haptics]
├── Constants/Colors.swift               [Color palette]
├── Info.plist                           [Permissions]
└── Documentation/
    ├── QUICK_START.md                   [5-min summary]
    ├── XCODE_SETUP.md                   [Detailed Xcode steps]
    ├── FILE_MANIFEST.md                 [File reference]
    └── IMPLEMENTATION_NOTES.md          [Technical deep dive]
```

---

## Sensor Capabilities Explained

### 🎨 **Adaptive Brightness**
- Uses device camera to detect ambient light
- Automatically darkens in low-light environments
- Manual brightness slider for fine-tuning
- Smooth 0.3-second transitions between brightness levels

### 🎤 **Voice Navigation**
- Recognizes natural speech commands
- Keywords: "next", "previous", "back", "forward", "go to chapter X"
- Real-time feedback shows recognized text
- Haptic vibration confirms voice input

### 📍 **Motion & Accelerometer**
- Detects device orientation for reading posture
- Enhances light detection algorithms
- Triggers haptic feedback based on movement
- All data processed locally (privacy-first)

### 💾 **Persistent Storage**
- Favorite sentences saved to device
- Reading progress tracked locally
- No cloud sync needed (but easily added)
- Data persists across app sessions

---

## Keyboard Shortcuts in Xcode

| Shortcut | Action |
|----------|--------|
| **Cmd+R** | Build and Run |
| **Cmd+B** | Just Build |
| **Cmd+K** | Clear Build Folder |
| **Cmd+.** | Stop Running App |
| **Cmd+Shift+K** | Clean Build Folder |

---

## Next Steps After Launch

1. ✅ **Verify everything works** - tap through the app
2. 📚 **Add your own books** - edit `Book.swift` sample data
3. 🎨 **Customize colors** - modify `Colors.swift` palette
4. 🎤 **Test voice commands** - say "next page"
5. 💡 **Test brightness** - use in different light

---

## Need Help?

**Quick Issues:**
- See "Troubleshooting" section above

**Feature Details:**
- Read `README.md` for full feature list

**Technical Details:**
- Read `IMPLEMENTATION_NOTES.md` for code explanation

**Setup Problems:**
- Read `XCODE_SETUP.md` for detailed step-by-step

**File Reference:**
- Read `FILE_MANIFEST.md` to understand project structure

---

## You're Ready! 🎉

Choose your setup option above and get started.

Harbor is fully functional with zero external dependencies - just pure SwiftUI and Foundation.

**Happy reading!** ⛵📖

