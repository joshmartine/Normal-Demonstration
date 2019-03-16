// jm

import MetalKit
import simd

let mtll_application = CoreApplication()

typealias IndexData = UInt16
typealias VertexMap = [IndexData: [Vertex]]

class CoreApplication {
    public var delegate: MTLLDelegate? {
        didSet {
            textureLoader = MTKTextureLoader(device: (delegate?.view.device)!)
        }
    }
    
    var nearClippingPlane: Float
    var farClippingPlane: Float
    var fov: Float
    var screenAspect: Float
    
    public let view: CoreView
    public let controller: CoreController
    
    private(set) public var textureLoader: MTKTextureLoader!
    public let indexer: MTLLIndexer
    public let normalGenerator: NormalGenerator
    
    var m: MTLLModel!
    var i: Bool = false
    var baseTexture: MTLTexture!
    var normalTexture: MTLTexture!
    
    //MARK: - Initialization
    init() {
        nearClippingPlane = 0.01
        farClippingPlane = 1000
        fov = 75
        screenAspect = 16.0 / 9.0
        
        view = CoreView(matrix_float4x4.projectionMatrix(nearClippingPlane, far: farClippingPlane, aspect: screenAspect, fovy: fov))
        controller = CoreController()
        
        indexer = MTLLIndexer()
        normalGenerator = NormalGenerator()
    }
    
    func make() {
        i = true
        
        // Front
        let v0 = Vertex(float3(20, 10, 10), float2(0,0))
        let v1 = Vertex(float3(20, -10, 10), float2(0,1))
        let v2 = Vertex(float3(-20, 10, 10), float2(1,0))
        let v3 = Vertex(float3(-20, -10, 10), float2(1,1))

        let t = MTKTextureLoader(device: (delegate?.view.device)!)
        let textureName = "Bricks"
        let baseTextureURL = Bundle.main.url(forResource: textureName + "Texture", withExtension: ".jpg")
        baseTexture = try! t.newTexture(URL: baseTextureURL!, options: [.generateMipmaps:true])
        let normalTextureURL = Bundle.main.url(forResource: textureName + "Normal", withExtension: ".jpg")
        normalTexture = try! t.newTexture(URL: normalTextureURL!, options: [.generateMipmaps:true])
        
        let model = indexer.index([
            v0, v1, v3,
            v3, v2, v0,
        ])!
        self.m = model.0
        
        view.updateProjectionMatrix()
    }
    
    var frames: Float = 0
    //MARK: - Public functions
    public func update(_ commandEncoder: inout MTLRenderCommandEncoder) {
        if !i {
            make()
        } else {
            frames = frames.truncatingRemainder(dividingBy: 360)
            frames += 1
            commandEncoder.setRenderPipelineState(m.renderPipelineState)
            
            let uniformBufferPointer = m.uniformBuffer.contents().assumingMemoryBound(to: ModelUniform.self)
            uniformBufferPointer.pointee.projectionMatrix = view.projectionMatrix
            uniformBufferPointer.pointee.viewMatrix = controller.cameraController.camera.viewMatrix
            uniformBufferPointer.pointee.transformationMatrix = matrix_float4x4.rotationMatrix(Float((90.0).degreesToRadians), float3(0,1,0))
            
            commandEncoder.setVertexBuffer(m.vertexBuffer, offset: 0, index: 0)
            commandEncoder.setVertexBuffer(m.uniformBuffer, offset: 0, index: 1)

            commandEncoder.setFragmentTexture(baseTexture, index: 0)
            commandEncoder.setFragmentTexture(normalTexture, index: 1)
            commandEncoder.setFragmentSamplerState(m.samplerState, index: 0)
            
            commandEncoder.setFrontFacing(.counterClockwise)
            //commandEncoder.setCullMode(.back)
            
            commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: m.vertexCount, indexType: .uint16, indexBuffer: m.indexBuffer, indexBufferOffset: 0)
        }
    }
    
    public func notify<SenderType>(_ sender: SenderType, _ message: String, _ data: [Float]) {
        controller.onNotify(sender, message, data)
    }
}

