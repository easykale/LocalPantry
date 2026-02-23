import Foundation

struct InventoryFilter {
    enum SortOption {
        case Numerically
        case Alphabetically
        case ByExpirationDate
        case ByLowStock //has low stock indicator
    }

    static func sortfilter(_ items: [InventoryItem], _ option: SortOption) -> [InventoryItem] {
        var array: [InventoryItem] = items

        switch option {
            case .Numerically:
                array.sort(by: {$0.quantity < $1.quantity})
            case .Alphabetically:
                array.sort(by: {$0.name < $1.name})
            case .ByExpirationDate:
                array.sort {
                    a,b in 
                    if let a: Date = a.expiryDate, let b: Date = b.expiryDate {
                        return a < b
                    }
                    return a.expiryDate != nil
                    }
            case .ByLowStock:
                array.sort(by: {$0.quantity < $1.quantity})
        }
        return array
    }
}