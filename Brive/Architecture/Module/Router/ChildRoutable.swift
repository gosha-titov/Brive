// MARK: - ChildRoutable

/// A type that all child routers should conform to.
public protocol ChildRoutable: ChildRouting, Controlling {}


// MARK: - ChildRouting

/// The base for all child routers.
public protocol ChildRouting: Routable {
    
    /// A parent router.
    var parent: Routable? { get set }
    
    /// Detaches the parent router.
    func detachParent() -> Void
    
}


public extension ChildRouting {
    
    func detachParent() -> Void {
        parent = nil
    }
    
}
