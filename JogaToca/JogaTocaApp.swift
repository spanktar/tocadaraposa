import SwiftUI

@main
struct JogaTocaApp: App {
    @State private var showSplashScreen = true // State to control splash visibility
    @State private var options = drinkOptions // Load predefined drink options

    var body: some Scene {
        WindowGroup {
            if showSplashScreen {
                SplashView()
                    .onAppear {
                        // Show the splash screen for 2 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                showSplashScreen = false
                            }
                        }
                    }
            } else {
                ContentView(options: $options)
            }
        }
    }
}
