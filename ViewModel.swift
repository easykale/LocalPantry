import SwiftUI

// MARK: - ViewModel (Store)

class InventoryStore: ObservableObject {
    
    // MARK: - State Properties
    // @Published ensures views reload when these arrays change
    @Published var items: [InventoryItem] = []
    @Published var history: [TransactionLog] = []
    
    // MARK: - Initialization
    init() {
        // In Sprint 1 / S1-04, we will replace this with loadJSON()
        // For now, we load empty or dummy data to ensure the setup works.
        print("InventoryStore initialized. Ready for data.")
    }
    
    func addItem(UUID: String, name: String, serial: String? = nil, quantity: Int, expiry: String? = nil) {
        let newItem = InventoryItem(
            UUID: UUID,
            name: name,
            serialNumber: serial,
            quantity: quantity,
            expiryDate: expiry
        )
        
        items.append(newItem)
    
        logTransaction(
            type: .Add,
            item: newItem,
            qtyChanged: quantity
        )
        
        saveData()
    }
    
    func removeItem(item: InventoryItem, quantityToRemove: Int) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        let currentItem = items[index]
        let newQuantity = currentItem.quantity - quantityToRemove
        
        if newQuantity <= 0 {
            items.remove(at: index)
        } else {
            var updatedItem = currentItem
            updatedItem.quantity = newQuantity
            items[index] = updatedItem
        }
        
        logTransaction(
            type: .Remove,
            item: currentItem,
            qtyChanged: quantityToRemove
        )
        
        saveData()
    }

    
    private func logTransaction(UUID: String, type: Flow, item: InventoryItem, qtyChanged: Int) {
        let log = TransactionLog(
            UUID: UUID,
            timestamp: Date(), //time in UTC, need to use DateFormatter() for output
            type: type,
            itemName: item.name,
            serialNumber: item.serialNumber,
            quantityChanged: qtyChanged
        )
        history.insert(log, at: 0)
    }
    
    // MARK: - Persistence Stubs (Ticket S1-04 Prep)
    
    func saveData() {
        // Placeholder: This will eventually write 'items' and 'history' to JSON files.
        print("Data saved (simulation). Items count: \(items.count)")
    }
    
    func loadData() {
        // Placeholder: This will read from FileManager.
    }

}