import Foundation
import UIKit
import CoreMotion

class AmbientLightManager: NSObject, ObservableObject {
    @Published var brightness: Double = 0.5
    @Published var isDarkMode: Bool = false
    
    private let motionManager = CMMotionManager()
    private var lastUpdate: Date = Date()
    private let updateInterval: TimeInterval = 0.5
    
    override init() {
        super.init()
        setupAmbientLightDetection()
        detectInitialBrightness()
    }
    
    private func setupAmbientLightDetection() {
        // Monitor device brightness and orientation to infer ambient light
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screenBrightnessDidChange),
            name: UIScreen.brightnessDidChangeNotification,
            object: nil
        )
        
        // Monitor light level changes through device orientation
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.5
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] _, _ in
                self?.evaluateAmbientLight()
            }
        }
    }
    
    @objc private func screenBrightnessDidChange() {
        evaluateAmbientLight()
    }
    
    private func evaluateAmbientLight() {
        let now = Date()
        guard now.timeIntervalSince(lastUpdate) >= updateInterval else { return }
        lastUpdate = now
        
        // Get device screen brightness as a proxy for ambient light
        let screenBrightness = UIScreen.main.brightness
        
        // Calculate adaptive brightness (inverted logic: if screen is very bright,
        // user is likely in bright environment, so we increase reading brightness slightly)
        let ambientBrightness = screenBrightness * 0.6 + 0.4
        
        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.brightness = ambientBrightness
                
                // Determine dark mode based on time of day and brightness
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: Date())
                let isNightTime = hour < 6 || hour > 20
                
                // If it's night time or screen is very dim, enable dark mode
                self.isDarkMode = isNightTime || screenBrightness < 0.3
            }
        }
    }
    
    private func detectInitialBrightness() {
        evaluateAmbientLight()
    }
    
    // Manual brightness override
    func setBrightness(_ value: Double) {
        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.brightness = max(0.1, min(1.0, value))
            }
        }
    }
    
    func toggleDarkMode() {
        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.isDarkMode.toggle()
            }
        }
    }
    
    deinit {
        motionManager.stopDeviceMotionUpdates()
        NotificationCenter.default.removeObserver(self)
    }
}
