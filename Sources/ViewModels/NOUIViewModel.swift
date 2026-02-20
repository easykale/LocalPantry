import Foundation
import SwiftUI
class InventoryStore: ObservableObject{

    @Published var items: [InventoryItem] = []
    @Published var history: [TransactionLog] = [] //use as a stack
    
    init() {
        self.items = Service.load(using: PersistenceManager.loadItems, toRead:  "items", as: InventoryItem.self) 
        self.history = Service.load(using: PersistenceManager.loadHistory, toRead: "history", as: TransactionLog.self)
    }
    
    func addItem(UUID: String, name: String, serial: String? = nil, quantity: Int, expiry: String? = nil) {
        let newItem: InventoryItem = InventoryItem(
            id: UUID,
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
        
        Service.saveOrAppend(PersistenceManager.save, items, to: "items")
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
        
        Service.saveOrAppend(PersistenceManager.save, items, to: "items")
    }

    private func logTransaction(type: Flow, item: InventoryItem, qtyChanged: Int) {
        let log: TransactionLog = TransactionLog(
            timestamp: Date(), //time in UTC, need to use DateFormatter() for output
            type: type,
            itemName: item.name,
            serialNumber: item.serialNumber,
            quantityChanged: qtyChanged
        )

        history.append(log)
        Service.saveOrAppend(PersistenceManager.append, history, to: "history")
    }

    func debugTools() {
        print(history)
        print(items)
    }

}