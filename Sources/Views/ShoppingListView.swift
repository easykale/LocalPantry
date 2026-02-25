import SwiftUI
import Foundation

struct ShoppingListView: View {
    @EnvironmentObject var store: ShoppingListStore
    @StateObject private var searchViewModel = SearchViewModel()
    @State private var selectedSort: ShoppingListFilter.SortOption = .Alphabetically
    @State private var showingAddSheet: Bool = false
    @State private var itemToRemove: CartItem?
    @State private var itemToEdit: CartItem?
    
    var body: some View {
        NavigationStack {
            VStack { 
                if store.cartItems.isEmpty {
                    ContentUnavailableView(
                        "No Grocceries",
                        systemImage: "cart",
                        description: Text("Tap the + button to add items.")
                    )
                } else {
                    List {
                        ForEach(store.filterAndSortItems(query: searchViewModel.debouncedText, by: selectedSort)) { item in
                            ShoppingListRowView(item: item, currentSort: selectedSort, onToggle: { store.toggleItem(item) })
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button {
                                        itemToRemove = item
                                    } label: {
                                        Label("Remove", systemImage: "minus.circle")
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
            .navigationTitle("Shopping List")
            .searchable(text: $searchViewModel.searchText, prompt: "Search for an item")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if store.cartItems.contains(where: { $0.isChecked }) {
                        Button("Clear") {
                            store.clearCompleted()
                        }
                        .foregroundColor(.red)
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Menu {
                        Picker("Sort Options", selection: $selectedSort) {
                            Text("Alphabetical").tag(ShoppingListFilter.SortOption.Alphabetically)
                            Text("Quantity (Ascending)").tag(ShoppingListFilter.SortOption.NumericallyAscending)
                            Text("Quantity (Descending)").tag(ShoppingListFilter.SortOption.NumericallyDescending)
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
                AddCartItemView { name, qty in
                    store.addItem(
                        name: name,
                        quantity: qty
                    )
                }
            }
            .sheet(item: $itemToRemove) { item in
                RemoveCartItemView(item: item) { quantity in
                    store.removeItem(
                        item: item, 
                        quantityToRemove: quantity
                    )
                }  
            }
            .sheet(item: $itemToEdit) { item in
                EditCartItemView(item: item) { name in
                    store.updateItem(
                        item: item, 
                        newName: name
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