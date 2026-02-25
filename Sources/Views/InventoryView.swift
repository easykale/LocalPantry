import SwiftUI
import Foundation

struct InventoryListView: View {
    @EnvironmentObject var store: InventoryStore
    @StateObject private var searchViewModel = SearchViewModel()
    @State private var showingAddSheet: Bool = false 
    @State private var itemToRemove: InventoryItem?
    @State private var itemToEdit: InventoryItem?
    @State private var selectedSort: InventoryFilter.SortOption = .Alphabetically
    
    var body: some View {
        NavigationStack {
            VStack { 
                if store.items.isEmpty {
                    ContentUnavailableView(
                        "No Items",
                        systemImage: "shippingbox",
                        description: Text("Tap the + button to add items.")
                    )
                } else {
                    List {
                        ForEach(store.filterAndSortItems(query: searchViewModel.debouncedText, by: selectedSort)) { item in
                            InventoryRowView(item: item, currentSort: selectedSort)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button {
                                        itemToRemove = item
                                    } label: {
                                        Label("Consume", systemImage: "minus.circle")
                                    }
                                    .tint(.red) 
                                }
                                .onTapGesture(count: 1) {
                                    itemToEdit = item
                                }
                        }
                    }
                }
            } 
            .navigationTitle("Inventory")
            .searchable(text: $searchViewModel.searchText, prompt: "Search for an item")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Menu {
                        Picker("Sort Options", selection: $selectedSort) {
                            Text("Alphabetical").tag(InventoryFilter.SortOption.Alphabetically)
                            Text("Quantity (Low to High)").tag(InventoryFilter.SortOption.Numerically)
                            Text("Low Stock").tag(InventoryFilter.SortOption.ByLowStock)
                            Text("Expiration Date").tag(InventoryFilter.SortOption.ByExpirationDate)
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .fontWeight(.semibold)
                    }
                    Button {
                        showingAddSheet = true 
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddItemView { name, serial, qty, expiry in
                    store.addItem(
                        name: name,
                        serial: serial,
                        quantity: qty,
                        expiry: expiry 
                    )
                }
            }
            .sheet(item: $itemToRemove) { item in
                RemoveItemView(item: item) { quantity in
                    store.removeItem(
                        item: item, 
                        quantityToRemove: quantity
                    )
                }  
            }
            .sheet(item: $itemToEdit) { item in
                EditItemView(item: item) { name, serialNumber, expiryDate in
                    store.updateItem(
                        item: item, 
                        newName: name, 
                        newSerialNumber: serialNumber,
                        newExpiryDate: expiryDate
                        newQuantity: 
                    )
                }
            }
        }
    }
}

struct InventoryRowView: View {
    let item: InventoryItem
    let currentSort: InventoryFilter.SortOption 
    
    private let lowStockThreshold = 5
    
    private var expiryStatus: (color: Color, text: String)? {
        guard let expiry = item.expiryDate else { return nil }
        let now = Date()
        let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: now)!
        
        if expiry < now {
            return (.red, "Expired")
        } else if expiry < nextWeek {
            return (.orange, "Expiring Soon")
        }
        return nil
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(item.name)
                    .font(.headline)
                
                Spacer()
                
                let isLowStockHighlighted = (currentSort == .ByLowStock && item.quantity <= lowStockThreshold)
                
                Text("Qty: \(item.quantity)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(isLowStockHighlighted ? Color.red.opacity(0.2) : Color.blue.opacity(0.1))
                    .foregroundColor(isLowStockHighlighted ? .red : .blue)
                    .clipShape(Capsule())
            }
            
            if let serial = item.serialNumber, !serial.isEmpty {
                Text("S/N: \(serial)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if let expiry = item.expiryDate {
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                    Text("Expires: \(expiry, style: .date)")
                    
                    if currentSort == .ByExpirationDate, let status = expiryStatus {
                        Text("• \(status.text)")
                            .foregroundColor(status.color)
                            .fontWeight(.bold)
                    }
                }
                .font(.caption2)
                .foregroundColor(
                    (currentSort == .ByExpirationDate && expiryStatus != nil) ? expiryStatus!.color : .secondary
                )
            }
        }
        .padding(.vertical, 4)
    }
}


#Preview {
    InventoryListView()
        .environmentObject(InventoryStore())
}
