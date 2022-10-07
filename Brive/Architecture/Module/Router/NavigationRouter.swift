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
    
    /// An array of child modules that will be activated in advance.
    ///
    /// Add сhild modules here if you want them to be activated when this module does.
    /// These modules are not shown until it is needed.
    public final var modulesThatMustBeActivatedInAdvance = [Module]()
    
    
    // MARK: - Public Methods
    
    /// Routes to the given module.
    ///
    /// This method pushes a view controller of the module onto the root's navigation stack.
    /// If module has not been built yet, then builds and activates it.
    /// - Parameters:
    ///     - module: A child module that will be shown.
    ///     - input: Some value that you want to pass to this module before it is shown.
    ///
    public final func route(to module: Module, with input: Input? = nil) -> Void {
        
        guard let rootController = rootController else { return }
        if !children.hasKey(module) { create(module) }
        
        guard let (child, view) = children[module] else { return }
        input.executeSafely { child.receive($0) }
        
        if let child = child as? TabBarControllable {
            rootController.pushViewController(child.rootController)
        } else {
            view.executeSafely { rootController.pushViewController($0) }
        }
        
    }
    
    
    // MARK: Internal Methods
    
    override func routerIsActivating() {
        modulesThatMustBeActivatedInAdvance.forEach { create($0) }
    }
    
    override func routerIsDeactivating() -> Void {
        detachAllChildren()
        rootController = nil
    }
    
    /// Creates the given module.
    func create(_ module: Module) -> Void {
        let (child, view) = builder.build(module)
        attach(child, with: view, to: module)
        if let child = child as? NavigationControllable {
            child.rootController = rootController
        }
    }
    
}
