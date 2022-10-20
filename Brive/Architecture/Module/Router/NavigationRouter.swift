import ModKit
import UIKit

/// A navigation router that owns child routers.
///
/// The `NavigationRouter` class defines the shared behavior that’s common to all navigation routers.
/// You almost always subclass the `NavigationRouter` but you rarely implement it,
/// since each router has already organized flow logic between modules.
/// You usually do this as in the example below:
///
///     final class SettingsRouter: NavigationRouter<SettingsInteractor, SettingsBuilder> {}
///
/// But if you need to, then subclass it and add the methods and properties to manage the router.
///
/// The router's lifecycle is loading and unloading. The implementation is hidden,
/// but if you need to perform any additional work, override ``routerDidLoad()``
/// and ``routerWillUnload()`` methods.
///
/// In order to complete this module and display the parent one,
/// call ``complete(with:animateTransition:shouldKeepModuleLoaded:)`` method.
///
/// The navigation router uses a navigation controller, that is, its view is embedded in the navigation interface.
/// If you need to modify this interface, use `navigationController` property.
///
/// A navigation router can transite to child module in two ways:
/// - use ``present(module:with:animated:completion:)`` method to present a child module modally,
/// + use ``push(module:with:animated:)`` method to push a child module onto the navigation stack.
///
open class NavigationRouter<Interacting: RouterToInteractorInterface, Builder: Buildable>: PresentationRouter<Interacting, Builder>, NavigationControllable {
    
    // MARK: - Properties
    
    /// Returns a navigation controller used for this module.
    public final var navigationController: UINavigationController? {
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
        
        guard let navigationController else { return }
        
        let child = buildChildModuleIfNeeded(module)
        pass(input, to: child)
        
        if let view = child.view {
            navigationController.pushViewController(view, animated: animated)
            if child is NavigationControllable { child.view = navigationController }
            child.transition = .pushed
        } else {
            child.view = navigationController
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
    
}
