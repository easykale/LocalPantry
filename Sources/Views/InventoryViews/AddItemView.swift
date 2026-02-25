import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var serialNumber: String = ""
    @State private var quantity: Int = 1
    @State private var hasExpiry: Bool = true
    @State private var expiryDate: Date = Date()
    
    var onSave: (_ name: String, _ serialNumber: String?, _ quantity: Int, _ expiryDate: Date?) -> Void
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && quantity > 0
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Item Details")) {
                    TextField("Item Name", text: $name)
                    TextField("Serial Number (Optional)", text: $serialNumber)
                }
                
                Section(header: Text("Item Information")) {
                    Stepper(value: $quantity, in: 1...10000) {
                        Text("Quantity: \(quantity)")
                    }
                    
                    Toggle("Has Expiry Date?", isOn: $hasExpiry)
                    
                    if hasExpiry {
                        DatePicker(
                            "Expiry Date",
                            selection: $expiryDate,
                            displayedComponents: .date
                        )
                    }
                }
            }
            .navigationTitle("Add New Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let finalSerial = serialNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : serialNumber
                        let finalExpiry = hasExpiry ? expiryDate : nil
                        
                        onSave(name, finalSerial, quantity, finalExpiry)
                        dismiss()
                    }
                    .disabled(!isFormValid) 
                }
            }
        }
    }
}