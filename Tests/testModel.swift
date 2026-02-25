import Foundation

struct ModelTest {
    func assert(condition:Bool, message:String) {
        print("========================")
        if condition {
            print("Passed \(condition): \(message)")
        }
        else {
            print("Failed \(condition): \(message)")
        }
        print("========================")
    }

    func testInventoryItem() {
        print("===Starting testInventoryItem===")
        print("\nTestcase 1:")

        //Testcase: ensure item can be instantiated
        var item = InventoryItem(
        UUID: "12345ABC", 
        name: "potato", 
        serialNumber: "12345-1", 
        quantity: 7,
        expiryDate: "12/04/2026" 
        )
        var mirror = Mirror(reflecting: item)
        for child in mirror.children {
            if let propertyName = child.label {
                print("\(propertyName): \(child.value)")
            }
        }

        //Testcase: ensure item can be instantiated with optional fields
        print("\nTestcase 2:")
        item = InventoryItem(
            UUID: "1A2B3C", 
            name: "banana",  
            quantity: 7
        )
        mirror = Mirror(reflecting: item)
        for child in mirror.children {
            if let propertyName = child.label {
                print("\(propertyName): \(child.value)")
            }
        }
        print("===Ending testInventoryItem===")
    }

    func testTransactionLog() {
        print("===Starting testTranscationLog===")
        print("\nTestcase 1:")

        //Testcase: ensure item can be instantiated
        var item = TransactionLog(
        timestamp: Date(), 
        type: .Add, 
        itemName: "potato",
        serialNumber: "12345",
        quantityChanged: 1 
        )
        var mirror = Mirror(reflecting: item)
        for child in mirror.children {
            if let propertyName = child.label {
                print("\(propertyName): \(child.value)")
            }
        }

        //Testcase: ensure item can be instantiated with optional fields
        print("\nTestcase 2:")
        item = TransactionLog(
        timestamp: Date(), 
        type: .Remove, 
        itemName: "banana",
        quantityChanged: -3 
        )
        mirror = Mirror(reflecting: item)
        for child in mirror.children {
            if let propertyName = child.label {
                print("\(propertyName): \(child.value)")
            }
        }
        print("===Ending testTranscationLog===")
    }

    mutating func runAll() {
        print("-------------Starting Model Testing-------------")

        testInventoryItem()
        print()
        testTransactionLog()

        print("--------------------End-----------------------\n")
    }
}

