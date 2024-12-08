import SwiftUI
import EffectsLibrary

struct ContentView: View {
    @Binding var options: [DrinkOption] // Binding to the list of options
    @State private var rotation: Double = 0 // Tracks the rotation of the button
    @State private var selectedOption: DrinkOption? // Tracks the selected option
    @State private var isSpinning: Bool = false // Prevents multiple clicks during spinning
    @State private var showCongratulations = false // Tracks if all drinks have been selected
    @State private var showDrinksList = false
    @State private var isPulsing = false // Track pulsing state
    @State private var showNoOptionsAlert = false // Tracks if the alert should be displayed

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
                        Button(action: {
                            startSpinning() // Start the spin animation
                        }) {
                            Image("button") // Replace with your image asset
                                .resizable()
                                .scaledToFit()
                                .frame(width: 180, height: 180)
                                .rotationEffect(.degrees(rotation)) // Apply rotation
                                .scaleEffect(isPulsing ? 1.1 : 1.0) // Scale for pulsing effect
                                .animation(
                                    .easeInOut(duration: 1).repeatForever(autoreverses: true),
                                    value: isPulsing // Pulsing animation
                                )
                                .animation(
                                    .interpolatingSpring(stiffness: 21, damping: 6)
                                        .speed(isSpinning ? 1 : 0),
                                    value: rotation // Rotation animation
                                )
                        }
                        .disabled(isSpinning) // Disable the button while spinning
                        .frame(maxWidth: .infinity, alignment: .top) // Align button at the top
                        .padding(.top, 9) // Add padding to move the button slightly down from the top edge
                        .background(Color.black)
                        .buttonStyle(PlainButtonStyle()) // Remove any default button styling
                        .onAppear {
                            isPulsing = true // Start the pulsing effect
                        }

                        if let optionIndex = options.firstIndex(where: { $0.id == selectedOption?.id }) {
                            VStack(alignment: .center, spacing: 9) {
                                // Reuse DrinkDetailsView for drink details
                                DrinkDetailsView(drink: options[optionIndex])

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
            .alert(isPresented: $showNoOptionsAlert) {
                Alert(
                    title: Text("No More Choices"),
                    message: Text("There are no more drinks that you haven't marked as 'dislike'."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    // MARK: - Spinning Animation
    @State private var currentOption: DrinkOption? // Tracks the currently displayed option

    private func startSpinning() {
        // Filter out selected options

        let allDrinksSelected = options.allSatisfy { $0.isSelected }
        if allDrinksSelected {
            // Show congratulations screen if all drinks are selected
            showCongratulations = true
            return
        }
        let unselectedOptions = options.filter { !$0.isSelected && $0.opinion != false }

        if unselectedOptions.isEmpty {
            showNoOptionsAlert = true
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
}
