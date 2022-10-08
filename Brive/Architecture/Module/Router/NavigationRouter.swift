import ModKit
import UIKit

/// The navigation router that owns child routers.
open class NavigationRouter<Module, Builder: Buildable>: PresentationRouter<Module, Builder>, NavigationControllable, Routing where Builder.Module == Module {
    
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
    public final var container: UINavigationController?
    
    /// An array of child modules that will be activated in advance.
    ///
    /// Add сhild modules here if you want them to be activated when this module does.
    /// These modules are not shown until it is needed.
    /// The duplicate modules will be removed.
    public final var activatedModulesInAdvance = [Module]() {
        didSet { activatedModulesInAdvance.removeDuplicates() }
    }
    
    
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
        
        guard let container = container else { return }
        if !children.hasKey(module) { build(module) }
        
        guard let child = children[module] else { return }
        if let input { child.receive(input) }
        
        if let child = child as? TabBarControllable {
            container.pushViewController(child.container)
        } else {
            child.view.executeSafely { container.pushViewController($0) }
        }
        
    }
    
    
    // MARK: Internal Methods
    
    override func routerIsActivating() {
        activatedModulesInAdvance.forEach { build($0) }
    }
    
    override func routerIsDeactivating() -> Void {
        detachAllChildren()
        container = nil
    }
    
}
