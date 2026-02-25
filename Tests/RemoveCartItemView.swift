import SwiftUI

struct RemoveCartItemView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var quantityToRemove: Int = 1
    let item: CartItem

    var onRemove: (_ quantity: Int) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Remove")) {
                    Text("Current Quantity: \(item.quantity)")
                        .foregroundColor(.secondary)
                    
                    Stepper(value: $quantityToRemove, in: 1...item.quantity) {
                        Text("Quantity to remove: \(quantityToRemove)")
                            .fontWeight(.medium)
                    }
                }
            }
            .navigationTitle("Remove \(item.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Confirm") {
                        onRemove(quantityToRemove)
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
}