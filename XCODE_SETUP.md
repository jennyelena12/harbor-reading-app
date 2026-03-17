# Harbor - Xcode Project Setup (5 Minutes)

## What You Need
- Xcode 15.0+ (with iPhone 17 simulator or device)
- macOS 14+
- This Harbor project source code

## Option 1: Create Xcode Project & Add Files (Recommended)

### Step 1: Create New Xcode Project
1. Open **Xcode**
2. Click **File → New → Project**
3. Choose **iOS → App**
4. Fill in:
   - **Product Name**: `Harbor`
   - **Team ID**: Your team (or None)
   - **Organization Identifier**: `com.yourname`
   - **Interface**: SwiftUI
   - **Language**: Swift
5. Choose a location to save (e.g., Desktop)
6. Click **Create**

### Step 2: Create Folder Structure in Xcode
In Xcode's project navigator (left sidebar):

1. Delete the default `ContentView.swift` file (right-click → Delete → Remove Reference)
2. Create folders by right-clicking on "Harbor" → New Group:
   - `Models`
   - `Managers`
   - `Views`
   - `Components`
   - `Constants`

### Step 3: Add Swift Files
For each `.swift` file from this project:

1. **Right-click** the appropriate folder in Xcode
2. Select **Add Files to "Harbor"...**
3. Navigate to the downloaded Harbor source files
4. Select the file → **Add**
5. ✅ Ensure **"Copy items if needed"** is checked
6. ✅ Ensure the **"Harbor" target** is selected

**Add files in this order:**

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

Root/
  └── HarborApp.swift (add to top level)
```

### Step 4: Update Info.plist
1. In Xcode, click the project → **Harbor** target → **Info** tab
2. Click the **+ button** to add keys:

**Add these 3 keys:**
```
NSMicrophoneUsageDescription: "Harbor needs access to your microphone for voice commands"
NSMotionUsageDescription: "Harbor uses motion sensors to adapt reading brightness"
NSCameraUsageDescription: "Harbor uses camera to detect ambient light"
```

(Or replace entire Info.plist with the provided Info.plist file)

### Step 5: Enable Capabilities
1. Select project → **Harbor** target
2. Go to **Signing & Capabilities** tab
3. Click **+ Capability**
4. Add:
   - **Microphone**
   - **Camera**

### Step 6: Set Deployment Target
1. Select project → **Harbor** target
2. Go to **General** tab
3. Under **Minimum Deployments**, set to **iOS 17.0**

### Step 7: Build & Run
1. Select **iPhone 17** simulator (or your device)
2. Press **Cmd+R** or click ▶ Run button
3. ✅ Harbor app launches!

---

## Option 2: Clone & Open in Xcode (Advanced)

If you downloaded this as a git repository:

```bash
cd path/to/Harbor
open -a Xcode .
```

Then follow Steps 2-7 above.

---

## Troubleshooting

### "Cannot find 'Book' in scope"
**Solution**: Ensure `Book.swift` was added to the target
- Click file → File Inspector (right panel)
- Check **Target Membership**: "Harbor" is selected

### "No microphone permission popup"
**Solution**: 
- Open iPhone simulator Settings → Privacy → Microphone → Harbor: **Allow**
- Same for Camera and Motion

### "Ambient light not working"
**Solution**: This uses `UIScreen.main.brightness` and device motion
- Works on real devices (simulator has limits)
- Check Settings → Accessibility → Display & Text Size → Auto-Brightness is ON

### "Voice commands not recognized"
**Solution**:
- Device needs microphone access (granted above)
- Speak clearly with good audio
- Try keywords: "next page", "chapter 2", "previous"
- Enable simulators: Settings → Accessibility → Speech Recognition Language

---

## Features to Test

1. **Home Screen**: Tap any book to start reading
2. **Tap Navigation**: Tap left edge (previous), right edge (next page)
3. **Voice Commands**: Tap 🎤 button → say "Next page"
4. **Brightness Adaptation**: App darkens in low light (best on device)
5. **Favorite Sentence**: Long-press text → "Capture" → view in Favorites
6. **Chapter Jump**: Tap chapter icon → select chapter
7. **Haptic Feedback**: Feel subtle vibrations on interactions

---

## What's Included

- **11 Swift files** (~1,362 lines production code)
- **3 sample books** with multiple chapters
- **Zero external dependencies** (100% SwiftUI + Foundation)
- **Full sensor integration**: Camera, Microphone, Motion, Accelerometer
- **Dark mode support** with adaptive brightness
- **Smooth animations** and haptic feedback
- **Voice navigation** with natural language processing

Ready to read? 📖⛵

