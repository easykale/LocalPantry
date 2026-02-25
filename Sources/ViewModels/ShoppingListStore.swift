import Foundation
import SwiftUI

class ShoppingListStore: ObservableObject {

    @Published var cartItems: [CartItem] = []
    
    init() {
        self.cartItems = Service.load(using: PersistenceManager.loadItems, toRead: "cart", as: CartItem.self)
        debugTools()
    }
    
    func addItem(name: String, quantity: Int = 1) {
        let newItem = CartItem(
            id: UUID().uuidString, 
            name: name, 
            quantity: quantity, 
            isChecked: false
            )
        if !trymergeDuplicateItems(item: newItem) {
            cartItems.append(newItem)
        }

        save()
        debugTools()
    }
    
    func toggleItem(_ item: CartItem) {
        guard let index = cartItems.firstIndex(where: { $0.id == item.id }) else { return }

        cartItems[index].isChecked.toggle()

        save()
        debugTools()
    }
    
    func removeItem(item: CartItem) {
        guard let index = cartItems.firstIndex(where: { $0.id == item.id }) else { return }
        
        cartItems.remove(at: index)
        save()
        debugTools()
    }

    func updateItem(item: CartItem, newName: String, newQuantity: Int) {
        guard let index = cartItems.firstIndex(where: { $0.id == item.id }) else { return }

        cartItems[index].name = newName
        cartItems[index].quantity = newQuantity

        if trymergeDuplicateItems(item: cartItems[index]) {
            cartItems.remove(at: index)
        }

        save()
        debugTools()
    }
    
    func clearCompleted() {
        cartItems.removeAll { $0.isChecked }
        save()
        debugTools()
    }

    func filterAndSortItems(query: String, by option: ShoppingListFilter.SortOption) -> [CartItem] {
        let sorted = ShoppingListFilter.sortfilter(self.cartItems, option)

        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { 
            return sorted 
        }
        return sorted.filter {item in
        item.name.localizedCaseInsensitiveContains(query)
        }
    }

    func getRecommendations(inventoryHistory: [TransactionLog]) -> [RecommendedItem] {
        let calendar = Calendar.current
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        
        let recentRemovals = inventoryHistory.filter { log in
            log.type == .Remove && log.timestamp >= sevenDaysAgo
        }
        
        var consumedQuantities: [String: Int] = [:]
        for log in recentRemovals {
            consumedQuantities[log.itemName, default: 0] += log.quantityChanged
        }
        
        let currentCartNames = Set(self.cartItems.map { $0.name.lowercased() })
        
        let recommendations = consumedQuantities.compactMap { (name, totalQuantity) -> RecommendedItem? in
            if currentCartNames.contains(name.lowercased()) {
                return nil
            }
            return RecommendedItem(name: name, quantity: totalQuantity)
        }

        return recommendations.sorted { $0.name < $1.name }
    }
    
    private func trymergeDuplicateItems(item: CartItem) -> Bool {
        guard let index = self.cartItems.firstIndex(where: {
            $0.id != item.id &&
            $0.name.lowercased() == item.name.lowercased() &&
            !$0.isChecked &&
            !item.isChecked
        }) else {
            return false
        }
        self.cartItems[index].quantity += item.quantity
        return true
    }

    private func save() {
        Service.saveOrAppend(PersistenceManager.save, cartItems, to: "cart")
    }

    private func debugTools() {
        print(cartItems)
    }
}