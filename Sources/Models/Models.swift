import Foundation
struct InventoryItem {
    var UUID: String
    var name: String
    var serialNumber: String? //optional
    var quantity: Int
    var expiryDate: String?   //optional, formatted as dd/mm/yyyy, if no day, itll be default 01

}

enum Flow {
        case Add
        case Remove
    }

struct TransactionLog {
    var timestamp: Date  //YYYY-MM-DD HH:MM:SS +0000
    var type: Flow
    var itemName: String
    var serialNumber: String? //optional, copied from InventoryItem
    var quantityChanged: Int
}

