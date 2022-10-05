/// The base protocol for all routers.
public protocol Routable: Eventing {
    
    /// The interactor that is responsible for business logic.
    var interactor: RouterInteracting { get }
    
}


public extension Routable {
    
    /// Activates this module.
    func activate() -> Void {
        interactor.activate()
    }
    
    /// Deactivates this module.
    func deactivate() -> Void {
        interactor.deactivate()
        if let self = self as? ParentRouting {
            self.detachChilder()
        }
        if let self = self as? ChildRouting {
            self.detachParent()
        }
    }
    
}
