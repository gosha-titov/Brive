import ModKit
import UIKit

/// The navigation router that owns child routers.
open class NavigationRouter<Module, Builder: Buildable>: ParentRouter<Module, Builder>, NavigationControllable, Routing where Builder.Module == Module {
    
    /// Modules that each parent router can run.
    ///
    /// Use `Enumeration` to implement this. For instance:
    ///
    ///     enum Module { case feed, messages, settings }
    ///
    public typealias Module = Module
    
    
    // MARK: - Properties
    
    /// The navigation controller.
    ///
    /// It is connected to the window root view controller, that is, it is displayed on the screen.
    /// You should never change the navigation controller to another,
    /// because this and the following modules will not be displayed.
    public final var rootController: UINavigationController?
    
    
    // MARK: - Public Methods
    
    /// Routes to the given module.
    ///
    /// This method pushes a view controller of the module onto the root's navigation stack.
    /// If module has not been built yet, then builds and activates it.
    public final func route(to module: Module) -> Void {
        
        guard let rootController = rootController else { return }
        
        if !children.hasKey(module) {
            let (child, view) = builder.build(module)
            attach(child, to: module)
            if let child = child as? NavigationControllable {
                view.executeSafely { rootController.pushViewController($0) }
                child.rootController = rootController
            } else if let child = child as? TabBarControllable {
                rootController.pushViewController(child.rootController)
            } else if let view = view {
                rootController.pushViewController(view)
            }
        }
        
        // TODO: attach child with view
    }
    
    
    // MARK: Internal Methods
    
    override func routerIsDeactivating() -> Void {
        detachAllChildren()
        rootController = nil
    }
    
}
