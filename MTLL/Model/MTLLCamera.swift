// jm

import simd

class MTLLCamera {
    //MARK: - Properties
    let initialPosition = float3(-20, 0, 0)
    
    var position: float3
    var rotation: float3
    
    var viewMatrix: matrix_float4x4 {
        get {
            var front = float3()
            front.x = cos(rotation.x.degreesToRadians) * cos(rotation.y.degreesToRadians)
            front.y = sin(rotation.y.degreesToRadians)
            front.z = sin(rotation.x.degreesToRadians) * cos(rotation.y.degreesToRadians)
            return matrix_float4x4.lookAt(position, float3(0,0,0), float3(0,1,0))
        }
    }
    
    init() {
        position = initialPosition
        rotation = float3(0, 0, 0)
    }
}
