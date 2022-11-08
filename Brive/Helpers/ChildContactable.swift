protocol ChildContactable: AnyObject {
    
    func receiveFromChild(_ sender: Any, _ value: Any) -> Void
    
    func passToChild(_ receiver: Any, _ value: Any) -> Void
    
}
