protocol ParentCommunicable: AnyObject {
    
    func receiveFromParent(_ value: Any) -> Void
    
    func passToParent(_ value: Any) -> Void 
    
}
