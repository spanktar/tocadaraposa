import SwiftUI

struct DrinksListView: View {
    @Binding var options: [DrinkOption] // The full list of drinks
    let resetHandler: (@escaping () -> Void) -> Void // Accept resetHandler closure

    var body: some View {
        ZStack {
            // Black background for the entire screen
            Color.black
                .ignoresSafeArea()

            List {
                // Section for drinks already had
                Section(header: headerView(title: "Drinks You've Had Already")) {
                    ForEach(options.filter { $0.isSelected }) { drink in
                        drinkRow(drink)
                    }
                }

                // Section for drinks you haven't had
                Section(header: headerView(title: "Drinks You Haven't Had Yet")) {
                    ForEach(options.filter { !$0.isSelected }) { drink in
                        drinkRow(drink)
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
        }
        .listRowBackground(Color.black)
    }
}
