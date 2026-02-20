import SwiftUI
import Foundation
struct InventoryListView: View {
    // Observing the single source of truth
    @StateObject private var store = InventoryStore() 
    
    var body: some View {
        NavigationStack {
            Group {
                if store.items.isEmpty {
                    // S2-04 Empty State Placeholder
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
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        // TODO: Trigger S2-02 Add Item Form Sheet
                        print("Add Item Tapped")
                    }) {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                    }
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
            if let expiry = item.expiryDate, !expiry.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .foregroundColor(.secondary)
                    Text("Expires: \(expiry)")
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