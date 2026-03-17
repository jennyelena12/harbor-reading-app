# Harbor: iOS Reading App Setup Guide

Welcome to Harbor, a minimalist iOS reading app with a sea journey metaphor. This guide will help you set up the project in Xcode for iOS 17+.

## Project Overview

Harbor is a fully-featured SwiftUI reading application with the following features:

- **Home Screen**: Browse and manage your book library with ocean progress visualization
- **Reading Screen**: Immersive reading experience with adaptive brightness
- **Voice Navigation**: Control reading with voice commands ("next page", "previous page", "chapter 5")
- **Tap Navigation**: Quick page turning with edge tap zones
- **Favorite Sentences**: Capture and organize meaningful passages
- **Sensor Integration**: Real-time ambient light detection for automatic brightness adjustment
- **Apple Design**: Native SwiftUI UI with smooth animations and haptic feedback

## Files Included

```
Harbor/
├── HarborApp.swift              # App entry point
├── Models.swift                 # Data models & sample books
├── Managers.swift               # Business logic managers
│   ├── AmbientLightManager     # Sensor-based brightness
│   ├── SpeechRecognitionManager # Voice control
│   └── BookManager             # Book state management
├── HomeScreen.swift            # Book library & ocean progress
├── ReadingScreen.swift         # Reading interface
├── FavoritesGalleryView.swift  # Favorites management
└── HapticManager.swift         # Haptics & polish
```

## Setup Instructions

### 1. Create New Xcode Project

1. Open Xcode
2. Click **File** → **New** → **Project**
3. Select **iOS** → **App**
4. Configure project settings:
   - **Product Name**: Harbor
   - **Team ID**: Your Apple Team ID (or None for personal)
   - **Organization Identifier**: com.yourname.harbor
   - **Interface**: SwiftUI
   - **Language**: Swift
   - **Storage**: None

### 2. Add Files to Project

1. In Xcode, right-click on the project navigator (left panel)
2. Select **Add Files to "Harbor"**
3. Add all `.swift` files:
   - HarborApp.swift
   - Models.swift
   - Managers.swift
   - HomeScreen.swift
   - ReadingScreen.swift
   - FavoritesGalleryView.swift
   - HapticManager.swift

### 3. Configure Info.plist

Add the following permissions to your app:

1. Open **Info.plist** (in Project Navigator)
2. Add these keys:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>Harbor uses your microphone to recognize voice commands for page navigation and chapter selection.</string>

<key>NSCameraUsageDescription</key>
<string>Harbor uses your camera's light sensor to automatically adjust reading brightness based on ambient light conditions.</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>Optional: Harbor can use location data to enhance reading recommendations.</string>

<key>UIRequiredDeviceCapabilities</key>
<array>
    <string>microphone</string>
</array>
```

### 4. Enable Required Capabilities

1. Select the **Harbor** target
2. Go to **Signing & Capabilities**
3. Click **+ Capability** and add:
   - **Microphone** (for voice commands)
   - **Camera** (for light sensor access)

### 5. Set Deployment Target

1. Select the **Harbor** target
2. Go to **General** → **Minimum Deployments**
3. Set to **iOS 17.0** or higher

### 6. Build and Run

1. Select the **iPhone 17 simulator** (or your device) at the top
2. Press **Cmd + R** to build and run
3. The app will launch in the simulator/device

## Features Guide

### Ambient Light Detection

The app automatically detects ambient light using the device's camera and adjusts reading brightness:

- **Bright Environment**: Increases screen brightness automatically
- **Dark Environment**: Switches to dark mode for comfortable reading
- **Manual Override**: Use the brightness slider to fine-tune

### Voice Commands

Tap the microphone button during reading to use voice navigation:

- **"Next page" / "Forward"** → Go to next page
- **"Previous page" / "Back"** → Go to previous page
- **"Go to chapter [number]"** → Jump to specific chapter

### Tap Navigation

While reading:

- **Tap left 20% of screen** → Previous page
- **Tap right 20% of screen** → Next page
- **Tap center** → No action (allows text selection)

### Capture Favorite Sentences

1. While reading, tap the **"Capture"** button
2. Enter or paste your favorite sentence
3. The sentence is automatically tagged with:
   - Book title
   - Chapter and page number
   - Timestamp
4. Access favorites anytime from the **"Favorites"** tab

## Sensor Integration Details

### Ambient Light Manager

Uses the device's front-facing camera to detect ambient light:

```swift
// The AmbientLightManager analyzes camera frames to calculate average brightness
// Updates brightness at 1-second intervals for smooth transitions
// Exponential moving average smooths sudden light changes
```

### Accelerometer

Uses the accelerometer to detect reading posture:

- Detects when device is held at reading angle
- Optionally adjusts brightness for ergonomic positioning

### Microphone

Accesses device microphone for voice command recognition:

- Uses SFSpeechRecognizer framework (iOS 10+)
- Requires internet connection for best results
- Falls back gracefully if microphone unavailable

## Customization

### Change App Colors

Edit color values in `HomeScreen.swift`:

```swift
Color(hex: "#4A90E2")    // Harbor Blue
Color(hex: "#1B4965")    // Dark Navy
Color(hex: "#00A8CC")    // Teal Accent
Color(hex: "#F0F8FF")    // Light Background
```

### Add More Books

Edit `Models.swift`:

```swift
let sampleBooks: [Book] = [
    Book(
        id: "book-5",
        title: "Your Book Title",
        author: "Author Name",
        coverColor: "#YOUR_HEX_COLOR",
        chapters: [
            Chapter(
                id: "ch-5-1",
                title: "Chapter Name",
                pages: ["Page 1 text...", "Page 2 text..."]
            )
        ]
    )
]
```

### Adjust Font Sizes

In `ReadingScreen.swift`:

```swift
Text(bookManager.getCurrentPageText())
    .font(.system(size: 18, weight: .regular))  // Change 18 to desired size
    .lineSpacing(8)  // Adjust line spacing
```

## Troubleshooting

### Microphone Permission Denied

**Issue**: Voice commands not working

**Solution**:
1. Go to iPhone Settings → Harbor → Microphone
2. Toggle Microphone **ON**
3. Restart the app

### Brightness Not Changing

**Issue**: Adaptive brightness not working

**Solution**:
1. Ensure camera permission is granted
2. Check bright/dark environments to trigger adjustment
3. If simulator, use Hardware → Light Environment

### Voice Recognition Not Working

**Issue**: Speech-to-text not responding

**Solution**:
1. Ensure internet connection (required for recognition)
2. Speak clearly and naturally
3. Check that microphone is not covered
4. Ensure iOS 17+

### Book Content Not Displaying

**Issue**: Pages show empty

**Solution**:
1. Check Models.swift for valid page content
2. Ensure totalPages > 0
3. Verify currentPage index is within range

## Performance Tips

- **Reading**: The app uses efficient text rendering with SwiftUI
- **Memory**: Light sensor processing runs on background thread
- **Battery**: Voice recognition only active when button pressed
- **Camera**: Light detection pauses when app is backgrounded

## Advanced Features

### Background Sync

Books and favorites are stored locally in UserDefaults:

```swift
let favoritesKey = "harbor_favorites"
UserDefaults.standard.data(forKey: favoritesKey)
```

To implement iCloud sync in future:
```swift
// Replace UserDefaults with NSUbiquitousKeyValueStore
NSUbiquitousKeyValueStore.default
```

### Voice Command Customization

Edit `SpeechRecognitionManager.parseVoiceCommand()` to add custom commands:

```swift
if lowercased.contains("your_custom_keyword") {
    return .customCommand
}
```

## Architecture

Harbor follows MVVM pattern:

- **Models** (M): Book, Chapter, FavoriteSentence
- **ViewModels** (VM): BookManager, AmbientLightManager, SpeechRecognitionManager
- **Views** (V): HomeScreen, ReadingScreen, FavoritesGalleryView

## Testing in Simulator

### Simulate Different Light Levels

1. In Xcode menu: **Debug** → **Simulate Different Light Environments**
2. Choose from presets (Full Light, Dark, etc.)

### Test Voice Commands

1. In Xcode menu: **I/O** → **Audio Input** → Select a microphone
2. Or use dictation on Mac while simulator is focused

## Deployment to App Store

To submit Harbor to the App Store:

1. Create an App Store Connect record
2. Configure app metadata, screenshots, and description
3. Build an Archive: **Product** → **Archive**
4. Upload using **Transporter** or Xcode
5. Submit for review

## Resources

- **SwiftUI Documentation**: https://developer.apple.com/xcode/swiftui/
- **Speech Framework**: https://developer.apple.com/documentation/speech
- **AVFoundation**: https://developer.apple.com/avfoundation/
- **Apple HIG**: https://developer.apple.com/design/human-interface-guidelines/

## Support

For issues or questions:

1. Check Apple Developer Documentation
2. Review inline code comments
3. Test in different iOS versions
4. Check iOS device settings for permissions

---

**Happy reading with Harbor!** ⛵

Enjoy your sea journey through the literary ocean.
