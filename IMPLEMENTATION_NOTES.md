# Harbor iOS App - Implementation Notes

## Architecture Overview

Harbor uses SwiftUI with MVVM pattern to maintain clean separation of concerns:

```
┌─────────────────────────────────────────────────┐
│              User Interface Layer               │
│  HomeScreen | ReadingScreen | FavoritesView   │
└────────────────────┬────────────────────────────┘
                     │
┌─────────────────────┴────────────────────────────┐
│         State Management & Managers              │
│  BookManager | AmbientLightManager              │
│  SpeechRecognitionManager                       │
└────────────────────┬────────────────────────────┘
                     │
┌─────────────────────┴────────────────────────────┐
│            Data Models & Persistence             │
│  Book | Chapter | FavoriteSentence             │
│  UserDefaults (local storage)                   │
└─────────────────────────────────────────────────┘
```

## Core Components

### 1. Models.swift

**Responsibility**: Define data structures and provide sample books

**Key Types**:
- `Book`: Represents a book with chapters and pages
- `Chapter`: Contains multiple pages of text
- `FavoriteSentence`: Represents a user's favorite quote with metadata

**Design Decisions**:
- `Book` is a struct with computed `totalPages` property
- `progress` computed property automatically calculates reading progress
- Sample books include diverse content for testing all features
- All models conform to `Codable` for potential future syncing

### 2. Managers.swift

**Responsibility**: Handle business logic and sensor management

#### AmbientLightManager
- **Purpose**: Detects ambient light and adjusts screen brightness
- **Implementation**: 
  - Uses `AVCaptureSession` to access camera
  - Analyzes video frames to calculate average brightness
  - Updates at 1-second intervals to prevent excessive updates
  - Uses exponential moving average to smooth sudden changes
- **Thread Safety**: Runs camera processing on background thread
- **Fallback**: Uses system brightness if camera unavailable

#### SpeechRecognitionManager
- **Purpose**: Converts voice commands to navigation actions
- **Implementation**:
  - Uses `SFSpeechRecognizer` with en-US locale
  - Accesses microphone via `AVAudioEngine`
  - Processes audio in real-time with partial results
  - Keyword matching for robustness
- **Voice Commands Supported**:
  - "Next page" / "Forward" → `nextPage`
  - "Previous page" / "Back" → `previousPage`
  - "Go to chapter [number]" → `goToChapter`

#### BookManager
- **Purpose**: Manage reading state and favorites
- **Features**:
  - Tracks current book and current page
  - Provides pagination methods
  - Manages favorite sentences with persistence
  - Uses `UserDefaults` for local storage

### 3. HomeScreen.swift

**Responsibility**: Display book library with reading progress

**Key Features**:
- Ocean progress visualization using animated wave shapes
- Quick access to continue reading
- Library view showing all books
- Shortcuts to favorites and settings

**Design Details**:
- Wave animation uses sine wave math for natural ocean appearance
- Progress bar shows visual representation of reading completion
- Sailboat indicator marks reader's progress on the ocean visualization
- Color scheme uses harbor blues (#4A90E2) and dark navy (#1B4965)

**Haptic Feedback**:
- Light tap when selecting book
- Navigation transitions trigger page flip haptics

### 4. ReadingScreen.swift

**Responsibility**: Immersive reading experience with all navigation modes

**Three Navigation Methods**:

1. **Tap Navigation**
   - Left 20% of screen → Previous page
   - Right 20% of screen → Next page
   - Center → Allows text selection
   - Implemented via `onTapGesture` with location analysis

2. **Voice Navigation**
   - Microphone button activates speech recognition
   - Shows recognized text for user feedback
   - Executes command when recognition completes

3. **Button Navigation**
   - Always visible left/right arrow buttons
   - Accessible for users who prefer explicit controls
   - Disabled when at beginning/end of book

**Adaptive Brightness**:
- Brightness slider shows ambient light sensor reading
- Slider allows manual override for personal preference
- "Auto-brightness ON" indicator shows system is active
- Background opacity changes based on brightness for visual feedback

**Text Selection**:
- Text is selectable for highlighting and copying
- Text selection doesn't trigger page navigation (only edge taps do)
- Supports copying passages for use elsewhere

### 5. FavoritesGalleryView.swift

**Responsibility**: View, search, and manage favorite sentences

**Features**:
- Full-text search across sentences and book titles
- Sort options: Date, Book, Length
- Visual quote formatting with quotation marks
- Copy to clipboard functionality
- Delete with confirmation

**Data Persistence**:
- Favorites stored in `UserDefaults` as JSON
- Automatically load on app launch
- Auto-save when new favorite added
- Support for future iCloud sync

### 6. HapticManager.swift

**Responsibility**: Provide haptic feedback for user interactions

**Haptic Types**:
- `lightTap()`: Light feedback for minor interactions
- `pageFlip()`: Medium feedback for page turns
- `strongTap()`: Heavy feedback for important actions
- `selection()`: Selection wheel feedback
- `voiceStart()`: Pattern for voice recognition start
- `voiceEnd()`: Pattern for voice recognition end

**Performance**:
- Generators are prepared in advance to minimize latency
- Haptics improve tactile feedback without sound
- Battery impact is minimal

## Color Palette

The app uses a carefully selected 4-color palette inspired by ocean themes:

```
Primary Brand: #4A90E2 (Harbor Blue)
- Used for buttons, links, important UI elements
- Represents calm, trustworthy ocean

Dark Accent: #1B4965 (Deep Navy)
- Used for text and backgrounds
- Provides strong contrast for readability

Light Accent: #00A8CC (Teal)
- Used for secondary actions and accents
- Represents shallow ocean water

Background: #F0F8FF (Alice Blue)
- Used for app backgrounds
- Provides light, peaceful backdrop
```

All colors are implemented using hex color extension for consistency.

## Data Persistence Strategy

### Current Implementation (Local Storage)
```swift
UserDefaults.standard.set(encoded, forKey: "harbor_favorites")
```

### Future Enhancements
```swift
// Option 1: iCloud Sync
NSUbiquitousKeyValueStore.default

// Option 2: CloudKit
CKDatabase

// Option 3: Core Data
NSPersistentCloudKitContainer
```

## Performance Optimizations

### 1. Background Light Processing
```swift
DispatchQueue.background.async { 
    session.startRunning()
}
```
- Camera processing runs on background thread
- Doesn't block main UI thread

### 2. Rate-Limited Updates
```swift
guard Date().timeIntervalSince(lastUpdate) > 1.0 else { return }
```
- Brightness updates limited to 1 per second
- Prevents excessive state changes

### 3. Exponential Moving Average
```swift
brightness = (brightness * 0.7) + (newValue * 0.3)
```
- Smooths sensor data
- Reduces flicker and jitter

### 4. Lazy Loading
```swift
NavigationLink(destination: ReadingScreen(...))
```
- Only creates reading view when navigated
- Reduces initial load time

## Sensor Integration Deep Dive

### Ambient Light Detection (AVCaptureSession)

The AmbientLightManager uses the device's camera to estimate ambient light:

1. **Setup Phase**:
   - Creates AVCaptureSession with video output
   - Accesses rear-facing camera (default)
   - Configures sample buffer delegate

2. **Capture Phase**:
   ```swift
   func captureOutput(_ output: AVCaptureOutput, 
                      didOutput sampleBuffer: CMSampleBuffer, 
                      from connection: AVCaptureConnection)
   ```
   - Processes camera frames at native frame rate
   - Extracts pixel data from video buffer

3. **Analysis Phase**:
   - Samples 100 pixels from frame
   - Calculates R+G+B average per pixel
   - Takes mean across sampled pixels
   - Normalizes to 0-1 range

4. **Smoothing Phase**:
   - Applies exponential moving average
   - Prevents sudden jumps in brightness
   - Updates UI on main thread

### Accelerometer Integration (CMMotionManager)

The accelerometer enhances brightness adaptation:

```swift
let zAccel = data.acceleration.z
if zAccel < -0.5 {
    // Device tilted for reading position
    brightness = min(brightness + 0.05, 1.0)
}
```

- Detects when device is held at comfortable reading angle
- Provides subtle brightness boost for better reading posture
- Uses Z-axis acceleration (vertical axis when device normal to ground)

### Speech Recognition (SFSpeechRecognizer)

Voice navigation uses on-device and server-based speech recognition:

```
User speaks → Audio buffer → SFSpeechRecognitionRequest 
→ Server/Device processing → SFSpeechRecognitionResult 
→ Text parsing → Command execution
```

**Word Error Rate**: ~5-10% on clear audio
**Latency**: 1-3 seconds from speech end to recognition
**Best Practices**:
- Speak clearly and naturally
- Use consistent commands
- Ensure good microphone condition
- Maintain quiet environment for best accuracy

## Animation Strategy

### Page Transitions
```swift
.transition(.asymmetric(
    insertion: .opacity.combined(with: .move(edge: .trailing)),
    removal: .opacity.combined(with: .move(edge: .leading))
))
```
- Smooth fade + slide for page changes
- Directional feedback (right = next, left = previous)

### Wave Animation
```swift
withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
    waveOffset = 40
}
```
- Continuous ocean wave effect
- Uses sine wave math for natural motion
- 3-second period matches leisurely reading pace

### Button Interactions
```swift
.scaleEffect(isPressed ? 0.95 : 1.0)
.opacity(isPressed ? 0.8 : 0.1)
```
- Visual feedback without haptics
- Subtle scaling + opacity changes
- Feels responsive and native

## Testing Checklist

### Sensor Testing
- [ ] Brightness adjustment in bright light
- [ ] Dark mode activation in dark environment
- [ ] Microphone permission request
- [ ] Voice command recognition in quiet environment
- [ ] Voice command recognition with background noise

### Navigation Testing
- [ ] Tap left edge → previous page
- [ ] Tap right edge → next page
- [ ] Tap center → text selection works
- [ ] Voice "next page" command
- [ ] Voice "go to chapter 2" command
- [ ] Button navigation enabled/disabled correctly

### Content Testing
- [ ] All 4 sample books load
- [ ] Pagination works for all books
- [ ] Progress percentage accurate
- [ ] Ocean visualization shows correct progress

### Favorites Testing
- [ ] Capture sentence opens sheet
- [ ] Sentence saved with correct metadata
- [ ] Favorite appears in gallery
- [ ] Search filters favorites correctly
- [ ] Copy to clipboard works
- [ ] Delete confirmation appears
- [ ] Favorites persist after app restart

### UI Testing
- [ ] Dark mode activated in low light
- [ ] Light mode in bright environment
- [ ] Animations smooth on iPhone 17
- [ ] Text is readable in both modes
- [ ] All buttons are tappable (min 44pt)
- [ ] No text overlaps or cutoffs

## Known Limitations & Future Work

### Current Limitations
1. **Sample Books Only**: Uses hardcoded book content
   - Future: Support PDF import, iCloud Books
2. **Single Device**: Favorites not synced
   - Future: iCloud sync, multi-device support
3. **No Bookmarks**: Can only save sentences
   - Future: Add bookmark/highlight features
4. **Limited Voice Commands**: Only supports basic commands
   - Future: Natural language understanding
5. **No Dark Mode Toggle**: Only sensor-based
   - Future: Manual theme selection

### Planned Enhancements
- [ ] PDF import functionality
- [ ] iCloud synchronization
- [ ] Reading statistics & analytics
- [ ] Custom themes & color schemes
- [ ] Text-to-speech reading aloud
- [ ] Social sharing of favorite quotes
- [ ] Reading goals & streak tracking
- [ ] Library organization (collections, tags)
- [ ] Advanced search with filters
- [ ] Reading recommendations based on history

## Debugging Tips

### Enable Debug Logging
Add to any manager:
```swift
print("[Harbor] Event: \(details)")
```

### Sensor Values
Check AmbientLightManager:
```swift
print("[Harbor] Brightness: \(brightness)")
print("[Harbor] Dark mode: \(isDarkMode)")
```

### Voice Recognition
Monitor SpeechRecognitionManager:
```swift
print("[Harbor] Text: \(recognizedText)")
print("[Harbor] Is listening: \(isListening)")
```

### Memory Usage
Monitor in Xcode Debugger:
1. Product → Run with Instruments
2. Select "Memory"
3. Watch allocations while navigating app

## Accessibility Considerations

### Current Features
- Text is selectable (enables VoiceOver reading)
- Colors have sufficient contrast ratio (4.5:1 minimum)
- Text sizes respect Dynamic Type (though not implemented yet)
- Buttons minimum 44pt × 44pt touch target

### Future Improvements
- [ ] VoiceOver labels for all UI elements
- [ ] Dynamic Type support for text size
- [ ] Reduced motion option
- [ ] High contrast mode support
- [ ] Support for text size accessibility settings

## Code Quality

### Swift Best Practices
- Strong type safety with Swift's type system
- Proper error handling in managers
- Clear separation of concerns
- MARK comments for code organization
- Descriptive variable and function names

### Memory Management
- Proper cleanup in deinit() methods
- No strong reference cycles
- Background threads properly managed
- Resources released when view disappears

### Thread Safety
- All UI updates on main thread
- Heavy operations on background threads
- DispatchQueue usage for threading
- Proper queue management

---

**Last Updated**: iOS 17.0+
**Swift Version**: Swift 5.9+
**SwiftUI Version**: Current (iOS 17)

For questions or issues, refer to:
- Apple Developer Documentation: developer.apple.com
- SwiftUI Tutorials: developer.apple.com/tutorials/swiftui
- Harbor SETUP.md for configuration help
