import SwiftUI

struct PageTransitionModifier: ViewModifier {
    var isActive: Bool
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isActive ? 1.0 : 0.98)
            .opacity(isActive ? 1.0 : 0.9)
            .animation(.easeInOut(duration: 0.3), value: isActive)
    }
}

struct PulseAnimation: View {
    @State private var isPulsing = false
    
    var body: some View {
        Circle()
            .fill(HarborColors.accentTeal)
            .scaleEffect(isPulsing ? 1.0 : 0.8)
            .opacity(isPulsing ? 0.3 : 0.6)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    isPulsing = true
                }
            }
    }
}

struct ShimmerEffect: View {
    @State private var shimmerPosition: CGFloat = -1
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.white.opacity(0),
                Color.white.opacity(0.3),
                Color.white.opacity(0)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
        .offset(x: shimmerPosition * 100)
        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                shimmerPosition = 1
            }
        }
    }
}

extension View {
    func pageTransition(_ isActive: Bool) -> some View {
        modifier(PageTransitionModifier(isActive: isActive))
    }
}

// Smooth corner radius with shadow for reading cards
struct ReadingCardStyle: ViewModifier {
    var isDarkMode: Bool
    
    func body(content: Content) -> some View {
        content
            .cornerRadius(14)
            .shadow(color: HarborColors.darkHarbor.opacity(isDarkMode ? 0.3 : 0.08), radius: 8, x: 0, y: 4)
    }
}

extension View {
    func readingCardStyle(isDarkMode: Bool = false) -> some View {
        modifier(ReadingCardStyle(isDarkMode: isDarkMode))
    }
}

// Haptic feedback helper
struct HapticFeedback {
    static func light() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    static func medium() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    static func success() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
    }
    
    static func warning() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.warning)
    }
}
