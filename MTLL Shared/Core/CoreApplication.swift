// jm

class CoreApplication {
    
    public let model: CoreModel
    public let view: CoreView
    public let controller: CoreController
    
    init() {
        model = CoreModel()
        view = CoreView()
        controller = CoreController()
    }
    
    public func notify<SenderType, DataType>(_ message: String, _ sender: SenderType, _ data: DataType = "") {
        
    }
}
