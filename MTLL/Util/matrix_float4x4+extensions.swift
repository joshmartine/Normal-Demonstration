// jm

import simd

extension matrix_float4x4 {
    static func translationMatrix(_ translation: float3) -> matrix_float4x4 {
        var matrix = matrix_identity_float4x4
        matrix.columns.3.x = translation.x
        matrix.columns.3.y = translation.y
        matrix.columns.3.z = translation.z
        return matrix
    }
    
    static func scalingMatrix(_ scale: float3) -> matrix_float4x4 {
        var matrix = matrix_identity_float4x4
        matrix.columns.0.x = scale.x
        matrix.columns.1.y = scale.y
        matrix.columns.2.z = scale.z
        return matrix
    }
    
    static func rotationMatrix(_ angle: Float, _ axis: vector_float3) -> matrix_float4x4 {
        var X = vector_float4(0, 0, 0, 0)
        X.x = axis.x * axis.x + (1 - axis.x * axis.x) * cos(angle)
        X.y = axis.x * axis.y * (1 - cos(angle)) - axis.z * sin(angle)
        X.z = axis.x * axis.z * (1 - cos(angle)) + axis.y * sin(angle)
        X.w = 0.0
        var Y = vector_float4(0, 0, 0, 0)
        Y.x = axis.x * axis.y * (1 - cos(angle)) + axis.z * sin(angle)
        Y.y = axis.y * axis.y + (1 - axis.y * axis.y) * cos(angle)
        Y.z = axis.y * axis.z * (1 - cos(angle)) - axis.x * sin(angle)
        Y.w = 0.0
        var Z = vector_float4(0, 0, 0, 0)
        Z.x = axis.x * axis.z * (1 - cos(angle)) - axis.y * sin(angle)
        Z.y = axis.y * axis.z * (1 - cos(angle)) + axis.x * sin(angle)
        Z.z = axis.z * axis.z + (1 - axis.z * axis.z) * cos(angle)
        Z.w = 0.0
        let W = vector_float4(0, 0, 0, 1)
        return matrix_float4x4(columns:(X, Y, Z, W))
    }
    
    static func projectionMatrix(_ near: Float, far: Float, aspect: Float, fovy: Float) -> matrix_float4x4 {
        let scaleY = 1 / tan(fovy)
        let scaleX = scaleY / aspect
        let scaleZ = -(far + near) / (far - near)
        let scaleW = -2 * far * near / (far - near)
        let X = vector_float4(scaleX, 0, 0, 0)
        let Y = vector_float4(0, scaleY, 0, 0)
        let Z = vector_float4(0, 0, scaleZ, -1)
        let W = vector_float4(0, 0, scaleW, 0)
        return matrix_float4x4(columns:(X, Y, Z, W))
    }
    
    static func lookAt(_ eye: float3, _ target: float3, _ up: float3) -> matrix_float4x4 {
        let zaxis = normalize(eye - target)
        let xaxis = normalize(cross(up, zaxis))
        let yaxis = cross(zaxis, xaxis)
        
        var matrix = matrix_identity_float4x4
        matrix.columns.0 = float4(xaxis.x, xaxis.y, xaxis.z, 0)
        matrix.columns.1 = float4(yaxis.x, yaxis.y, yaxis.z, 0)
        matrix.columns.2 = float4(zaxis.x, zaxis.y, zaxis.z, 0)
        matrix.columns.3 = float4(eye.x, eye.y, eye.z, 1)
        
        return matrix.inverse
    }
}
