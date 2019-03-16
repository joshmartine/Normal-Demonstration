// jm

import simd

class Face {
    //MARK: - Properties
    private var indices: [IndexData]
    
    //MARK: - Initialization
    init(_ indexOne: IndexData, _ indexTwo: IndexData, _ indexThree: IndexData) {
        indices = []
        indices.append(indexOne)
        indices.append(indexTwo)
        indices.append(indexThree)
    }
    
    //MARK: - Ease of access
    subscript(index: Int) -> IndexData {
        get {
            assert(indexIsValid(index: index), "Index out of bounds: " + String(describing: index))
            return indices[index]
        }
        set {
            assert(indexIsValid(index: index), "Index out of bounds: " + String(describing: index))
            indices[index] = newValue
        }
    }
    
    private func indexIsValid(index: Int) -> Bool {
        if index > indices.count - 1 || index < 0 {
            return false
        }
        return true
    }
}
