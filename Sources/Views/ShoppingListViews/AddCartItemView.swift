import SwiftUI

struct AddCartItemView: View {
    @Environment(\.dismiss) private var dismiss
    
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
                }
                
                Section(header: Text("How many?")) {
                    Stepper(value: $quantity, in: 1...10000) {
                        Text("Quantity: \(quantity)")
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
        }
    }
}