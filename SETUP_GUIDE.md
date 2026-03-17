# Harbor iOS App - Complete Setup Guide

## Prerequisites

- **Xcode 15.0+** (download from App Store)
- **macOS 13+**
- **iOS 17.0+** simulator or device (iPhone 14+)
- **5-10 minutes** of setup time

## Step 1: Create Xcode Project

1. Open Xcode
2. Click **File → New → Project** (or Cmd+Shift+N)
3. Select **iOS** → **App**
4. Fill in the form:
   - **Product Name**: Harbor
   - **Organization Identifier**: com.yourname (or your domain)
   - **Interface**: SwiftUI
   - **Language**: Swift
5. Choose location to save
6. Click **Create**

## Step 2: Set Deployment Target

1. Select **Harbor** project in left navigator
2. Select **Harbor** target
3. Go to **Build Settings** tab
4. Search for "Minimum Deployments"
5. Set iOS minimum to **17.0**

## Step 3: Configure Info.plist

1. In Xcode, find **Info.plist** in left navigator
2. Right-click → **Open As** → **Source Code**
3. Find the closing `</dict>` tag (near the end)
4. Add these 3 keys before `</dict>`:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>Harbor needs microphone access for voice commands</string>
<key>NSMotionUsageDescription</key>
<string>Harbor uses motion sensors to adapt reading brightness</string>
<key>NSCameraUsageDescription</key>
<string>Harbor uses camera to detect ambient light for brightness</string>
```

5. File → Save (Cmd+S)

## Step 4: Create Folder Structure

In Xcode, create folders with proper names:

1. Right-click project → **New Group** (or Cmd+Option+N)
2. Name it "Models"
3. Repeat for:
   - **Managers**
   - **Views**
   - **Components**
   - **Constants**

## Step 5: Add Swift Files

### Add to Models folder:
- `Book.swift`

### Add to Managers folder:
- `BookManager.swift`
- `AmbientLightManager.swift`
- `SpeechManager.swift`
- `FavoritesManager.swift`

### Add to Views folder:
- `HomeView.swift`
- `ReadingView.swift`
- `FavoriteCaptureView.swift`
- `ChapterSelectorView.swift`

### Add to Components folder:
- `WaveAnimation.swift`
- `AnimationModifiers.swift`

### Add to Constants folder:
- `Colors.swift`

### Add to root:
- `HarborApp.swift`

For each file:
1. Right-click folder → **New File** (or Cmd+N)
2. Choose **Swift File**
3. Name it exactly as listed
4. Check "Create groups" and "Add to Harbor target"
5. Click **Create**
6. Copy-paste the file contents

## Step 6: Enable Capabilities

1. Select **Harbor** project
2. Select **Harbor** target
3. Go to **Signing & Capabilities** tab
4. Click **+ Capability** (top-left)
5. Search and add:
   - **Microphone**
   - **Camera**

## Step 7: Delete Default Files

If they exist, delete:
- `ContentView.swift`
- Any default preview files

## Step 8: Build and Run

1. At top-left, select **iPhone 17 Pro** simulator
   - If not available, click simulator selector → **Add Additional Simulators**
   - Choose iOS 17.x, iPhone 17 Pro
2. Press **Cmd+R** to build and run
3. Wait for simulator to launch
4. Enjoy Harbor!

## Troubleshooting

### Build Fails: "Module not found"
- Ensure all files are added to Harbor target
- Check folder structure matches above
- Clean build: Cmd+Shift+K, then Cmd+B

### App Crashes at Launch
- Verify Info.plist has all 3 permission keys
- Ensure HarborApp.swift has @main attribute
- Check that iOS deployment target is 17.0

### Simulator Won't Start
- Restart Xcode (Cmd+Q, reopen)
- Restart simulator: Hardware → Erase All Content and Settings
- Create new simulator: Window → Devices and Simulators

### Voice Commands Not Working
- Simulator must have internet connection
- Ensure Microphone capability is enabled
- Check Info.plist has NSMicrophoneUsageDescription

### Brightness Not Adapting
- Ensure Camera capability is enabled
- Try different simulator locations or use device
- Check Info.plist has NSCameraUsageDescription

### Favorites Not Saving
- This is expected in simulator - UserDefaults may reset
- Test on physical device for persistent storage
- Restarting app will clear favorites in simulator

## File Overview

| File | Lines | Purpose |
|------|-------|---------|
| Book.swift | 101 | Models: Book, Chapter, FavoriteSentence |
| BookManager.swift | 92 | Manages books & loads 3 sample books |
| AmbientLightManager.swift | 94 | Adaptive brightness with sensor data |
| SpeechManager.swift | 156 | Voice recognition & command parsing |
| FavoritesManager.swift | 50 | Favorite quotes persistence |
| HomeView.swift | 147 | Book selection screen |
| ReadingView.swift | 281 | Main reading interface |
| FavoriteCaptureView.swift | 219 | Capture & manage favorites |
| ChapterSelectorView.swift | 119 | Jump to chapters |
| WaveAnimation.swift | 74 | Ocean wave visualization |
| AnimationModifiers.swift | 97 | Smooth transitions & haptics |
| Colors.swift | 20 | Color system (5 colors) |
| HarborApp.swift | 12 | App entry point |

**Total: ~1,362 lines of production code**

## Architecture Overview

```
┌──────────────────────┐
│   HarborApp.swift    │ ← App entry point
└──────────┬───────────┘
           │
    ┌──────▼──────────┐
    │   HomeView      │ ← Book selection
    └──────┬──────────┘
           │ NavigationStack
    ┌──────▼──────────┐
    │  ReadingView    │ ← Main reading
    └──────┬──────────┘
           │
    ┌──────┴──────────────────────┐
    │                             │
┌───▼────┐  ┌───────┐  ┌─────────▼──┐
│ Voice  │  │ Light │  │ Favorites  │
│Manager │  │Manager│  │  Manager   │
└────────┘  └───────┘  └────────────┘
    │          │            │
    └──────────┴────────────┘
         Managers
```

## Key Features by File

### Models (Book.swift)
- Book: title, author, chapters, progress
- Chapter: title, pages array
- FavoriteSentence: text, book/chapter/page refs
- Navigation methods: nextPage(), previousPage(), goToChapter()

### Managers
- **BookManager**: Load 3 sample books, manage state
- **AmbientLightManager**: Monitor brightness every 0.5s, auto dark mode
- **SpeechManager**: Listen for voice, parse commands
- **FavoritesManager**: Save/load/search favorites from UserDefaults

### Views
- **HomeView**: Book library with progress bars & wave animations
- **ReadingView**: Full reading interface with tap/voice navigation
- **FavoriteCaptureView**: Modal to capture & manage favorites
- **ChapterSelectorView**: Modal to jump between chapters

### Components
- **WaveAnimation**: Canvas-based ocean waves showing progress
- **AnimationModifiers**: Smooth transitions, haptic feedback, styling

### Constants
- **Colors**: 5-color palette (Harbor Blue, Dark, Teal, Light Wave, Soft Gray)

## Testing Checklist

After setup, test these features:

- [ ] App launches and shows 3 books
- [ ] Can tap book card to enter reading view
- [ ] Page content displays properly
- [ ] Previous/Next buttons work
- [ ] Back button returns to home
- [ ] Microphone button exists (voice)
- [ ] Heart button captures favorites
- [ ] Chapter selector button shows chapters
- [ ] Brightness adapts to simulator lighting
- [ ] Dark mode works at night

## Performance Tips

- All animations use 0.3s easing for smoothness
- Speech recognition runs on background threads
- Ambient light updates throttled to 0.5s intervals
- Wave animation uses Canvas for GPU optimization
- All data stored locally in UserDefaults

## Next Steps

Once setup is complete:

1. **Read the code**: Start with HarborApp.swift
2. **Explore views**: HomeView → ReadingView flow
3. **Test features**: Try voice commands, capture favorites
4. **Customize**: Edit Colors.swift to change theme
5. **Add books**: Modify BookManager.swift to add content

## Customization Ideas

### Change Colors
Edit `Constants/Colors.swift`:
```swift
static let harborBlue = Color(red: 0.29, green: 0.56, blue: 0.89)
```

### Add Books
Edit `Managers/BookManager.swift`:
```swift
let newChapters = [
    Chapter(title: "Ch 1", pages: ["Content..."])
]
return Book(title: "New Book", author: "Author", chapters: newChapters)
```

### Customize Fonts
Find font definitions in Views and change size/weight:
```swift
.font(.system(size: 16, weight: .semibold))  // Edit size and weight
```

## Support

For issues:

1. Check **Info.plist** has all 3 keys
2. Verify **Capabilities** are enabled
3. Ensure **iOS 17.0+** deployment target
4. Try **Clean Build Folder** (Cmd+Shift+K)
5. Restart Xcode completely

---

**Harbor v1.0** | Ready to read! 📚⛵
