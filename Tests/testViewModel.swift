import Foundation
struct TestViewModel {

    let test = NOUIInventoryStore()

    private func testaddItem(UUID: String, name: String, serial: String? = nil, quantity: Int, expiry: String? = nil) {
        print("===Testing addItem===")
        test.addItem(UUID:UUID, name:name, serial:serial, quantity:quantity, expiry:expiry)
        test.debugTools()
        print("=== End ===\n")
    }

    private func testremoveItem(item: InventoryItem, qty:Int ) {
        print("===Testing removeItem===")
        test.removeItem(item:item, quantityToRemove:qty)
        test.debugTools()
        print("=== End ===\n")
    }

    func runAll() {
        print("-------------Starting ViewModel Testing-------------")
        let testItem = InventoryItem(UUID:"123ABC", name:"potato", serialNumber:"12345-1", quantity:3, expiryDate:"01/02/2026")

        testaddItem(UUID:"123ABC", name:"potato", serial:"12345-1", quantity:3, expiry:"01/02/2026")
        testremoveItem(item:testItem, qty:1)
        testremoveItem(item:testItem, qty:2)
        testaddItem(UUID:"123", name:"banana", quantity:3)

        print("===Checking Logs===")
        test.debugTools()
        print("--------------------End-----------------------\n")
    }
}