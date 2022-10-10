import ModKit
import UIKit

/// A tab bar router that owns child routers.
///
/// The `TabBarRouter` class defines the shared behavior that’s common to all tab bar routers.
/// You rarely create instances of the `TabBarRouter` class directly.
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
/// The navigation router uses a tab bar controller that manages a multiselection interface,
/// where the selection determines which child view controller to display.
///
/// You need to set tab bar modules before this module is activated, do it as in the example:
///
///     router.tabBar = [.feed, .messages, .settings]
///
/// You have two kind of transition to child modules:
/// - use ``select(module:with:)`` method to switch to the module, but it doesn't work with unspecified modules,
/// + use ``present(module:with:animated:completion:)`` method to present a child module modally.
///
/// Or you can use ``route(to:with:)`` method of `Routing` protocol that calls the first method.
///
open class TabBarRouter<Module, Builder: Buildable>: PresentationRouter<Module, Builder>, TabBarControllable where Builder.Module == Module {
     
    // MARK: - Properties
    
    /// The tab bat controller.
    ///
    /// It is connected to the window root view controller, that is, it is displayed on the screen.
    public internal(set) var container = UITabBarController()
    
    /// The tab bar modules.
    ///
    /// Before activation, you need to set all child modules in the order in which they should be displayed.
    ///
    ///     someRouter.tabBar = [.feed, .messages, .settings]
    ///
    /// The duplicate modules will be removed.
    public final var tabBar = [Module]() {
        didSet { tabBar.removeDuplicates() }
    }
    
    
    // MARK: - Open Methods
    
    override open func route(to module: Module, with input: Input? = nil) {
        select(module: module, with: input)
    }
    
    
    // MARK: - Public Methods
    
    /// Switches to the given module.
    ///
    /// - Parameters:
    ///     - module: A child module that will be shown.
    ///     - input: Some value that you want to pass to this module before it is shown.
    ///
    public final func select(module: Module, with input: Input? = nil) -> Void {
        guard let index = tabBar.firstIndex(of: module) else { return }
        if let child = children[module], let input {
            child.receive(input)
        }
        container.selectedIndex = index
    }
    
    
    // MARK: - Internal Methods
    
    override func routerIsActivating() -> Void {
        var views = [UIViewController]()
        for module in tabBar {
            let child = build(module)
            if let child = child as? any NavigationControllable {
                views.append(child.container)
            } else if let child = child as? any TabBarControllable {
                views.append(child.container)
            } else if let view = child.view {
                views.append(view)
            }
        }
        container.setViewControllers(views, animated: true)
    }
    
    override func didBuild(_ child: DefaultRouter) {
        let view = child.view
        if let child = child as? any NavigationControllable {
            let container = UINavigationController()
            if let view { container.pushViewController(view) }
            child.container = container
        }
    }
    
}
