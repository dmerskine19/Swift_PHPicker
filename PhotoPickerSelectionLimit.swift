import Foundation

public typealias PhotoPickerSelectionLimit = Int;

// convinince extension on Int to represent selection limit in a more readable way
public extension PhotoPickerSelectionLimit {
    
    static func unlimited() -> Int {
        1
    }
    
    static func exactly(_ value: Int)  -> Int {
        value
    }
}
