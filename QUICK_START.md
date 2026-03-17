# Harbor - Quick Start Guide (5 Minutes)

## Fastest Setup Path

### 1. Create Xcode Project (2 minutes)
```bash
1. Open Xcode
2. File → New → Project
3. Choose "App" template
4. Name: Harbor
5. Interface: SwiftUI
6. Click Create
```

### 2. Copy All Swift Files (1 minute)
Drag these 7 files into your Xcode project:
1. HarborApp.swift
2. Models.swift
3. Managers.swift
4. HomeScreen.swift
5. ReadingScreen.swift
6. FavoritesGalleryView.swift
7. HapticManager.swift

**Make sure to check "Copy items if needed"**

### 3. Add Permissions (1 minute)
Open `Info.plist` and add these three entries:

**Camera Permission** (for brightness sensor):
- Key: `NSCameraUsageDescription`
- Value: `Harbor uses your camera's light sensor to automatically adjust reading brightness.`

**Microphone Permission** (for voice commands):
- Key: `NSMicrophoneUsageDescription`
- Value: `Harbor uses your microphone to recognize voice commands for page navigation.`

**Speech Recognition** (for voice):
- Key: `NSSpeechRecognitionUsageDescription`
- Value: `Harbor requests permission to use speech recognition for voice-controlled reading.`

### 4. Enable Capabilities (30 seconds)
Select "Harbor" target → Signing & Capabilities → "+ Capability"
Add:
- Microphone
- Camera

### 5. Build and Run (1 minute)
```
Press: Cmd + R
Device: iPhone 17 Simulator (or your device)
```

**That's it!** Harbor is now running. 🚀

---

## What You Get

✅ **Complete Reading App** with:
- 4 sample books pre-loaded
- Ocean progress visualization
- Adaptive brightness (auto-adjusts for light/dark)
- Voice commands ("next page", "previous page", "chapter 5")
- Tap navigation (left/right edges)
- Favorite sentence capture with search
- Haptic feedback on interactions
- Smooth animations throughout

---

## Core Features in 30 Seconds

### Home Screen
- See your books with progress bars
- Ocean visualization shows how far you've read
- Quick links to favorites and reading settings

### Reading Screen
- Tap left edge → previous page
- Tap right edge → next page
- Tap mic button → voice commands
- Tap brightness icon → adjust brightness
- Tap "Capture" → save favorite sentences

### Favorites
- View all saved sentences
- Search across all quotes
- Copy to clipboard
- Sort by date, book, or length
- Delete unwanted favorites

---

## Voice Commands (Just Say These)

| Command | Action |
|---------|--------|
| "Next page" | Go to next page |
| "Forward" | Go to next page |
| "Previous page" | Go to previous page |
| "Back" | Go to previous page |
| "Go to chapter 2" | Jump to chapter 2 |

---

## Common Issues & Fixes

### "Microphone permission denied"
**Fix**: Settings → Harbor → Microphone → Toggle ON

### "Voice commands not working"
**Fix**: 
1. Check Settings → Harbor → Microphone is ON
2. Need internet connection for speech recognition
3. Speak clearly and naturally

### "Brightness not changing"
**Fix**:
1. Settings → Harbor → Camera → Toggle ON
2. Try in different light (bright room vs dark room)
3. On simulator: Debug → Simulate Different Light Environments

### "App crashes on startup"
**Fix**:
1. Verify all 7 .swift files are in project
2. Check Info.plist has 3 permission keys
3. Make sure Xcode iOS 17+ is being used

---

## Customization Quick Tips

### Change Colors
In `HomeScreen.swift`, find these lines and change hex codes:

```swift
Color(hex: "#4A90E2")    // Blue → change to any hex
Color(hex: "#1B4965")    // Dark Navy → change to any hex
Color(hex: "#00A8CC")    // Teal → change to any hex
Color(hex: "#F0F8FF")    // Light Blue → change to any hex
```

### Add More Books
In `Models.swift`, copy this pattern:

```swift
Book(
    id: "book-5",
    title: "My New Book",
    author: "Author Name",
    coverColor: "#4A90E2",
    chapters: [
        Chapter(
            id: "ch-5-1",
            title: "Chapter 1",
            pages: [
                "First page text here...",
                "Second page text here...",
                "Third page text here..."
            ]
        )
    ]
)
```

### Change Font Size
In `ReadingScreen.swift`:

```swift
Text(bookManager.getCurrentPageText())
    .font(.system(size: 18, weight: .regular))  // Change 18 to 16, 20, etc.
```

---

## File Overview

| File | Purpose |
|------|---------|
| `HarborApp.swift` | App entry point - don't change |
| `Models.swift` | Book data & sample books - add books here |
| `Managers.swift` | Sensors, voice, book state - handles all logic |
| `HomeScreen.swift` | Library view with ocean visualization |
| `ReadingScreen.swift` | Main reading experience with all navigation |
| `FavoritesGalleryView.swift` | Manage favorite sentences |
| `HapticManager.swift` | Haptic feedback & polish |

---

## Testing Without Real Sensors

### Simulate Different Light Levels
1. In Xcode: Debug → Simulate Different Light Environments
2. Choose: Full Light, Sunny, Warm, Dark, etc.
3. Watch brightness auto-adjust!

### Test Voice Commands
1. In Xcode: I/O → Audio Input → Built-in Microphone
2. Speak towards your Mac's microphone
3. Works best in quiet environments

---

## Next Steps

After getting Harbor running:

1. **Explore the code**: Each file has `MARK:` comments explaining sections
2. **Read SETUP.md**: Full detailed setup instructions
3. **Check IMPLEMENTATION_NOTES.md**: Deep dive into how everything works
4. **Customize**: Add your own books and adjust colors
5. **Deploy**: Archive & submit to App Store when ready

---

## Xcode Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| Cmd + R | Build and Run |
| Cmd + B | Just Build |
| Cmd + K | Clear Build Folder |
| Cmd + U | Run Unit Tests |
| Cmd + Shift + K | Build for Running |

---

## Key Sensor Features Explained

### 🎨 Adaptive Brightness
- Camera continuously analyzes light in your environment
- Automatically adjusts screen brightness
- Manual slider to override if needed
- Accelerometer enhances reading posture detection

### 🎤 Voice Navigation
- Microphone captures your voice
- Converts to text using Speech framework
- Recognizes navigation commands
- Works without internet (device-based) or with internet (more accurate)

### 📖 Progress Tracking
- Accelerometer detects reading posture
- Location data helps with personalization (optional)
- Saves reading progress locally
- Can sync to iCloud with future update

---

## Performance Notes

✅ Smooth animation on iPhone 17
✅ Minimal battery impact from sensors
✅ Fast app startup
✅ Efficient text rendering
✅ No external dependencies (all native)

---

## Support Resources

**Apple Developer Docs**:
- SwiftUI: https://developer.apple.com/xcode/swiftui/
- Speech Framework: https://developer.apple.com/documentation/speech
- AVFoundation: https://developer.apple.com/avfoundation

**For This Project**:
- SETUP.md → Full setup details
- IMPLEMENTATION_NOTES.md → How everything works
- INFO_PLIST_TEMPLATE.txt → Permission configuration guide

---

## You're All Set! 

Harbor is ready to use. Start reading and capturing your favorite sentences!

**Happy sailing through the literary seas!** ⛵📚

---

**Version**: 1.0
**iOS**: 17.0+
**Swift**: 5.9+
**SwiftUI**: Current
