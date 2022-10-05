import UIKit

// MARK: - ParentRoutable

/// The base for all parent routers.
public protocol ParentRoutable: ParentRouting, Controlling {
    
    /// Modules that each parent router can run.
    /// To implement this, use `Enumeration`.
    associatedtype ChildModule
    
    /// A type that builds modules.
    associatedtype Builder: Buildable where Builder.Module == ChildModule
    
    /// The builder that builds child routers.
    var builder: Builder { get }
    
    /// The list of child routers.
    var children: [ChildRouting] { get set }
    
    /// Attaches the child router of the given module.
    /// - Returns: A child router that was created.
    func attachChild(of module: ChildModule) -> UIViewController
    
    /// Detachesthe child router of the given module.
    func detachChild(of module: ChildModule) -> Void
    
}


public extension ParentRoutable {
    
    func attachChild(of module: ChildModule) -> UIViewController {
        let (child, view) = builder.build(module: module)
        children.append(child)
        child.parent = self
        child.activate()
        return view
    }
    
    func detachChild(of module: ChildModule) -> Void {
        let (child, _) = builder.build(module: module)
        let detachedChildren = children.filter { $0 === child }
        detachedChildren.forEach { $0.deactivate() }
        children = children.filter { $0 !== child }
    }
    
    func detachChilder() -> Void {
        children.forEach { $0.deactivate() }
        children.removeAll()
    }
    
}


// MARK: - ParentRouting

/// The base for all parent routers.
public protocol ParentRouting: Routable {
    
    /// Detaches the child routers.
    func detachChilder() -> Void
    
}
