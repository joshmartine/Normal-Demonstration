// jm

#if os(macOS)
import Foundation
#elseif os(iOS)
import UIKit
#endif

class Array<ElementType>: CustomStringConvertible, ExpressibleByArrayLiteral {
    private var array: [ElementType]
    
    public var count: Int {
        return array.count
    }
    
    public var data: [ElementType] {
            return array
    }
    
    public var size: Int {
        return MemoryLayout<ElementType>.stride * count
    }
    
    
    init() {
        array = []
    }
    
    init(_ data: [ElementType]) {
        array = data
    }
    
    init(_ data: ElementType...) {
        array = []
        for dataObject in data {
            array.append(dataObject)
        }
    }
    
    required public init(arrayLiteral: ElementType...) {
        array = []
        for item in arrayLiteral {
            array.append(item)
        }
    }
    
    subscript(index: Int) -> ElementType {
        get {
            assert(indexIsValid(index: index), "Index out of bounds: " + String(describing: index))
            return array[index]
        }
        set {
            assert(indexIsValid(index: index), "Index out of bounds: " + String(describing: index))
            array[index] = newValue
        }
    }
    
    private func indexIsValid(index: Int) -> Bool {
        if index > array.count - 1 || index < 0 {
            return false
        }
        return true
    }
    
    public func append(_ newElement: ElementType) {
        array.append(newElement)
    }
    
    public func append(newElements: [ElementType]) {
        for newElement in newElements {
            array.append(newElement)
        }
    }
    
    public func remove(at: Int) -> ElementType {
        assert(indexIsValid(index: at), "Index out of bounds")
        return array.remove(at: at)
    }
    
    public func removeAll(_ keepingCapacity: Bool = false) {
        array.removeAll(keepingCapacity: keepingCapacity)
    }
    
    public func removeFirst() {
        assert(indexIsValid(index: 0), "No elements in array")
        array.removeFirst()
    }
    
    public func removeLast() {
        assert(indexIsValid(index: 0), "No elements in array")
        array.removeLast()
    }
    
    public var description: String {
        var desc: String = "["
        for data in array {
            desc += String(describing: data) + " "
        }
        
        if array.count > 0 {
            desc.removeLast()
        }
        return desc + "]"
    }
}

public extension Sequence where Iterator.Element: Hashable {
    var uniqueElements: [Iterator.Element] {
        return Swift.Array( Set(self) )
    }
}

public extension Sequence where Iterator.Element: Equatable {
    var uniqueElements: [Iterator.Element] {
        return self.reduce([]){
            uniqueElements, element in
            
            uniqueElements.contains(element)
                ? uniqueElements
                : uniqueElements + [element]
        }
    }
}
