import Foundation

struct DrinkOption: Identifiable, Codable, Equatable {
    var id: String
    let name: String
    let description: [String]
    let abv: String
    let ingredients: [String]
    let complexity: String
    let glassType: String
    let imageName: String
    var isSelected: Bool = false // Tracks whether the drink has been selected
    var opinion: Bool? = nil // Optional Bool to allow "no opinion" state
}

class DrinkOptionsStorage {
    private let storageKey = "drinkOptions"

    // Save the drink options to UserDefaults
    func saveOptions(_ options: [DrinkOption]) {
        if let encoded = try? JSONEncoder().encode(options) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    // Load the drink options from UserDefaults
    func loadOptions() -> [DrinkOption] {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([DrinkOption].self, from: data) {
            return decoded
        }
        return [] // Return an empty array if no data exists
    }
}


