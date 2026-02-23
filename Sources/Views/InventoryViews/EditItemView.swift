import SwiftUI

struct EditItemView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var serialNumber: String
    @State private var hasExpiry: Bool
    @State private var expiryDate: Date

    init(item: InventoryItem, onSave: @escaping (String, String?, Date?) -> Void){
        self._name = State(initialValue: item.name)

        if let existingSerialNumber = item.serialNumber {
            self._serialNumber = State(initalValue: existingSerialNumber)
        } else {
            self._serialNumber = State(initalValue: "")
        }

        if let existingExpiryDate = item.expiryDate {
            self._expiryDate = State(initialValue: existingExpiryDate)
            self._hasExpiry = State(initiialValue: true)
        } else {
            self._expiryDate = State(initialValue: Date())
            self._hasExpiry = State(initialValue: false)
        }

        self.onSave = onSave
    }

    var onSave: (_ name: String, _ serialNumber: String?, _ expiryDate: Date?) -> Void
    
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

                Section(header: Text("Expiry Information")) {
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
                        
                        onSave(name, finalSerial, finalExpiry)
                        dismiss()
                    }
                    .disabled(!isFormValid) 
                }
            }
        }
    }
}