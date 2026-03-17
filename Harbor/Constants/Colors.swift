import SwiftUI

struct HarborColors {
    // Primary brand colors - ocean/harbor theme
    static let harborBlue = Color(red: 0.29, green: 0.56, blue: 0.89) // #4A90E2
    static let darkHarbor = Color(red: 0.11, green: 0.29, blue: 0.40) // #1B4965
    static let accentTeal = Color(red: 0.20, green: 0.76, blue: 0.80) // #33C3CC
    static let lightWave = Color(red: 0.95, green: 0.98, blue: 1.0) // #F2FAFF
    static let softGray = Color(red: 0.94, green: 0.94, blue: 0.95) // #F0F0F2
    
    // Semantic colors
    static let background = Color(UIColor.systemBackground)
    static let foreground = Color(UIColor.label)
    static let secondaryForeground = Color(UIColor.secondaryLabel)
    
    // Text colors
    static let textPrimary = darkHarbor
    static let textSecondary = Color(red: 0.40, green: 0.40, blue: 0.44) // #666B6F
}
