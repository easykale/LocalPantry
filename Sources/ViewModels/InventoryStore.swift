import Foundation
import SwiftUI

class InventoryStore: ObservableObject{

    @Published var items: [InventoryItem] = []
    @Published var history: [TransactionLog] = [] 
    
    init() {
        self.items = Service.load(using: PersistenceManager.loadItems, toRead:  "items", as: InventoryItem.self) 
        self.history = Service.load(using: PersistenceManager.loadHistory, toRead: "history", as: TransactionLog.self)
        print("Store initalised")
        debugTools()
    }
    
    func addItem(UUID: String, name: String, serial: String? = nil, quantity: Int, expiry: Date? = nil) {
        let cleanExpiryDate: Date? = expiry.map { Calendar.current.startOfDay(for: $0) }

        let newItem: InventoryItem = InventoryItem(
            id: UUID,
            name: name,
            serialNumber: serial,
            quantity: quantity,
            expiryDate: cleanExpiryDate
        )

        if !trymergeDuplicateItems(item: newItem){
        items.append(newItem)
        }

        logTransaction(
            type: .Add,
            item: newItem,
            qtyChanged: quantity
        )
        
        Service.saveOrAppend(PersistenceManager.save, items, to: "items")
        debugTools()
    }

    func removeItem(item: InventoryItem, quantityToRemove: Int) {
        guard let index: Array<InventoryItem>.Index = items.firstIndex(where: { $0.id == item.id }) else { return }
        let newQuantity: Int = items[index].quantity - quantityToRemove
        
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
        debugTools()
    }

    func filterAndSortItems(query: String, by option: InventoryFilter.SortOption) -> [InventoryItem] {
        let sorted = InventoryFilter.sortfilter(self.items, option)

        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { 
            return sorted 
        }
        return sorted.filter {item in
        item.name.localizedCaseInsensitiveContains(query)
        }
    }

    func updateItem(item: InventoryItem, newName: String, newSerialNumber: String?, newExpiryDate: Date?) {
        guard let index: Array<InventoryItem>.Index = items.firstIndex(where: { $0.id == item.id }) else { return }

        let cleanExpiryDate = newExpiryDate.map { Calendar.current.startOfDay(for: $0) }

        items[index].name = newName
        items[index].serialNumber = newSerialNumber
        items[index].expiryDate = cleanExpiryDate

        if trymergeDuplicateItems(item: items[index]) {
            items.remove(at: index)
        }

        Service.saveOrAppend(PersistenceManager.save, items, to: "items")
        debugTools()
    }

    private func trymergeDuplicateItems(item: InventoryItem) -> Bool {
        guard let index: Array<InventoryItem>.Index = self.items.firstIndex(where: {
            $0.id != item.id &&
            $0.name.lowercased() == item.name.lowercased() &&
            $0.expiryDate == item.expiryDate &&
            $0.serialNumber == item.serialNumber
        }) else {
            return false
        }
        self.items[index].quantity += item.quantity
        return true
    }

    private func logTransaction(type: Flow, item: InventoryItem, qtyChanged: Int) {
        let log: TransactionLog = TransactionLog(
            timestamp: Date(), 
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