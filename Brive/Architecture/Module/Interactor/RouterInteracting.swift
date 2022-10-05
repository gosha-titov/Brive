/// A type that all interactor interfaces for routers should conform to.
public protocol RouterInteracting: AnyObject {
    
    /// Activates this interactor.
    func activate() -> Void
        
    /// Deactivates this interactor.
    func deactivate() -> Void
    
}
