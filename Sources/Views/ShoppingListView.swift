import SwiftUI

struct ShoppingListView: View {
    @EnvironmentObject var store: ShoppingListStore
    @StateObject private var searchViewModel = SearchViewModel()
    @State private var selectedSort: ShoppingListFilter.SortOption = .Alphabetically
    @State private var showingAddSheet: Bool = false
    @State private var itemToEdit: CartItem?
    
    private var filteredItems: [CartItem] {
        store.filterAndSortItems(query: searchViewModel.debouncedText, by: selectedSort)
    }
    
    var body: some View {
        NavigationStack {
            VStack { 
                if store.cartItems.isEmpty {
                    ContentUnavailableView(
                        "No Groceries",
                        systemImage: "cart",
                        description: Text("Tap the + button to add items.")
                    )
                } else {
                    List {
                        ForEach(filteredItems) { item in
                            ShoppingListRowView(
                                item: item,
                                currentSort: selectedSort,
                                onToggle: { store.toggleItem(item) }
                            )
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    store.removeItem(item: item)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                             .onTapGesture(count: 1) {
                                    itemToEdit = item
                            }
                        }
                    }
                }
            }
            .navigationTitle("Shopping List")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddCartItemView { name, quantity in
                    store.addItem(
                        name: name, 
                        quantity: quantity
                    )
                }
            }
            .sheet(item: $itemToEdit) { item in
                EditCartItemView(item: item) { newName, quantity in
                    store.updateItem(
                        item: item, 
                        newName: newName, 
                        newQuantity: quantity
                    )
                }
            }
        }
    }
}

struct ShoppingListRowView: View {
    let item: CartItem
    let currentSort: ShoppingListFilter.SortOption 
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(item.isChecked ? .blue : .gray)
                    .font(.title2)
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading, spacing: 6) {
                Text(item.name)
                    .font(.headline)
                    .strikethrough(item.isChecked, color: .gray)
                    .foregroundColor(item.isChecked ? .gray : .primary)
            }
            
            Spacer()
            
            Text("Qty: \(item.quantity)")
                .font(.subheadline)
                .fontWeight(.bold)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .clipShape(Capsule())
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ShoppingListView()
        .environmentObject(ShoppingListStore())
}