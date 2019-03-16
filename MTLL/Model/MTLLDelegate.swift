// jm

import MetalKit

protocol MTLLDelegate {
    var view: MTKView { get }
    var library: MTLLibrary! { get }
}
