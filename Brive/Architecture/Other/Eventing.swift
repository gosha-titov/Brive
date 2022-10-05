/// A type that allows you to manage the `activate` and `deactivate` events.
public protocol Eventing: AnyObject {
    
    /// Activates this object.
    func activate() -> Void
        
    /// Deactivates this object.
    func deactivate() -> Void
    
}
