import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                // Tab 1: Your main inventory list
                InventoryListView()
                    .tabItem {
                        Label("Inventory", systemImage: "shippingbox")
                    }
                
                // Tab 2: Placeholder for S3-03 (History Tab)
                // We'll replace this Text view with your actual HistoryView later
                Text("History Logs Coming Soon")
                    .tabItem {
                        Label("History", systemImage: "clock.arrow.circlepath")
                    }
            }
        }
    }
}