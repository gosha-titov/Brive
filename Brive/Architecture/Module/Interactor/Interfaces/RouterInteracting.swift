/// An interface for the router trough which it communicates with this interactor.
public protocol RouterInteracting: AnyObject {
    
    /// Called when the router has been activated.
    func activate() -> Void
        
    /// Called when the router is about to be deactivated.
    func deactivate() -> Void
    
}
