// jm

import simd

struct Vertex {
    //MARK: - Properties
    
    var position: float3
    var textureCoord: float2
    var normal: float3
    var tangent: float3
    var bitangent: float3
    
    //MARK: - Initialization
    init() {
        self.position = float3()
        self.textureCoord = float2()
        self.normal = float3()
        self.tangent = float3()
        self.bitangent = float3()
    }
    
    init(_ position: float3) {
        self.position = position
        self.textureCoord = float2()
        self.normal = float3()
        self.tangent = float3()
        self.bitangent = float3()
    }
    
    init(_ position: float3, _ textureCoord: float2) {
        self.position = position
        self.textureCoord = textureCoord
        self.normal = float3()
        self.tangent = float3()
        self.bitangent = float3()
    }
}

extension Vertex: Hashable {
    var hashValue: Int {
        let f3Sum = position + normal + tangent + bitangent
        let sum = f3Sum.x + f3Sum.y + f3Sum.z + textureCoord.x + textureCoord.y
        return sum.hashValue
    }
    
    static func == (lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.position == rhs.position && lhs.textureCoord == rhs.textureCoord && lhs.normal == rhs.normal && lhs.tangent == rhs.tangent && lhs.bitangent == rhs.bitangent
    }
}

