import SwiftUI

struct WaveAnimation: View {
    let progress: Double
    @State private var waveOffset: CGFloat = 0
    
    var body: some View {
        Canvas { context, size in
            let waveHeight = size.height * 0.15
            let waveWidth = size.width * 1.5
            
            // Calculate wave position based on progress
            let waterLevel = size.height * (1 - progress)
            
            // Create wave path
            var wavePath = Path()
            wavePath.move(to: CGPoint(x: 0, y: waterLevel))
            
            for x in stride(from: 0, through: size.width, by: 2) {
                let relativeX = (x + waveOffset) / waveWidth
                let sine = sin(relativeX * .pi * 2)
                let y = waterLevel - (sine * waveHeight)
                wavePath.addLine(to: CGPoint(x: x, y: y))
            }
            
            // Close the path
            wavePath.addLine(to: CGPoint(x: size.width, y: size.height))
            wavePath.addLine(to: CGPoint(x: 0, y: size.height))
            wavePath.closeSubpath()
            
            // Draw wave
            context.fill(
                wavePath,
                with: .color(HarborColors.harborBlue.opacity(0.7))
            )
            
            // Draw second wave layer for depth
            var wavePath2 = Path()
            wavePath2.move(to: CGPoint(x: 0, y: waterLevel + waveHeight * 0.5))
            
            for x in stride(from: 0, through: size.width, by: 2) {
                let relativeX = (x + waveOffset + waveWidth * 0.25) / waveWidth
                let sine = sin(relativeX * .pi * 2)
                let y = waterLevel + (waveHeight * 0.5) - (sine * waveHeight * 0.8)
                wavePath2.addLine(to: CGPoint(x: x, y: y))
            }
            
            wavePath2.addLine(to: CGPoint(x: size.width, y: size.height))
            wavePath2.addLine(to: CGPoint(x: 0, y: size.height))
            wavePath2.closeSubpath()
            
            context.fill(
                wavePath2,
                with: .color(HarborColors.accentTeal.opacity(0.5))
            )
        }
        .background(HarborColors.lightWave)
        .onAppear {
            startWaveAnimation()
        }
    }
    
    private func startWaveAnimation() {
        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
            waveOffset = -CGFloat.pi * 2 * 50
        }
    }
}

#Preview {
    WaveAnimation(progress: 0.45)
        .frame(height: 200)
}
