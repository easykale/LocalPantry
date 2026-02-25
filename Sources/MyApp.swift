import SwiftUI

@main
struct MyApp: App {
    @StateObject private var inventoryStore = InventoryStore()
    @StateObject private var shoppingListStore = ShoppingListStore()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(inventoryStore)
                .environmentObject(shoppingListStore) 
        }
    }
}

struct MainView: View {
    @State private var selectedTab: Int = 1
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedTab) {
                ShoppingListView()
                    .tag(0)
                    .toolbar(.hidden, for: .tabBar)
                
                InventoryListView()
                    .tag(1)
                    .toolbar(.hidden, for: .tabBar)           
                
                HistoryView()
                    .tag(2)
                    .toolbar(.hidden, for: .tabBar)
            }
            
            Divider()
                .background(Color.gray.opacity(0.3))

            HStack {
                Spacer()
                
                TabBarButton(icon: "cart", title: "Shopping List", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
                
                Spacer()
                
                TabBarButton(icon: "leaf", title: "Pantry", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
                
                Spacer()
                
                TabBarButton(icon: "clock.arrow.circlepath", title: "History", isSelected: selectedTab == 2) {
                    selectedTab = 2
                }
                
                Spacer()
            }
            .padding(.top, 10)
            .padding(.bottom, 10) 
            .background(Color(UIColor.systemBackground))
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                Text(title)
                    .font(.caption)
            }
            .foregroundColor(isSelected ? .blue : .gray) 
        }
    }
}