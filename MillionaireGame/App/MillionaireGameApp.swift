import SwiftUI
import Firebase

@main
struct MillionaireGameApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}
