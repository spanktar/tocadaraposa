import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            // Background color
            Color.black
                .ignoresSafeArea() // Ensures the background covers the entire screen

            // Centered logo with manual vertical adjustment
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 300) // Set width to 300px
                .offset(y: -10) // Adjust vertical position by moving it up 10 points
        }
    }
}
