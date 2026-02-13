import Foundation
class NOUIInventoryStore{

    var items: [InventoryItem] = []
    var history: [TransactionLog] = []
    
    // MARK: - Initialization
    init() {
        // In Sprint 1 / S1-04, we will replace this with loadJSON()
        // For now, we load empty or dummy data to ensure the setup works.
        print("InventoryStore initialized. Ready for data.")
    }
    
    func addItem(UUID: String, name: String, serial: String? = nil, quantity: Int, expiry: String? = nil) {
        let newItem: InventoryItem = InventoryItem(
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
        
        PersistenceManager.save(newItem, to: "items" )
    }
    
    func removeItem(item: InventoryItem, quantityToRemove: Int) {
        guard let index = items.firstIndex(where: { $0.name == item.name }) else { return }
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
        
        //saveee
    }

    
    private func logTransaction(type: Flow, item: InventoryItem, qtyChanged: Int) {
        let log: TransactionLog = TransactionLog(
            timestamp: Date(), //time in UTC, need to use DateFormatter() for output
            type: type,
            itemName: item.name,
            serialNumber: item.serialNumber,
            quantityChanged: qtyChanged
        )

        history.insert(log, at: 0)
        
        PersistenceManager.append(log, to: "history")
    }

    func debugTools() {
        print(history)
        print(items)
    }

}