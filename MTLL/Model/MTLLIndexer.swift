// jm

import simd

class MTLLIndexer {
    private var vertexMap: VertexMap
    
    init() {
        vertexMap = [:]
    }
    
    func index(_ vertices: Array<Vertex>) -> (model: MTLLModel, vertexMap: VertexMap)? {
        guard vertices.count % 3 == 0 else {
            return nil
        }
        
        let indices = Array<IndexData>()
        var indexedVertices = Array<Vertex>()
        
        for vertex in vertices.data {
            var index: IndexData = 0
            let similarVertexExists = doesSimilarVertexExist(vertex, indexedVertices, index: &index)
            if similarVertexExists {
                indices.append(index)
                vertexMap[index]?.append(vertex)
            } else {
                indexedVertices.append(vertex)
                let newIndex = IndexData(indexedVertices.count - 1)
                indices.append(newIndex)
                vertexMap[newIndex] = [vertex]
            }
        }
        
        mtll_application.normalGenerator.generate(indices, &indexedVertices)
        
        return (model: MTLLModel(indexedVertices, indices), vertexMap: vertexMap)
    }
    
    private func doesSimilarVertexExist(_ vertex: Vertex, _ indexedVertices: Array<Vertex>, index: inout IndexData) -> Bool {
        for i in 0..<indexedVertices.data.count {
            let found = isNear(vertex, indexedVertices[Int(i)])
            if found {
                index = IndexData(i)
                return true
            }
        }
        return false
    }
    
    private func isNear(_ vertex1: Vertex, _ vertex2: Vertex, _ tolerance: Float = 0.1) -> Bool {
        let pos = isNear(vertex1.position, vertex2.position, tolerance)
        let tex = isNear(vertex1.textureCoord, vertex2.textureCoord, tolerance)
        let norm = isNear(vertex1.normal, vertex2.normal, tolerance)
        
        return pos && tex && norm
    }
    
    private func isNear(_ vec1: float3, _ vec2: float3, _ tolerance: Float = 0.1) -> Bool {
        let dX = abs(vec1.x - vec2.x)
        let dY = abs(vec1.y - vec2.y)
        let dZ = abs(vec1.z - vec2.z)
        
        return dX < tolerance && dY < tolerance && dZ < tolerance
    }
    
    private func isNear(_ vec1: float2, _ vec2: float2, _ tolerance: Float = 0.1) -> Bool {
        let dX = abs(vec1.x - vec2.x)
        let dY = abs(vec1.y - vec2.y)
        
        return dX < tolerance && dY < tolerance
    }
    
    private func isNear(_ val1: Float, val2: Float, _ tolerance: Float = 0.1) -> Bool {
        return abs(val1 - val2) < tolerance
    }
}
