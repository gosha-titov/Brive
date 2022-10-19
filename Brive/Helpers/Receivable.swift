protocol Receivable: AnyObject {
    
    func receiveFromChild(_ sender: Any, _ value: Any) -> Void
    
    func receiveFromParent(_ value: Any) -> Void
    
}


extension Receivable {
    
    func receiveFromChild(_ sender: Any, _ value: Any) -> Void {}
    
    func receiveFromParent(_ value: Any) -> Void {}
    
}
