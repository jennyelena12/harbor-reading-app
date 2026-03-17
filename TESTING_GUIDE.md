# Harbor Testing Guide

Complete testing procedures for all Harbor features.

## Pre-Testing Checklist

Before running tests, ensure:

- [ ] App builds without errors (Cmd+B)
- [ ] No permission alerts on first launch
- [ ] iPhone 17 simulator selected
- [ ] iOS 17+ deployment target
- [ ] All 7 .swift files present
- [ ] Info.plist has 3 permission keys
- [ ] Camera and Microphone capabilities enabled

## Test Categories

### 1. Sensor Integration Tests

#### 1.1 Ambient Light Detection

**Setup**: Open ReadingScreen, wait 5 seconds

**Test Cases**:

| #  | Action | Expected | Status |
|----|--------|----------|--------|
| 1a | Bright environment (move near window) | Screen brightness increases | ⬜ |
| 1b | Dark environment (cover simulator camera) | Dark mode activates, text turns white | ⬜ |
| 1c | Medium light | Balanced brightness, light gray background | ⬜ |
| 1d | Simulate full light (Debug menu) | Brightness ~80-100% | ⬜ |
| 1e | Simulate dark (Debug menu) | Dark mode ON, isDarkMode = true | ⬜ |

**How to Simulate in Xcode**:
```
Debug → Simulate Different Light Environments → [Choose option]
```

**Expected Behavior**:
- Brightness slider moves to match light level
- Dark mode badge shows current state
- Text color changes automatically
- Transitions are smooth (no flicker)

---

#### 1.2 Accelerometer/Motion

**Setup**: Open ReadingScreen

**Test Cases**:

| #  | Action | Expected | Status |
|----|--------|----------|--------|
| 2a | Hold device vertical (portrait) | Normal brightness baseline | ⬜ |
| 2b | Tilt device for reading angle | Slight brightness increase possible | ⬜ |
| 2c | Change angles slowly | Smooth transitions, no jumps | ⬜ |
| 2d | Device on table | Brightness remains stable | ⬜ |

**Note**: Accelerometer effects are subtle and enhancement-based, not obvious changes.

---

### 2. Navigation Tests

#### 2.1 Tap Navigation

**Setup**: Open ReadingScreen with book loaded

**Test Cases**:

| #  | Action | Location | Expected | Status |
|----|--------|----------|----------|--------|
| 3a | Single tap | Left 20% of screen | Page goes back by 1 | ⬜ |
| 3b | Single tap | Right 20% of screen | Page goes forward by 1 | ⬜ |
| 3c | Single tap | Left <5% from edge | Previous page | ⬜ |
| 3d | Single tap | Right >95% from edge | Next page | ⬜ |
| 3e | Single tap | Center of screen | Text becomes selectable (no page change) | ⬜ |
| 3f | Text selection | Highlight text | Text highlight appears | ⬜ |
| 3g | At page 0 | Tap left | No change (button disabled) | ⬜ |
| 3h | At last page | Tap right | No change (button disabled) | ⬜ |

**Test Code**:
```swift
// View tap zones in ReadingScreen:
let screenWidth = UIScreen.main.bounds.width
let tapZoneWidth = screenWidth * 0.2  // 20% = 78px on 390px width
```

---

#### 2.2 Voice Navigation

**Setup**: Open ReadingScreen, have microphone ready

**Test Cases**:

| #  | Command | Result | Status |
|----|---------|--------|--------|
| 4a | "Next page" | Go to next page, haptic feedback | ⬜ |
| 4b | "Forward" | Go to next page | ⬜ |
| 4c | "Previous page" | Go to previous page, haptic feedback | ⬜ |
| 4d | "Back" | Go to previous page | ⬜ |
| 4e | "Go to chapter 2" | Jump to chapter 2 (if exists) | ⬜ |
| 4f | "Chapter five" | Should recognize "five" as number | ⬜ |
| 4g | "Skip ahead" | No action (unrecognized) | ⬜ |
| 4h | Speak quietly | Recognition may fail, try louder | ⬜ |
| 4i | No internet | Voice recognition fails gracefully | ⬜ |

**How to Test**:
1. Tap microphone button (becomes red)
2. Speak command clearly
3. Wait for text to appear
4. Command executes automatically
5. "Listening..." indicator updates in real-time

**Requirements**:
- Microphone permission granted
- Internet connection for best results
- Quiet environment
- Speak naturally and clearly

---

#### 2.3 Button Navigation

**Setup**: Open ReadingScreen

**Test Cases**:

| #  | Action | Expected | Status |
|----|--------|----------|--------|
| 5a | Tap previous button | Go back 1 page, haptic feedback | ⬜ |
| 5b | Tap next button | Go forward 1 page, haptic feedback | ⬜ |
| 5c | Tap at start of book | Previous button disabled (grayed out) | ⬜ |
| 5d | Tap at end of book | Next button disabled (grayed out) | ⬜ |
| 5e | Rapid tapping | Pages change smoothly, no crashes | ⬜ |
| 5f | Tap while animating | Queue properly, execute in order | ⬜ |

---

### 3. Brightness Control Tests

#### 3.1 Brightness Slider

**Setup**: Open ReadingScreen, tap sun/moon icon

**Test Cases**:

| #  | Action | Expected | Status |
|----|--------|----------|--------|
| 6a | Tap sun icon | Brightness slider appears | ⬜ |
| 6b | Drag slider left | Brightness decreases, text visible | ⬜ |
| 6c | Drag slider right | Brightness increases, text bright | ⬜ |
| 6d | Set to minimum | Screen dark but readable | ⬜ |
| 6e | Set to maximum | Screen very bright | ⬜ |
| 6f | Read sensor % | Shows correct percentage (0-100) | ⬜ |
| 6g | Change light level | Slider auto-updates to match | ⬜ |
| 6h | Tap moon icon | Dark mode visual confirmed | ⬜ |

**Expected Behavior**:
- Text color adapts automatically
- Background color changes
- Slider shows sensor reading in percentage
- Manual override works smoothly
- Visual feedback is immediate

---

### 4. Favorite Sentence Tests

#### 4.1 Capture Functionality

**Setup**: Open ReadingScreen

**Test Cases**:

| #  | Action | Expected | Status |
|----|--------|----------|--------|
| 7a | Tap "Capture" button | Sentence capture sheet appears | ⬜ |
| 7b | Copy from page text | Paste into text field | ⬜ |
| 7c | Type custom sentence | Text appears in field | ⬜ |
| 7d | Leave empty, tap Save | Alert: "Please enter a sentence" | ⬜ |
| 7e | Enter text, tap Save | Sheet closes, sentence saved | ⬜ |
| 7f | Tap Cancel | Sheet closes without saving | ⬜ |
| 7g | Metadata shown | Book, chapter, page displayed | ⬜ |

**Expected Metadata**:
- Book title: From current book
- Chapter: From current location
- Page number: Current page in chapter
- Timestamp: Current date/time

---

#### 4.2 Favorites Gallery

**Setup**: Save 3-5 favorite sentences, then open Favorites

**Test Cases**:

| #  | Action | Expected | Status |
|----|--------|----------|--------|
| 8a | Open Favorites | All saved sentences display | ⬜ |
| 8b | Each card shows | Quote, book, chapter, date | ⬜ |
| 8c | Scroll down | Can view all favorites | ⬜ |
| 8d | Copy button | Quote copied to clipboard | ⬜ |
| 8e | Paste elsewhere | Pasted text matches original | ⬜ |
| 8f | Delete button | Shows confirmation dialog | ⬜ |
| 8g | Confirm delete | Favorite removed from list | ⬜ |
| 8h | Cancel delete | Favorite remains in list | ⬜ |

---

#### 4.3 Search and Sort

**Setup**: Have 5+ favorites saved

**Test Cases**:

| #  | Action | Expected | Status |
|----|--------|----------|--------|
| 9a | Type in search | Filtered results appear | ⬜ |
| 9b | Search book title | Shows favorites from that book | ⬜ |
| 9c | Search phrase | Shows matching sentences | ⬜ |
| 9d | Clear search | All favorites reappear | ⬜ |
| 9e | Sort by Date | Most recent first | ⬜ |
| 9f | Sort by Book | Alphabetical by book title | ⬜ |
| 9g | Sort by Length | Longest sentences first | ⬜ |
| 9h | No results | Empty state shows "No matches" | ⬜ |
| 9i | Persistence | Favorites still there after restart | ⬜ |

---

### 5. Book Management Tests

#### 5.1 Home Screen

**Setup**: Open app on fresh install

**Test Cases**:

| #  | Action | Expected | Status |
|----|--------|----------|--------|
| 10a | App launches | Home screen appears instantly | ⬜ |
| 10b | Current book shows | Book cover, title, author visible | ⬜ |
| 10c | Progress bar shows | Accurate % complete | ⬜ |
| 10d | Ocean visualization | Waves animate smoothly | ⬜ |
| 10e | Sailboat indicator | Shows at correct progress % | ⬜ |
| 10f | Library section | Shows other books | ⬜ |
| 10g | Select other book | Becomes current book | ⬜ |
| 10h | Favorites shortcut | Shows correct count | ⬜ |
| 10i | Continue button | Opens reading screen | ⬜ |

---

#### 5.2 Book Navigation

**Setup**: Open ReadingScreen from Home

**Test Cases**:

| #  | Action | Expected | Status |
|----|--------|----------|--------|
| 11a | Book loads | Current page text displays | ⬜ |
| 11b | Chapter title shown | In header bar | ⬜ |
| 11c | Page reference shown | "Page X of Y" in header | ⬜ |
| 11d | Progress accurate | Reflects current page | ⬜ |
| 11e | Switch books | Progress persists per book | ⬜ |
| 11f | Return to Home | Current page remembered | ⬜ |
| 11g | Navigate pages | Progress updates correctly | ⬜ |

---

### 6. UI/UX Tests

#### 6.1 Animations

**Setup**: Use app normally, observe transitions

**Test Cases**:

| #  | Action | Expected | Status |
|----|--------|----------|--------|
| 12a | Page turn | Smooth fade + slide animation | ⬜ |
| 12b | Ocean waves | Continuous, natural motion | ⬜ |
| 12c | Progress bar | Smooth % updates | ⬜ |
| 12d | Button press | Scale + opacity feedback | ⬜ |
| 12e | Sheet open | Smooth bottom slide | ⬜ |
| 12f | Theme transition | Fade to dark/light smoothly | ⬜ |

**Expected Frame Rate**: 120fps (smooth, no jank)

---

#### 6.2 Haptics

**Setup**: Enable haptics, use app features

**Test Cases**:

| #  | Action | Expected | Feeling |
|----|--------|----------|---------|
| 13a | Page turn | haptic feedback | Light tap |
| 13b | Voice start | Special vibration | Pattern |
| 13c | Voice end | Different pattern | Success |
| 13d | Button press | Subtle feedback | Light feel |
| 13e | Delete action | Stronger feedback | Heavy feel |

**Note**: Haptics disabled in simulator, test on real device for best experience.

---

#### 6.3 Responsive Design

**Setup**: Test on different screen sizes

**Test Cases**:

| #  | Size | Action | Expected | Status |
|----|------|--------|----------|--------|
| 14a | 375px (SE) | Open app | UI fits without scrolling | ⬜ |
| 14b | 390px (17) | Open app | Perfect fit, no scaling | ⬜ |
| 14c | 428px (Max) | Open app | Comfortable layout | ⬜ |
| 14d | Any size | Read book | Text readable, good line height | ⬜ |
| 14e | Any size | Buttons | All 44pt minimum | ⬜ |
| 14f | Any size | Cards | No truncation | ⬜ |

---

### 7. Permission Tests

#### 7.1 Permission Requests

**Setup**: Fresh app install (clean simulator)

**Test Cases**:

| #  | Feature | First Use | Expected | Status |
|----|---------|-----------|----------|--------|
| 15a | Brightness | Open Reading | Camera permission request | ⬜ |
| 15b | Voice | Tap mic button | Microphone permission request | ⬜ |
| 15c | Multiple | First launch | Requests appear in order | ⬜ |
| 15d | Deny camera | Still readable, no brightness | ⬜ |
| 15e | Deny mic | Voice unavailable, other nav works | ⬜ |
| 15f | Grant later | Re-request on next use | ⬜ |

**How to Reset Permissions**:
```
Device → Erase All Content and Settings
(Simulator only)
```

---

#### 7.2 Permission States

**Setup**: Settings → Harbor

**Test Cases**:

| #  | Setting | State | Expected | Status |
|----|---------|-------|----------|--------|
| 16a | Camera | ON | Brightness adjusts | ⬜ |
| 16b | Camera | OFF | Brightness stays manual | ⬜ |
| 16c | Microphone | ON | Voice works | ⬜ |
| 16d | Microphone | OFF | Voice unavailable | ⬜ |
| 16e | Toggle ON/OFF | Restart app | Permission honored | ⬜ |

---

### 8. Data Persistence Tests

#### 8.1 Favorites Persistence

**Setup**: Save 3 favorites, close app, reopen

**Test Cases**:

| #  | Action | Expected | Status |
|----|--------|----------|--------|
| 17a | Save favorite | Appears in gallery | ⬜ |
| 17b | Close app (home button) | App suspended | ⬜ |
| 17c | Reopen app | Favorite still there | ⬜ |
| 17d | Force close | Swipe app up in multitask | ⬜ |
| 17e | Reopen after force close | Favorites preserved | ⬜ |
| 17f | Delete favorite | Removed from list | ⬜ |
| 17g | Reopen | Still deleted | ⬜ |
| 17h | Add 100 favorites | All saved without crashing | ⬜ |

**Data Storage**:
- Uses: UserDefaults
- Key: "harbor_favorites"
- Format: JSON-encoded array

---

#### 8.2 Reading Progress

**Setup**: Read to page 10, close app, reopen

**Test Cases**:

| #  | Action | Expected | Status |
|----|--------|----------|--------|
| 18a | Navigate to page 10 | Current page = 10 | ⬜ |
| 18b | Close app | Progress saved? (Check: will improve in future) | ⬜ |
| 18c | Reopen | May return to last page (planned feature) | ⬜ |

**Note**: Progress persistence not yet implemented, planned for v1.1

---

### 9. Performance Tests

#### 9.1 App Launch

**Setup**: Force close, reopen

**Test Cases**:

| #  | Scenario | Expected Time | Status |
|----|----------|----------------|--------|
| 19a | Cold launch | ~1 second | ⬜ |
| 19b | With 50 favorites | ~1-2 seconds | ⬜ |
| 19c | Warm launch | <500ms | ⬜ |
| 19d | No lag on first interaction | Responsive immediately | ⬜ |

---

#### 9.2 Memory Usage

**Setup**: Xcode Instruments (Memory tool)

**Test Cases**:

| #  | Action | Expected | Status |
|----|--------|----------|--------|
| 20a | Launch app | ~50MB | ⬜ |
| 20b | Read several pages | ~50-60MB | ⬜ |
| 20c | 50 favorites open | ~55-65MB | ⬜ |
| 20d | No leaks | Memory stable | ⬜ |

**How to Check**:
```
Product → Profile → Instruments → Memory
Watch allocations while using app
```

---

#### 9.3 Frame Rate

**Setup**: Open Developer Settings (if available)

**Test Cases**:

| #  | Animation | Expected FPS | Status |
|----|-----------|--------------|--------|
| 21a | Page transition | 120fps | ⬜ |
| 21b | Wave animation | 120fps | ⬜ |
| 21c | Brightness slider | 120fps | ⬜ |
| 21d | Scroll favorites | 120fps | ⬜ |

---

## Regression Testing Checklist

After making code changes, run through this quick test:

- [ ] App launches without crash
- [ ] All 4 books load
- [ ] Can navigate pages (all 3 methods)
- [ ] Voice command recognized
- [ ] Brightness adjusts
- [ ] Can save favorite
- [ ] Favorites persist after close
- [ ] No memory leaks
- [ ] No lag or jank
- [ ] Haptics work (on device)

---

## Test Results Template

```
Date: _______________
Tester: ______________
Device: iPhone 17 Simulator (iOS 17.0)
Xcode: 15.0+
Swift: 5.9+

Feature Tests:
[ ] Sensors (Light, Accelerometer)
[ ] Navigation (Tap, Voice, Button)
[ ] Brightness Control
[ ] Favorite Sentences
[ ] Book Management
[ ] UI/Animations
[ ] Permissions
[ ] Data Persistence
[ ] Performance

Issues Found:
1. _______________________________
2. _______________________________
3. _______________________________

Notes:
_________________________________
_________________________________

Overall Status: PASS / FAIL
```

---

## Debugging Tips

### Enable Console Logging
Add to any manager:
```swift
print("[Harbor Test] Event description")
```

### Check Sensor Values
```swift
print("[Harbor] Brightness: \(lightManager.brightness)")
print("[Harbor] Dark mode: \(lightManager.isDarkMode)")
print("[Harbor] Voice: \(speechManager.recognizedText)")
```

### Xcode Debugger
1. Set breakpoint in code
2. Run with Cmd+R
3. Execution pauses at breakpoint
4. Inspect variables in debug panel

### System Console
1. Window → Devices and Simulators
2. Select device
3. View system logs

---

## Known Issues & Workarounds

### Issue: Voice Recognition Timeouts
**Cause**: No internet or poor network
**Workaround**: Ensure WiFi connection, try again

### Issue: Brightness Doesn't Change
**Cause**: Camera permission denied
**Workaround**: Settings → Harbor → Camera → ON

### Issue: Permissions Not Requesting
**Cause**: Already denied in past
**Workaround**: Reset simulator (Erase All)

### Issue: App Crashes on Startup
**Cause**: Missing .swift files
**Workaround**: Verify all 7 files in Xcode

---

**Happy Testing!** 🧪

Report bugs with device, iOS version, and exact reproduction steps.
