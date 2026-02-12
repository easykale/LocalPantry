struct InventoryItem {
    var UUID: String
    var name: String
    var serialNumber: String?
    var quantity: Int
    var expiryDate: String?   //dd/mm/yyyy, if no day, itll be default 01
}

struct TransactionLog {
    enum Flow {
        case Add
        case Remove
    }

    var UUID: String
    var timestamp: String  //ss/mm/hh/dd/mm/yyyy
    var type: Flow
    var itemName: String
    var serialNumber: String?
    var quantityChanged: Int
}

