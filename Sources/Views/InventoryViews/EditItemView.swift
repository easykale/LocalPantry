import SwiftUI

struct EditItemView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var serialNumber: String
    @State private var hasExpiry: Bool
    @State private var expiryDate: Date
    @State private var quantity: Int

    private let originalQuantity: Int

    init(item: InventoryItem, onSave: @escaping (String, String?, Date?, Int) -> Void){
        self._name = State(initialValue: item.name)
        self._quantity = State(initialValue: item.quantity)
        self.originalQuantity = item.quantity

        if let existingSerialNumber = item.serialNumber {
            self._serialNumber = State(initialValue: existingSerialNumber)
        } else {
            self._serialNumber = State(initialValue: "")
        }

        if let existingExpiryDate = item.expiryDate {
            self._expiryDate = State(initialValue: existingExpiryDate)
            self._hasExpiry = State(initialValue: true)
        } else {
            self._expiryDate = State(initialValue: Date())
            self._hasExpiry = State(initialValue: false)
        }

        self.onSave = onSave
    }

    var onSave: (_ name: String, _ serialNumber: String?, _ expiryDate: Date?, _ quantity: Int) -> Void
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Item Details")) {
                    TextField("Item Name", text: $name)
                    TextField("Serial Number (Optional)", text: $serialNumber)
                }
                Section(header: Text("Item Information")) {
                    Stepper(value: $quantity, in: originalQuantity...10000) {
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
            .navigationTitle("Edit Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // Format optionals before passing back
                        let finalSerial = serialNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : serialNumber
                        let finalExpiry = hasExpiry ? expiryDate : nil
                        
                        onSave(name, finalSerial, finalExpiry, quantity)
                        dismiss()
                    }
                    .disabled(!isFormValid) 
                }
            }
        }
    }
}