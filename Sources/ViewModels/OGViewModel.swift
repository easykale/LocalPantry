import Foundation
import SwiftUI
class InventoryStore: ObservableObject{

    @Published var items: [InventoryItem] = []
    @Published var history: [TransactionLog] = [] //use as a stack
    
    init() {
        self.items = Service.load(using: PersistenceManager.loadItems, toRead:  "items", as: InventoryItem.self) 
        self.history = Service.load(using: PersistenceManager.loadHistory, toRead: "history", as: TransactionLog.self)
        print("Store initalised")
    }
    
    func addItem(UUID: String, name: String, serial: String? = nil, quantity: Int, expiry: Date? = nil) {
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
        print("\(items)")
    }

    func removeItem(item: InventoryItem, quantityToRemove: Int) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        let newQuantity = items[index].quantity - quantityToRemove
        
        if newQuantity <= 0 {
            items.remove(at: index)
        } else {
            items[index].quantity = newQuantity
        }
        
        logTransaction(
            type: .Remove,
            item: item,
            qtyChanged: quantityToRemove
        )
        
        Service.saveOrAppend(PersistenceManager.save, items, to: "items")
        print("\(items)")
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