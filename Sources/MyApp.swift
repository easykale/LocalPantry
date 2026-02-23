import SwiftUI

@main
struct MyApp: App {
    @StateObject private var store = InventoryStore()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                InventoryListView()
                    .tabItem {
                        Label("Inventory", systemImage: "shippingbox")
                    }
                
                HistoryView()
                    .tabItem {
                        Label("History", systemImage: "clock.arrow.circlepath")
                    }
            }
            .environmentObject(store) 
        }
    }
}