/// A type that is used as a router interface.
public protocol Routing: AnyObject {
    
    /// Modules that each parent router can run.
    /// To implement this, use `Enumeration`.
    associatedtype ChildModule
    
    /// Routes to the given module.
    func route(to module: ChildModule) -> Void
    
}
