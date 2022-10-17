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
/// In order to complete this module and show the parent one,
/// call ``complete(with:unloaded:animated:)`` method.
///
/// You can communicate with a parent through your child-to-parent interface:
///
///     if let parent = parent as? YourChildToParentInterface {
///         parent.doSomething()
///     }
///
/// **The essence of a parent router is to own child modules and route to them.**
/// Each child router is attached to its module.
///
/// The navigation router uses a navigation controller, that is, its view is embedded in the navigation interface.
///
/// Modules are built and activated when there is a transition to them.
/// If you need to load some modules in advance, specify them as in the example:
///
///     router.activatedModulesInAdvance = [.feed, .messages]
///
/// You can handle result of a child module's completion by overriding the ``childDidComplete(_:with:)`` method.
///
/// You have two kind of transition to child modules:
/// - use ``push(module:with:animated:)`` method to push a child module onto the navigation stack,
/// + use ``present(module:with:animated:completion:)`` method to present a child module modally.
///
/// Or you can use ``route(to:with:)`` method of `Routing` protocol that calls the first method.
///
open class NavigationRouter<Builder: Buildable>: PresentationRouter<Builder>, NavigationControllable {
    
    // MARK: - Properties
    
    /// An array of child modules that will be activated in advance.
    ///
    /// Add сhild modules here if you want them to be activated when this module does.
    /// These modules are not shown until it is needed.
    /// The duplicate modules will be removed.
    public final var activatedModulesInAdvance = [Module]() {
        didSet { activatedModulesInAdvance.removeDuplicates() }
    }
    
    /// Returns a navigation controller used for this module.
    public final var controller: UINavigationController? {
        return view as? UINavigationController
    }
    
    
    // MARK: - Open Methods
    
    override open func route(to module: Module, with input: Value? = nil) {
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
    public final func push(module: Module, with input: Value? = nil, animated: Bool = true) -> Void {
        
        guard let controller else { return }
        
        let child = buildChildModuleIfNeeded(module)
        if let input { child.receive(input) }
        
        if let view = child.view {
            controller.pushViewController(view, animated: animated)
            if child is NavigationControllable { child.view = controller }
            child.transition = .pushed
        } else {
            child.view = controller
        }
        
    }
    
    
    // MARK: - Internal Methods
    
    /// Embeds view in the navigation controller.
    func embedView() -> Void {
        let controller = UINavigationController()
        if let view {
            controller.pushViewController(view, animated: true)
            transition = .pushed
        }
        view = controller
    }
    
    override func routerIsActivating() {
        activatedModulesInAdvance.forEach { buildChildModuleIfNeeded($0) }
    }
    
}
