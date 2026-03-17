import SwiftUI
import UIKit

// MARK: - Haptic Manager

class HapticManager {
    static let shared = HapticManager()
    
    private let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let lightGenerator = UIImpactFeedbackGenerator(style: .light)
    private let heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let selectionGenerator = UISelectionFeedbackGenerator()
    
    func prepareHaptics() {
        impactGenerator.prepare()
        lightGenerator.prepare()
        heavyGenerator.prepare()
        selectionGenerator.prepare()
    }
    
    // Light tap feedback
    func lightTap() {
        lightGenerator.impactOccurred()
    }
    
    // Medium impact for page turns
    func pageFlip() {
        impactGenerator.impactOccurred()
    }
    
    // Strong feedback for important actions
    func strongTap() {
        heavyGenerator.impactOccurred()
    }
    
    // Selection feedback
    func selection() {
        selectionGenerator.selectionChanged()
    }
    
    // Voice recognition start
    func voiceStart() {
        let pattern: [NSNumber] = [0, 100, 50, 100]
        UIDevice.vibrate(with: pattern)
    }
    
    // Voice recognition end
    func voiceEnd() {
        let pattern: [NSNumber] = [0, 150, 50, 150, 50, 150]
        UIDevice.vibrate(with: pattern)
    }
}

// MARK: - Vibration Extension

extension UIDevice {
    static func vibrate(with pattern: [NSNumber]) {
        pattern.forEach { duration in
            if duration as! Int > 0 {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            }
            Thread.sleep(forTimeInterval: TimeInterval(truncating: duration) / 1000.0)
        }
    }
}

// MARK: - Animation Extensions

extension Animation {
    static let smoothEase = Animation.easeInOut(duration: 0.3)
    static let pageTransition = Animation.easeInOut(duration: 0.4)
    static let quickBounce = Animation.interpolatingSpring(stiffness: 300, damping: 10)
    static let gentleWave = Animation.easeInOut(duration: 2.5).repeatForever(autoreverses: false)
}

// MARK: - View Modifiers for Polish

struct PageTransitionModifier: ViewModifier {
    @State private var offset: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                withAnimation(.pageTransition) {
                    offset = 0
                }
            }
    }
}

struct SmoothButtonModifier: ViewModifier {
    @State private var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .opacity(isPressed ? 0.8 : 1.0)
            .onLongPressGesture(minimumDuration: 0.1, perform: {
                HapticManager.shared.lightTap()
            }, onPressingChanged: { pressing in
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = pressing
                }
            })
    }
}

struct FloatingLabelModifier: ViewModifier {
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isAnimating ? 1.05 : 1.0)
            .opacity(isAnimating ? 0.9 : 0.7)
            .onAppear {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
    }
}

// MARK: - View Extensions for Polish

extension View {
    func pageTransition() -> some View {
        modifier(PageTransitionModifier())
    }
    
    func smoothButton() -> some View {
        modifier(SmoothButtonModifier())
    }
    
    func floatingLabel() -> some View {
        modifier(FloatingLabelModifier())
    }
    
    func cardStyle(isDark: Bool = false) -> some View {
        self
            .padding(16)
            .background(isDark ? Color(hex: "#1B4965") : Color.white)
            .cornerRadius(14)
            .shadow(color: Color(hex: "#1B4965").opacity(isDark ? 0.3 : 0.1), radius: 8)
    }
    
    func seamlessTransition(_ enabled: Bool = true) -> some View {
        self
            .transition(.asymmetric(
                insertion: .opacity.combined(with: .move(edge: .trailing)),
                removal: .opacity.combined(with: .move(edge: .leading))
            ))
    }
}

// MARK: - Gradient Extensions

extension LinearGradient {
    static let harborLight = LinearGradient(
        gradient: Gradient(colors: [
            Color(hex: "#F0F8FF"),
            Color(hex: "#E6F2FF")
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let harborDark = LinearGradient(
        gradient: Gradient(colors: [
            Color(hex: "#0F2438"),
            Color(hex: "#1B4965")
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let oceanAccent = LinearGradient(
        gradient: Gradient(colors: [
            Color(hex: "#4A90E2"),
            Color(hex: "#00A8CC")
        ]),
        startPoint: .leading,
        endPoint: .trailing
    )
}

// MARK: - Color Extensions

extension Color {
    // Harbor palette
    static let harborPrimary = Color(hex: "#4A90E2")
    static let harborDark = Color(hex: "#1B4965")
    static let harborAccent = Color(hex: "#00A8CC")
    static let harborLight = Color(hex: "#F0F8FF")
    
    // Status colors
    static let harborSuccess = Color(hex: "#27AE60")
    static let harborWarning = Color(hex: "#FF9500")
    static let harborError = Color(hex: "#FF6B6B")
}

// MARK: - Font Extensions

extension Font {
    static let harborTitle = Font.system(size: 32, weight: .bold, design: .default)
    static let harborHeadline = Font.system(size: 18, weight: .bold, design: .default)
    static let harborSubheadline = Font.system(size: 16, weight: .semibold, design: .default)
    static let harborBody = Font.system(size: 16, weight: .regular, design: .default)
    static let harborCaption = Font.system(size: 12, weight: .regular, design: .default)
    static let harborCaptionBold = Font.system(size: 12, weight: .semibold, design: .default)
}

// MARK: - Spacing Constants

struct HarborSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
}

// MARK: - Corner Radius Constants

struct HarborRadius {
    static let small: CGFloat = 6
    static let medium: CGFloat = 10
    static let large: CGFloat = 14
    static let xl: CGFloat = 20
}
