import SwiftUI

struct AboutView: View {
    var body: some View {
        ZStack {
            // Black background for the entire screen
            Color.black
                .ignoresSafeArea()

            VStack(alignment: .center, spacing: 20) {
                // App title
                Text("Toca Da Raposa")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
                    .multilineTextAlignment(.center)

                // Instagram follow text
                VStack(spacing: 5) {
                    Text("Follow us on Instagram")
                        .font(.headline)
                        .foregroundColor(.white)

                    Button(action: {
                        // Try to open Instagram app first
                        if let appURL = URL(string: "instagram://user?username=tocaraposa.cocktail"),
                           UIApplication.shared.canOpenURL(appURL) {
                            UIApplication.shared.open(appURL)
                        } else if let webURL = URL(string: "https://www.instagram.com/tocaraposa.cocktail/") {
                            // Fallback to web browser if Instagram is not installed
                            UIApplication.shared.open(webURL)
                        }
                    }) {
                        Text("Visit Instagram")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }

                // App logo
                Image("logo") // Replace "logo" with the actual image name in Assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)

                // App motto
                Text("Aquela que volta amigo fica")
                    .font(.title2)
                    .foregroundColor(.white)
                    .italic()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                Spacer()

                // Footer text
                Text("attribution_text")
                     .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
            }
            .padding()
        }
    }
}
