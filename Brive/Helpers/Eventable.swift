protocol Eventable: AnyObject {
    
    func activate() -> Void
    
    func suspend() -> Void
    
    func resume() -> Void
    
    func deactivate() -> Void
    
}
