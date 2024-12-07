import SwiftUI

struct DrinkDetails: View {
    @Binding var drink: DrinkOption // Bind to the drink for live updates
    @State private var localOpinion: Bool? // Local state to manage thumbs UI

    var body: some View {
        ZStack {
            // Set the background to black
            Color.black.ignoresSafeArea()

            VStack {
                DrinkDetailsView(drink: drink)

                // Thumbs Up and Thumbs Down buttons
                HStack {
                    // Thumbs Up Button
                    Button(action: {
                        localOpinion = (localOpinion == true) ? nil : true // Toggle state
                    }) {
                        Image(systemName: localOpinion == true ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(localOpinion == true ? .green : .gray)
                            .padding()
                    }

                    Spacer()

                    // Thumbs Down Button
                    Button(action: {
                        localOpinion = (localOpinion == false) ? nil : false // Toggle state
                    }) {
                        Image(systemName: localOpinion == false ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(localOpinion == false ? .red : .gray)
                            .padding()
                    }
                }
                .padding()
            }
        }
        .onAppear {
            // Sync local state with the Binding when the view appears
            localOpinion = drink.opinion
        }
        .onDisappear {
            // Commit changes to the Binding when the view disappears
            drink.opinion = localOpinion
        }
    }
}
