import SwiftUI

struct AddCartItemView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var inventoryStore: InventoryStore
    @EnvironmentObject var shoppingListStore: ShoppingListStore
    @State private var recommendedItems: [String] = []
    @State private var name: String = ""
    @State private var quantity: Int = 1
    
    var onSave: (_ name: String, _ quantity: Int) -> Void
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && quantity > 0
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Grocery Details")) {
                    TextField("Grocery Name", text: $name)
                    Stepper(value: $quantity, in: 1...10000) {
                            Text("Quantity: \(quantity)")
                    }
                }
                if !recommendedItems.isEmpty {
                    Section(header: Text("Recently Consumed")) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(recommendedItems, id: \.self) { item in
                                    Button(action: {
                                        self.name = item
                                    }) {
                                        Text(item)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.blue.opacity(0.1))
                                            .foregroundColor(.blue)
                                            .clipShape(Capsule())
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Add New Grocery Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {    
                        onSave(name, quantity)
                        dismiss()
                    }
                    .disabled(!isFormValid) 
                }
            }
            .onAppear {
                self.recommendedItems = getRecommendations(
                    inventoryHistory: inventoryStore.history, 
                    currentCart: shoppingListStore.cartItems
                )
            }
        }
    }
}