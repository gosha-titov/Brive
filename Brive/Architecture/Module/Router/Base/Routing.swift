/// A type that is used as a router interface.
public protocol Routing: AnyObject {
    
    associatedtype Module: Hashable
    
    /// Routes to the given module.
    func route(to module: Module, with input: DefaultRouter.Value?) -> Void
    
}
