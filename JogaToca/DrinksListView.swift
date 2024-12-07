import SwiftUI

struct DrinksListView: View {
    @Binding var options: [DrinkOption] // The full list of drinks
    let resetHandler: (@escaping () -> Void) -> Void // Accept resetHandler closure

    var body: some View {
        ZStack {
            // Black background for the entire screen
            Color.black.ignoresSafeArea()

            List {
                // Section for drinks already had
                Section(header: headerView(title: "Drinks You've Had Already")) {
                    ForEach(options.indices.filter { options[$0].isSelected }, id: \.self) { index in
                        NavigationLink(destination: DrinkDetails(drink: $options[index])) {
                            drinkRow(options[index])
                        }
                        .listRowBackground(Color.black) // Set background color for the row
                    }
                }


                // Section for drinks you haven't had
                Section(header: headerView(title: "Drinks You Haven't Had Yet")) {
                    ForEach(options.indices.filter { !options[$0].isSelected }, id: \.self) { index in
                        NavigationLink(destination: DrinkDetails(drink: $options[index])) {
                            drinkRow(options[index])
                        }
                        .listRowBackground(Color.black) // Set background color for the row
                    }
                }

                // Reset All Button as a List Footer
                Section {
                    Button(action: {
                        resetHandler {} // No additional view-specific state to reset here
                    }) {
                        Text("Reset All")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .listRowBackground(Color.black) // Match the button's background to the list
                    .padding(.top, 10)
                }
            }
            .listStyle(InsetGroupedListStyle()) // Ensure consistent layout
            .scrollContentBackground(.hidden) // Hide the default white List background
        }
        .navigationBarTitle("Drinks List", displayMode: .inline) // Optional navigation bar title
        .onAppear {
            // Apply custom navigation bar appearance
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.black
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    // Custom header view for sections
    private func headerView(title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.white)
            .padding(.vertical, 5)
            .background(Color.black) // Ensure the header background is black
    }

    private func drinkRow(_ drink: DrinkOption) -> some View {
        HStack {
            if !drink.imageName.isEmpty {
                Image(drink.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
            
            VStack(alignment: .leading) {
                Text(drink.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text("ABV: \(drink.abv)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer() // Push thumbs to the right side

            // Display thumbs up/down if opinion is not nil
            if let opinion = drink.opinion {
                Image(systemName: opinion ? "hand.thumbsup.fill" : "hand.thumbsdown.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(opinion ? .green : .red)
            }
        }
        .padding(.vertical, 5) // Add padding for better spacing
        .listRowBackground(Color.black) // Match row background to the list
    }

}
