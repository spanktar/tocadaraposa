import SwiftUI

struct DrinksListView: View {
    @Binding var options: [DrinkOption] // The full list of drinks

    var body: some View {
        ZStack {
            // Black background for the entire screen
            Color.black
                .ignoresSafeArea()

            List {
                // Section for drinks already had
                Section(header: headerView(title: "Drinks You've Had Already")) {
                    ForEach(options.filter { $0.isSelected }) { drink in
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
                                    .foregroundColor(.white) // White text
                                Text("ABV: \(drink.abv)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray) // Subtle gray text
                            }
                        }
                        .listRowBackground(Color.black) // Set each row's background to black
                    }
                }

                // Section for drinks you haven't had
                Section(header: headerView(title: "Drinks You Haven't Had Yet")) {
                    ForEach(options.filter { !$0.isSelected }) { drink in
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
                                    .foregroundColor(.white) // White text
                                Text("ABV: \(drink.abv)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray) // Subtle gray text
                            }
                        }
                        .listRowBackground(Color.black) // Set each row's background to black
                    }
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
}
