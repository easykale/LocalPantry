import SwiftUI

@main
struct MyApp: App {
    @StateObject private var inventoryStore = InventoryStore()
    @StateObject private var shoppingListStore = ShoppingListStore()
    @State private var selectedTab = 1
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                ShoppingListView()
                    .tabItem {
                        Label("Shopping List", systemImage: "cart")
                    }
                    .tag(0)
                InventoryListView()
                    .tabItem {
                        Label("Pantry", systemImage: "leaf")
                    }
                    .tag(1)           
                HistoryView()
                    .tabItem {
                        Label("History", systemImage: "clock.arrow.circlepath")
                    }
                    .tag(2)
            }
            .environmentObject(inventoryStore)
            .environmentObject(shoppingListStore) 
        }
    }
}