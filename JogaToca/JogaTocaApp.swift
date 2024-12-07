import SwiftUI

@main
struct JogaTocaApp: App {
    @State private var showSplashScreen = true
    @State private var options: [DrinkOption]

    init() {
        let storage = DrinkOptionsStorage()
        let loadedOptions = storage.loadOptions()

        // Reconcile loaded options with current DrinkOptionsData
        options = JogaTocaApp.reconcileOptions(loaded: loadedOptions, current: drinkOptions)

        // Save the reconciled options to ensure UserDefaults matches
        storage.saveOptions(options)
    }

    var body: some Scene {
        WindowGroup {
            if showSplashScreen {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showSplashScreen = false
                            }
                        }
                    }
            } else {
                ContentView(options: $options, resetHandler: resetSelection)
                    .onChange(of: options) { newOptions in
                        DrinkOptionsStorage().saveOptions(newOptions)
                    }
            }
        }
    }

    private func resetSelection(clearViewState: (() -> Void)? = nil) {
        for index in options.indices {
            options[index].isSelected = false
        }
        clearViewState?() // Call the view-specific reset logic if provided
    }

    static func reconcileOptions(loaded: [DrinkOption], current: [DrinkOption]) -> [DrinkOption] {
        // Map the loaded options by ID for quick lookup
        var loadedDict = Dictionary(uniqueKeysWithValues: loaded.map { ($0.id, $0) })
        
        // Start with the current options as the base
        var reconciled: [DrinkOption] = current.map { currentOption in
            // If the drink exists in loaded data, preserve its state
            if let loadedOption = loadedDict[currentOption.id] {
                var updatedOption = currentOption
                updatedOption.isSelected = loadedOption.isSelected
                updatedOption.opinion = loadedOption.opinion // Preserve opinion
                return updatedOption
            } else {
                // If it's a new drink, return it as-is
                return currentOption
            }
        }

        return reconciled
    }
}
