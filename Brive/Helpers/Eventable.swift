protocol Eventable: AnyObject {
    
    func activate() -> Void
    
    func deactivate() -> Void
    
}
