// jm

import simd

class MTLLCameraController: Controller {
    //MARK: - Properties
    var camera: MTLLCamera!
    
    override init() {
        camera = MTLLCamera()
    }
    
    override func onNotify<SenderType>(_ sender: SenderType, _ message: String, _ data: [Float]) {
        switch message {
        case "move":
            for index in 0...data.count - 1 {
                camera.position[index] += data[index]
            }
        case "position":
            if data.count != 2 {
                print("Parameters aren't right - camera.position")
            }
            
            camera.position[Int(data[0])] = data[1]
        case "rotate":
            for index in 0...data.count - 1 {
                camera.rotation[index] += data[index]
            }
        case "reset":
            camera.position = float3(-30, 0, 0)
            camera.rotation = float3(0, 0, 0)
        default:
            print("This shouldn't happen - camera - ", message)
        }
    }
}
