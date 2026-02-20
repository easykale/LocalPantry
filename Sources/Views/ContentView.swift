import SwiftUI
import Foundation
struct InventoryListView: View {
    @StateObject private var store = InventoryStore() 
    @State private var showingAddSheet = false 
    
    var body: some View {
        NavigationStack {
            // FIX 1: Swapped Group for VStack to stabilize the compiler
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
                        }
                    }
                }
            } 
            .navigationTitle("Inventory")
            // FIX 2: Simplified the toolbar closure
            .toolbar {
                Button {
                    showingAddSheet = true 
                } label: {
                    Image(systemName: "plus")
                        .fontWeight(.semibold)
                }
            }
            // Attached the sheet directly to the VStack
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
        }
    }
}

// MARK: - Supporting Row View
struct InventoryRowView: View {
    let item: InventoryItem
    
    // Threshold for visual indicator
    private let lowStockThreshold = 5
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(item.name)
                    .font(.headline)
                
                Spacer()
                
                // Quantity Indicator.
                Text("Qty: \(item.quantity)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(item.quantity <= lowStockThreshold ? Color.red.opacity(0.2) : Color.blue.opacity(0.1))
                    .foregroundColor(item.quantity <= lowStockThreshold ? .red : .blue)
                    .clipShape(Capsule())
            }
            
            // Safely unwrap the optional serial number
            if let serial = item.serialNumber, !serial.isEmpty {
                Text("S/N: \(serial)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Safely unwrap your optional String expiry date
            if let expiry: Date = item.expiryDate {
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .foregroundColor(.secondary)
                    Text("Expires: \(expiry, style: .date)") // SwiftUI native date formatting
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