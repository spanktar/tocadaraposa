import SwiftUI
import EffectsLibrary

struct ContentView: View {
    @Binding var options: [DrinkOption] // Binding to the list of options
    @State private var rotation: Double = 0 // Tracks the rotation of the button
    @State private var selectedOption: DrinkOption? // Tracks the selected option
    @State private var isSpinning: Bool = false // Prevents multiple clicks during spinning
    @State private var showCongratulations = false // Tracks if all drinks have been selected
    @State private var showDrinksList = false
    
    let resetHandler: (@escaping () -> Void) -> Void

    var body: some View {
        NavigationView { // Wrap everything in a NavigationView
            ZStack {
                // Background color
                Color.black
                    .ignoresSafeArea()

                // Main content
                if showCongratulations {

                    FireworksView()

                    VStack {
                        Text("Congratulations!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.yellow)
                            .multilineTextAlignment(.center)
                            .padding()

                        Text("You've had every drink on the menu!")
                            .font(.title2)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()

                        Button(action: {
                            resetHandler {
                                showCongratulations = false
                                selectedOption = nil
                            }
                        }) {
                            Text("Start Over")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.yellow)
                                .cornerRadius(8)
                        }
                        .padding(.top, 20)
                    }
                } else {
                    VStack {
                        // Button Section (Pinned to the Top)
                        Button(action: {
                            startSpinning() // Start the spin animation
                        }) {
                            Image("button") // Replace with your image asset
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .rotationEffect(.degrees(rotation)) // Apply rotation
                                .animation(
                                    .interpolatingSpring(stiffness: 20, damping: 5)
                                    .speed(isSpinning ? 1 : 0),
                                    value: rotation
                                )
                        }
                        .disabled(isSpinning) // Disable the button while spinning
                        .frame(maxWidth: .infinity, alignment: .top) // Align button at the top
                        .padding(.top, 9) // Add padding to move the button slightly down from the top edge
                        .background(Color.black)
                        .buttonStyle(PlainButtonStyle()) // Remove any default button styling

                        if let optionIndex = options.firstIndex(where: { $0.id == selectedOption?.id }) {
                            VStack(alignment: .center, spacing: 9) {
                                // Drink name
                                Text(selectedOption!.name)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.yellow)
                                    .multilineTextAlignment(.center)

                                // Drink image
                                if !selectedOption!.imageName.isEmpty {
                                    Image(selectedOption!.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 150)
                                }

                                // Two columns: Description and Ingredients
                                HStack(alignment: .top) {
                                    // Description column
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("Description:")
                                            .font(.subheadline)
                                            .fontWeight(.bold) // Make the label bold
                                            .foregroundColor(.white)
                                        ForEach(selectedOption!.description, id: \.self) { description in
                                            Text("- \(description)")
                                                .font(.subheadline)
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                    // Ingredients column
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("Ingredients:")
                                            .font(.subheadline)
                                            .fontWeight(.bold) // Make the label bold
                                            .foregroundColor(.white)
                                        ForEach(selectedOption!.ingredients, id: \.self) { ingredient in
                                            Text("- \(ingredient)")
                                                .font(.subheadline)
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.top, 9) // Add some space between the columns and the rest of the content

                                // ABV and Complexity
                                Text("ABV: \(selectedOption!.abv)")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .padding(.top, 6)

                                Text("Complexity: \(selectedOption!.complexity)")
                                    .font(.subheadline)
                                    .foregroundColor(.white)

                                // "I'll take one!" Button
                                Button(action: {
                                    // Mark the selected drink as "already selected"
                                    options[optionIndex].isSelected = true
                                    selectedOption = nil // Clear the current selection
                                }) {
                                    Text("I'll take one!")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.yellow)
                                        .cornerRadius(8)
                                }
                                .padding(.top, 9)
                            }
                            .padding()
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity)
                        }


                        Spacer() // Push everything else to the top
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // Ensure everything stays at the top
                }

                // Floating buttons (Drinks button on the right, About button on the left)
                VStack {
                    HStack {
                        // About button (top-left corner)
                        NavigationLink(destination: AboutView()) {
                            Image(systemName: "questionmark.circle.fill") // Question mark icon
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .padding(10)
                                .foregroundColor(.yellow)
                        }
                        .background(Color.black.opacity(1.0)) // Circle with a black background
                        .buttonStyle(PlainButtonStyle()) // Remove default button styling
                        .clipShape(Circle())
                        .padding(.top, 0) // Adjust the distance from the top
                        .padding(.leading, 20) // Adjust the distance from the left

                        Spacer() // Pushes the drinks button to the far right

                        // Drinks button (top-right corner)
                        NavigationLink(destination: DrinksListView(options: $options, resetHandler: resetHandler)) {
                            Image(systemName: "wineglass.fill") // Cocktail glass icon
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .padding(10)
                                .foregroundColor(.yellow)
                        }
                        .background(Color.black.opacity(1.0)) // Circle with a black background
                        .buttonStyle(PlainButtonStyle()) // Remove default button styling
                        .clipShape(Circle())
                        .padding(.top, 0) // Adjust the distance from the top
                        .padding(.trailing, 20) // Adjust the distance from the right
                    }

                    Spacer() // Push the buttons to the top
                }

            }
            .navigationBarHidden(true) // Hide the navigation bar for the main view
        }
    }

    // MARK: - Spinning Animation
    @State private var currentOption: DrinkOption? // Tracks the currently displayed option

    private func startSpinning() {
        // Filter out selected options
        let unselectedOptions = options.filter { !$0.isSelected }
        guard !unselectedOptions.isEmpty else {
            // Show congratulations screen if all options are selected
            showCongratulations = true
            return
        }

        isSpinning = true // Prevent multiple presses
        let spinCount = Double.random(in: 3...6) // Randomize the number of spins

        withAnimation(Animation.linear(duration: 2)) {
            rotation += spinCount * 360 // Spin multiple times
        }

        // Delay revealing the choice
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            stopSpinning(unselectedOptions: unselectedOptions)
        }
    }

    private func stopSpinning(unselectedOptions: [DrinkOption]) {
        isSpinning = false

        // Filter out the current option unless there’s only one option left
        let filteredOptions = unselectedOptions.filter { $0.id != currentOption?.id }
        let newOptions = filteredOptions.isEmpty ? unselectedOptions : filteredOptions

        // Randomly select a new option from the available choices
        if let newOption = newOptions.randomElement() {
            currentOption = newOption
            selectedOption = newOption
        }
    }


//    private func resetSelection() {
//        for index in options.indices {
//            options[index].isSelected = false
//        }
//        showCongratulations = false
//        selectedOption = nil
//    }
}
