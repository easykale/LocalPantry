import Foundation
struct TestViewModel {
    private func testaddItem(UUID: String, name: String, serial: String? = nil, quantity: Int, expiry: String? = nil) {
        print("===Testing addItem===")
        let test = NOUIInventoryStore()
        test.addItem(UUID:UUID, name:name, serial:serial, quantity:quantity, expiry:expiry)
        test.debugTools()
    }

    private func testremoveItem(item: InventoryItem, qty:Int ) {
        print("===Testing removeItem===")
        let test = NOUIInventoryStore()
        test.removeItem(item:item, quantityToRemove:qty)
        test.debugTools()
    }

    func runAll() {
        let testItem = InventoryItem(UUID:"123ABC", name:"potato", serialNumber:"12345-1", quantity:3, expiryDate:"01/02/2026")

        testaddItem(UUID:"123ABC", name:"potato", serial:"12345-1", quantity:3, expiry:"01/02/2026")
        testremoveItem(item:testItem, qty:1)
        testremoveItem(item:testItem, qty:2)
        testaddItem(UUID:"123", name:"banana", quantity:3)

        let debug = NOUIInventoryStore()
        debug.debugTools()
    }
}