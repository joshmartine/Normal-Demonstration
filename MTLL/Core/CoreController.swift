// jm

class Controller {    
    func onNotify<SenderType>(_ sender: SenderType, _ message: String, _ data: [Float]) { }
}

class CoreController: Controller {
    //MARK: - Properties
    var cameraController: MTLLCameraController
    
    //MARK: - Initialization
    override init() {
        cameraController = MTLLCameraController()
    }
    
    override func onNotify<SenderType>(_ sender: SenderType, _ message: String, _ data: [Float]) {
        var messageComponents = message.components(separatedBy: ".")
        let classToNotify = messageComponents.remove(at: 0)
        
        switch classToNotify {
        case "camera":
            cameraController.onNotify(sender, messageComponents.joined(separator: "."), data)
        default:
            print("not working yet")
        }
    }
}

