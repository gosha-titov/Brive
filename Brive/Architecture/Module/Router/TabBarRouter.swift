import ModKit
import UIKit

/// A tab bar router that owns child routers.
///
/// The `TabBarRouter` class defines the shared behavior that’s common to all navigation routers.
/// You almost always subclass the `TabBarRouter` but you rarely implement it,
/// since each router has already organized flow logic between modules.
/// You usually do this as in the example below:
///
///     final class MainTabBarRouter: TabBarRouter<MainInteractor, MainBuilder> {}
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
/// The tab bar router uses a tab bar controller that manages a multiselection interface,
/// where the selection determines which child view controller to display.
/// If you need to modify this interface, use `tabBarController` property.
///
/// You need to set tab bar modules before this module is loaded, do it as in the example below:
///
///     router.tabBar = [.feed, .messages, .settings]
///
/// A tab bar router can transite to child module in two ways:
/// - use ``present(module:with:animated:completion:)`` method to present a child module modally,
/// + use ``select(module:with:)`` method to switch to a child module.
///
open class TabBarRouter<Interacting: RouterToInteractorInterface, Builder: Buildable>: PresentationRouter<Interacting, Builder>, TabBarControllable {
     
    // MARK: - Properties
    
    /// The tab bar modules.
    ///
    /// Before loading, you need to set all child modules in the order in which they should be displayed.
    ///
    ///     someRouter.tabBar = [.feed, .messages, .settings]
    ///
    /// The duplicate modules will be removed.
    public final var tabBar = [Module]() {
        didSet { tabBar.removeDuplicates() }
    }
    
    /// Returns a tab bar controller used for this module.
    public final var tabBarController: UITabBarController? {
        return view as? UITabBarController
    }
    
    
    // MARK: - Open Methods
    
    override open func route(to module: Module, with input: Value? = nil) {
        select(module: module, with: input)
    }
    
    
    // MARK: - Public Methods
    
    /// Switches to the given module.
    ///
    /// - Parameter module: A child module that will be displayed.
    /// - Parameter input: Some value that you want to pass to this module before it is displayed.
    ///
    public final func select(module: Module, with input: Value? = nil) -> Void {
        guard let index = tabBar.firstIndex(of: module), let tabBarController else { return }
        if let child = children[module] {
            pass(input, to: child)
        }
        tabBarController.selectedIndex = index
    }
    
    
    // MARK: - Internal Methods
    
    override func routerIsLoading() -> Void {
        let controller = UITabBarController()
        view = controller
        var views = [UIViewController]()
        for module in tabBar {
            let child = buildChildModuleIfNeeded(module)
            if let view = child.view {
                child.transition = .permanent
                views.append(view)
            }
        }
        controller.setViewControllers(views, animated: true)
    }
    
    override func didBuildChildModule(_ child: Routable) {
        if let child = child as? NavigationControllable {
            child.embedView()
        } else if child.view.isNil {
            child.view = .init()
        }
    }
    
}
