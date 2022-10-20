protocol ChildCommunicable: AnyObject {
    
    func receiveFromChild(_ sender: Any, _ value: Any) -> Void
    
    func passToChild(_ module: Any, _ value: Any) -> Void
    
}
