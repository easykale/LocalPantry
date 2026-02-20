import SwiftUI

class dummyInventoryStore: ObservableObject {
    @Published var items: [InventoryItem] = []
    
    init(preview: Bool = false) {
        if preview {
            // Using Strings for expiryDate to match your updated struct!
            items = [
                InventoryItem(id: "kms", name: "Sterile Gauze", serialNumber: "SG-90210", quantity: 50, expiryDate: "15/12/2026"),
                InventoryItem(id: "ihateswift",name: "Epinephrine Auto-Injector", serialNumber: "EPI-404", quantity: 2, expiryDate: "01/03/2026"),
                InventoryItem(id: "swiftisanigger",name: "Medical Tape", serialNumber: nil, quantity: 15, expiryDate: nil) 
                //Example of a missing expiry 
            ]
        }
    }
}