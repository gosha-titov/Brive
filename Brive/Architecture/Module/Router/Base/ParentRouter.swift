import ModKit
import UIKit

/// The base router for tab bar and navigation routers.
open class ParentRouter<Module, Builder: Buildable>: DefaultRouter where Builder.Module == Module {
    
    // MARK: - Internal Properties
    
    /// The dictionary of routers that are children of the current router.
    var children = [Module: DefaultRouter]()
    
    /// The builder that builds child modules.
    let builder: Builder
    
    
    // MARK: - Internal Methods
    
    /// Attaches the given router to the module.
    func attach(_ child: DefaultRouter, to module: Module) -> Void {
        children[module] = child
        child.parent = self
        child.activate()
    }
    
    /// Detaches the child router from the module.
    func detachChild(from module: Module) -> Void {
        guard let child = children[module] else { return }
        children.removeValue(forKey: module)
        child.deactivate()
    }
    
    /// Detaches all child routers.
    func detachAllChildren() -> Void {
        children.values.forEach { $0.deactivate() }
        children.removeAll()
    }
    
    
    // MARK: - Init
    
    /// Creates a router with interactor and builder.
    public init(interactor: RouterInteracting, builder: Builder) {
        self.builder = builder
        super.init(interactor: interactor)
    }
    
}
