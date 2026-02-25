import Foundation

struct InventoryItem: Codable, Identifiable {
    var id: String
    var name: String
    var serialNumber: String? //optional
    var quantity: Int
    var expiryDate: Date?   //optional, formatted as dd/mm/yyyy, if no day, itll be default 01
}

enum Flow: String, Codable {
        case Add
        case Remove
}

struct TransactionLog: Codable {
    var timestamp: Date  //YYYY-MM-DD HH:MM:SS +0000
    var type: Flow
    var itemName: String
    var serialNumber: String? //optional, copied from InventoryItem
    var quantityChanged: Int
}

struct CartItem: Codable, Identifiable, Equatable {
    var id: String
    var name: String
    var quantity: Int
    var isChecked: Bool
}