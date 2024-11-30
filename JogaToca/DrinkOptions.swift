import Foundation

struct DrinkOption: Identifiable {
    let id = UUID() // Unique identifier for each option
    let name: String
    let description: [String]
    let abv: String
    let ingredients: [String]
    let complexity: String
    let imageName: String
    var isSelected: Bool = false // Tracks whether the drink has been selected
}
