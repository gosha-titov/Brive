import ModKit
import UIKit

/// A navigation router that owns child routers.
///
/// The `NavigationRouter` class defines the shared behavior that’s common to all navigation routers.
/// You rarely create instances of the `NavigationRouter` class directly.
/// Instead, you subclass it and add the methods and properties needed to manage the module.
///
/// The router's main responsibility is to activate and deactivate the module. The implementation is hidden,
/// but if you want to perform any additional work, override ``routerDidActivate()``
/// and ``routerWillDeactivate()`` methods.
///
/// The router can receive some data from its parent before being displayed.
/// To handle this, override ``receive(_:)`` method.
///
/// **The essence of a parent router is to own child modules and route to them.**
///
/// Each child router is attached to its module. Use `Enumeration` to create modules as it's done in the example:
///
///     enum SomeModule { case feed, messages, settings }
///
/// Pay attention, that the router and builder `Module` structs are the same.
///
/// The navigation router uses a navigation controller, that is, its view is embedded in the navigation interface.
///
/// Modules are built and activated when there is a transition to them.
/// If you need to load some modules in advance, specify them as in the example:
///
///     router.activatedModulesInAdvance = [.feed, .messages]
///
/// You have two kind of transition to child modules:
/// - use ``push(module:with:animated:)`` method to push a child module onto the navigation stack,
/// + use ``present(module:with:animated:completion:)`` method to present a child module modally.
///
/// Or you can use ``route(to:with:)`` method of `Routing` protocol that calls the first method.
///
open class NavigationRouter<Module, Builder: Buildable>: PresentationRouter<Module, Builder>, NavigationControllable where Builder.Module == Module {
    
    // MARK: - Properties
    
    /// The navigation controller.
    ///
    /// It is connected to the window root view controller, that is, it is displayed on the screen.
    public internal(set) var container = UINavigationController()
    
    /// An array of child modules that will be activated in advance.
    ///
    /// Add сhild modules here if you want them to be activated when this module does.
    /// These modules are not shown until it is needed.
    /// The duplicate modules will be removed.
    public final var activatedModulesInAdvance = [Module]() {
        didSet { activatedModulesInAdvance.removeDuplicates() }
    }
    
    
    // MARK: - Open Methods
    
    override open func route(to module: Module, with input: Input? = nil) {
        push(module: module, with: input)
    }
    
    
    // MARK: - Public Methods
    
    /// Pushes the given module onto the navigation stack and updates the display.
    ///
    /// If module has not been built yet, then this method builds, activates and pushes it.
    ///
    /// - Parameter module: A child module to display.
    /// - Parameter input: Some value to pass to this module before the module is displayed.
    /// - Parameter animated: Pass `true` to animate the transition; otherwise, pass `false`.
    ///
    public final func push(module: Module, with input: Input? = nil, animated: Bool = true) -> Void {
        
        // Build a module.
        if !children.hasKey(module) { build(module) }
        guard let child = children[module] else { return }
        if let input { child.receive(input) }
        
        // Look for a view that can be pushed.
        var viewToPush: UIViewController? = child.view
        if let child = child as? any TabBarControllable {
            viewToPush = child.container
        }
        
        // Try to push
        if let viewToPush {
            container.pushViewController(viewToPush, animated: animated)
        } else {
            child.view = container
        }
        
    }
    
    
    // MARK: - Internal Methods
    
    override func routerIsActivating() {
        activatedModulesInAdvance.forEach { build($0) }
    }
    
    override func didBuild(_ child: DefaultRouter) {
        if let child = child as? any NavigationControllable {
            child.container = container
        }
    }
    
}
