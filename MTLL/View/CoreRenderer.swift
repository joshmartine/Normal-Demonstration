// jm

import MetalKit

class CoreRenderer: MTKView {
    //MARK: - Properties
    private var _library: MTLLibrary!
    private var commandQueue: MTLCommandQueue!
    
    #if os(macOS)
    typealias Rect = NSRect
    #elseif os(iOS)
    typealias Rect = CGRect
    #endif
    
    //MARK: - Initializion
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.device = MTLCreateSystemDefaultDevice()
        self._library = device?.makeDefaultLibrary()
        self.commandQueue = device?.makeCommandQueue()
        
        self.colorPixelFormat = .bgra8Unorm
        self.sampleCount = 4
        
        mtll_application.delegate = self
    }
    
    //MARK: - Rendering
    override func draw(_ dirtyRect: Rect) {
        super.draw(dirtyRect)
        
        if let renderPassDescriptor = self.currentRenderPassDescriptor, let drawable = self.currentDrawable {
            // Set the background color.
            renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.5, 0.55, 0.57, 1.0)
            
            let commandBuffer = commandQueue.makeCommandBuffer()
            var commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
            
            mtll_application.update(&commandEncoder!)
            
            commandEncoder?.endEncoding()
            commandBuffer?.present(drawable)
            commandBuffer?.commit()
        }
    }
}

extension CoreRenderer: MTLLDelegate {
    var view: MTKView {
        return self
    }
    
    var library: MTLLibrary! {
        return _library
    }
}
