import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var store: InventoryStore
    
    var body: some View {
        NavigationStack {
            Group {
                if store.history.isEmpty {
                    ContentUnavailableView(
                        "No History",
                        systemImage: "doc.text.magnifyingglass",
                        description: Text("Your transaction logs will appear here once you add or consume items.")
                    )
                } else {
                    List {
                        let sortedLogs = store.history.sorted { $0.timestamp > $1.timestamp }
                        ForEach(sortedLogs, id: \.timestamp) { log in
                            HistoryRowView(log: log)
                        }
                    }
                }
            }
            .navigationTitle("History Logs")
        }
    }
}

struct HistoryRowView: View {
    let log: TransactionLog
    
    private var isAddition: Bool { log.type == .Add }
    private var iconColor: Color { isAddition ? .green : .red }
    private var iconName: String { isAddition ? "plus.circle.fill" : "minus.circle.fill" }
    private var sign: String { isAddition ? "+" : "-" }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: iconName)
                .foregroundColor(iconColor)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(log.itemName)
                    .font(.headline)
                Text(log.timestamp, format: .dateTime.month().day().hour().minute())
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(sign)\(log.quantityChanged)")
                .font(.headline)
                .foregroundColor(iconColor)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    HistoryView()
        .environmentObject(InventoryStore())
}