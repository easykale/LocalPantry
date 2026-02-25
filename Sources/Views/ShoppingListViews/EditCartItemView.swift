import SwiftUI

struct EditCartItemView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name: String

    init(item: CartItem, onSave: @escaping (String) -> Void) {
        self._name = State(initialValue: item.name)

        self.onSave = onSave
    }

    var onSave: (_ name: String) -> Void
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Item Name")) {
                    TextField("Item Name", text: $name)
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
                        onSave(name)
                        dismiss()
                    }
                    .disabled(!isFormValid) 
                }
            }
        }
    }
}