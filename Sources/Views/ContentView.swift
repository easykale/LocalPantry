import SwiftUI
import Foundation

struct InventoryListView: View {
    @StateObject private var store = InventoryStore() 
    @State private var showingAddSheet = false 
    @State private var itemToRemove: InventoryItem? 
    
    var body: some View {
        NavigationStack {
            VStack { 
                if store.items.isEmpty {
                    ContentUnavailableView(
                        "No Items",
                        systemImage: "shippingbox",
                        description: Text("Tap the + button to add inventory.")
                    )
                } else {
                    List {
                        ForEach(store.items) { item in
                            InventoryRowView(item: item)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button {
                                        itemToRemove = item
                                    } label: {
                                        Label("Consume", systemImage: "minus.circle")
                                    }
                                    .tint(.red)
                                }
                        }
                    }
                }
            } 
            .navigationTitle("Inventory")
            .toolbar {
                Button {
                    showingAddSheet = true 
                } label: {
                    Image(systemName: "plus")
                        .fontWeight(.semibold)
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddItemView { name, serial, qty, expiry in
                    store.addItem(
                        UUID: UUID().uuidString, 
                        name: name,
                        serial: serial,
                        quantity: qty,
                        expiry: expiry 
                    )
                }
            }
            .sheet(item: $itemToRemove) { item in
                RemoveItemView(item: item) { qty in
                    store.removeItem(item: item, quantityToRemove: qty)
                }
            }
        }
    }
}

struct InventoryRowView: View {
    let item: InventoryItem
    
    private let lowStockThreshold = 5
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(item.name)
                    .font(.headline)
                
                Spacer()
                
                Text("Qty: \(item.quantity)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(item.quantity <= lowStockThreshold ? Color.red.opacity(0.2) : Color.blue.opacity(0.1))
                    .foregroundColor(item.quantity <= lowStockThreshold ? .red : .blue)
                    .clipShape(Capsule())
            }
            
            if let serial = item.serialNumber, !serial.isEmpty {
                Text("S/N: \(serial)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if let expiry: Date = item.expiryDate {
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .foregroundColor(.secondary)
                    Text("Expires: \(expiry, style: .date)")
                        .foregroundColor(.secondary)
                }
                .font(.caption2)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview Provider (Crucial for Swift Playgrounds)
#Preview {
    InventoryListView()
}