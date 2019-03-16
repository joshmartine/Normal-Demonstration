// jm

import MetalKit

struct ModelUniform {
    var projectionMatrix: float4x4
    var viewMatrix: float4x4
    var transformationMatrix: float4x4
}

class MTLLModel {
    //MARK: - Properties
    var delegate: MTLLDelegate?
    private var device: MTLDevice?
    
    var vertexCount: Int
    
    var vertexBuffer: MTLBuffer!
    var uniformBuffer: MTLBuffer!
    var indexBuffer: MTLBuffer!
    
    var vertexShader: MTLFunction!
    var fragmentShader: MTLFunction!
    
    var renderPipelineState: MTLRenderPipelineState!
    var samplerState: MTLSamplerState!
    
    init(_ vertices: Array<Vertex>) {
        delegate = mtll_application.delegate
        
        device = delegate?.view.device
        
        vertexCount = vertices.count
        
        vertexBuffer = device?.makeBuffer(bytes: vertices.data, length: vertices.size, options: [])
        uniformBuffer = device?.makeBuffer(length: MemoryLayout<ModelUniform>.stride, options: [])
                
        vertexShader = delegate?.library.makeFunction(name: "modelVertex")
        fragmentShader = delegate?.library.makeFunction(name: "modelFragment")
        
        renderPipelineState = try! device?.makeRenderPipelineState(descriptor: createRenderDescriptor())
        
        samplerState = device?.makeSamplerState(descriptor: createSamplerDescriptor())
    }
    
    convenience init(_ vertices: Array<Vertex>, _ indices: Array<IndexData>) {
        self.init(vertices)
        
        indexBuffer = device?.makeBuffer(bytes: indices.data, length: indices.size, options: [])
        vertexCount = indices.count
    }
    
    private func createRenderDescriptor() -> MTLRenderPipelineDescriptor {
        let renderDescriptor = MTLRenderPipelineDescriptor()
        renderDescriptor.sampleCount = (delegate?.view.sampleCount)!
        renderDescriptor.colorAttachments[0].pixelFormat = (delegate?.view.colorPixelFormat)!
        renderDescriptor.vertexFunction = vertexShader
        renderDescriptor.fragmentFunction = fragmentShader
        
        return renderDescriptor
    }
    
    private func createSamplerDescriptor() -> MTLSamplerDescriptor {
        let sampler = MTLSamplerDescriptor()
        sampler.minFilter = MTLSamplerMinMagFilter.nearest
        sampler.magFilter = MTLSamplerMinMagFilter.nearest
        sampler.mipFilter = MTLSamplerMipFilter.nearest
        sampler.maxAnisotropy = 1
        sampler.sAddressMode = MTLSamplerAddressMode.repeat
        sampler.tAddressMode = MTLSamplerAddressMode.repeat
        sampler.rAddressMode = MTLSamplerAddressMode.repeat
        sampler.normalizedCoordinates = true
        sampler.lodMinClamp  = 0
        sampler.lodMaxClamp = .greatestFiniteMagnitude
        
        return sampler
    }
}
