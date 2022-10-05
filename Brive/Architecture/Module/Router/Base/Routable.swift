/// The base protocol for all routers.
protocol Routable: AnyObject {
    
    /// The interactor that is responsible for business logic.
    var interactor: RouterInteracting { get }
    
    /// A parent router.
    var parent: Routable? { get set }
    
    /// Detaches the parent router.
    func detachParent() -> Void
    
    /// Activates this router.
    func activate() -> Void
    
    /// Deactivates this router.
    func deactivate() -> Void
    
}


extension Routable {
    
    func detachParent() -> Void {
        parent = nil
    }
    
}
