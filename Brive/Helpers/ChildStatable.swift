protocol ChildStatable: AnyObject {
    
    func state(of type: Any) -> DefaultModule.State
    
}
