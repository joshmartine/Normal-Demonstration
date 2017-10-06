// jm

protocol Controller: CoreElement {
    func onNotify<SenderType, DataType>(_ message: String, _ sender: SenderType, _ data: DataType...)
}

class CoreController: Controller {
    
}
