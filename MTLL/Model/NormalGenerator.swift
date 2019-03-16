// jm

import simd

class NormalGenerator {
    func generate(_ indices: Array<IndexData>, _ indexedVertices: inout Array<Vertex>) {
        let perFaceNormals = Array<float3>()
        let perFaceTangents = Array<float3>()
        let perFaceBitangents = Array<float3>()
        
        for index in stride(from: 0, to: indices.count - 1, by: 3) {
            let v0 = indexedVertices[Int(indices[index + 0])].position
            let v1 = indexedVertices[Int(indices[index + 1])].position
            let v2 = indexedVertices[Int(indices[index + 2])].position
            let dV1 = v1 - v0
            let dV2 = v2 - v0
            
            let normal = normalize(cross(dV1, dV2))
            perFaceNormals.append(normal)
            
            let uv0 = indexedVertices[Int(indices[index + 0])].textureCoord
            let uv1 = indexedVertices[Int(indices[index + 1])].textureCoord
            let uv2 = indexedVertices[Int(indices[index + 2])].textureCoord
            
            let dUV1 = uv1 - uv0
            let dUV2 = uv2 - uv0
            
            let r = 1.0 / (dUV1.x * dUV2.y - dUV1.y * dUV2.x)
            let tangent = (dV1 * dUV2.y - dV2 * dUV1.y) * r
            let bitangent = (dV2 * dUV1.x - dV1 * dUV2.x) * r
                        
            perFaceTangents.append(normalize(tangent))
            perFaceBitangents.append(normalize(bitangent))
        }
                
        var repeatVertices = [Int:[IndexData]]()
        let uniqueVertexCount = indices.data.uniqueElements.count
        for i in 0..<uniqueVertexCount {
            repeatVertices[i] = []
        }
        
        for uniqueIndex in indices.data.uniqueElements {
            for index in indices.data {
                if uniqueIndex == index {
                    repeatVertices[Int(index)]?.append(index)
                }
            }
        }
        
        for key in repeatVertices.keys {
            var normal = float3()
            var tangent = float3()
            var bitangent = float3()
            for value in repeatVertices[key]! {
                let index = value / 3
                normal += perFaceNormals[Int(index)]
                tangent += perFaceTangents[Int(index)]
                bitangent += perFaceBitangents[Int(index)]
            }
            let count = Float(repeatVertices[key]?.count ?? 1)
            normal /= count
            tangent /= count
            bitangent /= count
            indexedVertices[key].normal = normal
            indexedVertices[key].tangent = tangent
            indexedVertices[key].bitangent = bitangent
        }
    }
}
