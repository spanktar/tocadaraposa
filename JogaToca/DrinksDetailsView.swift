import SwiftUI

struct DrinkDetailsView: View {
    let drink: DrinkOption // The drink to display

    var body: some View {
        VStack(alignment: .center, spacing: 9) {
            // Drink name
            Text(drink.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.yellow)
                .multilineTextAlignment(.center)

            // Drink image
            if !drink.imageName.isEmpty {
                Image(drink.imageName)
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
                    ForEach(drink.description, id: \.self) { description in
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
                    ForEach(drink.ingredients, id: \.self) { ingredient in
                        Text("- \(ingredient)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.top, 9) // Add some space between the columns and the rest of the content

            // ABV and Complexity
            Text("ABV: \(drink.abv)")
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.top, 6)

            Text("Complexity: \(drink.complexity)")
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: 300)
        .frame(maxWidth: .infinity)
    }
}
