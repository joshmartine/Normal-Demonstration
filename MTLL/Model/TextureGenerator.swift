// jm

import MetalKit

class TextureGenerator {
    func generate(textureLoader: MTKTextureLoader, filePath: String, fileExtension: String) -> MTLTexture {
        let blank = URL(fileURLWithPath: "")
        let url = Bundle.main.url(forResource: filePath, withExtension: fileExtension) ?? blank
        guard url != blank else {
            fatalError("Unable to find texture: \(filePath)\(fileExtension)")
        }
        
        let texture = try! textureLoader.newTexture(URL: url, options: [:])
        return texture
    }
}

