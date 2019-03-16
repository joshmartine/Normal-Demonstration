// jm

import MetalKit
import simd
#if os(macOS)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

class CoreView {
    //MARK: - Properties
    var projectionMatrix: matrix_float4x4!
    
    //MARK: - Initialization
    init(_ projectionMatrix: matrix_float4x4) {
        self.projectionMatrix = projectionMatrix
    }
    
    func updateProjectionMatrix() {
        #if os(macOS)
            let aspect = Float((NSScreen.main?.frame.size.width)!) / Float((NSScreen.main?.frame.size.height)!)
        #elseif os(iOS)
            let aspect = Float(UIScreen.main.bounds.width) / Float(UIScreen.main.bounds.height)
        #endif
        
        projectionMatrix = matrix_float4x4.projectionMatrix(mtll_application.nearClippingPlane, far: mtll_application.farClippingPlane, aspect: aspect, fovy: mtll_application.fov)
    }
}

