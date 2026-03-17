import SwiftUI

@main
struct HarborApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .preferredColorScheme(nil)
        }
    }
}
