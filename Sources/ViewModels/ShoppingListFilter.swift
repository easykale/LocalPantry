import Foundation

struct ShoppingListFilter {
    enum SortOption {
        case NumericallyAscending
        case Alphabetically
        case NumericallyDescending
    }

    static func sortfilter(_ items: [CartItem], _ option: SortOption) -> [CartItem] {
        var array: [CartItem] = items

        switch option {
            case .NumericallyAscending:
                array.sort(by: {$0.quantity < $1.quantity})
            case .Alphabetically:
                array.sort(by: {$0.name < $1.name})
            case .NumericallyDescending:
                array.sort(by: {$0.quantity > $1.quantity})
        }
        return array
    }
}