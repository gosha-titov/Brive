/// An interface for the router trough which it communicates with this interactor.
public protocol RouterInteracting: AnyObject {
    
    /// Activates this interactor.
    func activate() -> Void
        
    /// Deactivates this interactor.
    func deactivate() -> Void
    
}
