import SwiftUI

struct EditCartItemView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var quantity: Int

    private let originalQuantity: Int

    init(item: CartItem, onSave: @escaping (String, Int) -> Void) {
        self._name = State(initialValue: item.name)
        self._quantity = State(initialValue: item.quantity)
        self.originalQuantity = item.quantity
        self.onSave = onSave
    }

    var onSave: (_ name: String, _ quantity: Int) -> Void
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Item Name")) {
                    TextField("Item Name", text: $name)
                }
                Section(header: Text("Item Information")) {
                    Stepper(value: $quantity, in: originalQuantity...10000) {
                        Text("Quantity: \(quantity)")
                    }
                }
            }
            .navigationTitle("Edit Item")
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
        }
    }
}