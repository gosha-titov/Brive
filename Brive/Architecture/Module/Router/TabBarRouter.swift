import ModKit
import UIKit

/// A tab bar router that owns child routers.
///
/// The `TabBarRouter` class defines the shared behavior that’s common to all tab bar routers.
/// You rarely create instances of the `TabBarRouter` class directly.
/// Instead, you subclass it and add the methods and properties needed to manage the module.
///
/// The router's main responsibility is to load and unload the module. The implementation is hidden,
/// but if you want to perform any additional work, override ``routerDidLoad()``
/// and ``routerWillUnload()`` methods.
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
/// The tab bar router uses a tab bar controller that manages a multiselection interface,
/// where the selection determines which child view controller to display.
///
/// You need to set tab bar modules before this module is activated, do it as in the example:
///
///     router.tabBar = [.feed, .messages, .settings]
///
/// You can handle result of a child module's completion by overriding the ``childDidComplete(_:with:)`` method.
///
/// You have two kind of transition to child modules:
/// - use ``select(module:with:)`` method to switch to the module, but it doesn't work with unspecified modules,
/// + use ``present(module:with:animated:completion:)`` method to present a child module modally.
///
/// Or you can use ``route(to:with:)`` method of `Routing` protocol that calls the first method.
///
open class TabBarRouter<Builder: Buildable, Interacting: RouterToInteractorInterface>: PresentationRouter<Builder, Interacting>, TabBarControllable {
     
    // MARK: - Properties
    
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
    
    /// Returns a tab bar controller used for this module.
    public final var controller: UITabBarController? {
        return view as? UITabBarController
    }
    
    
    // MARK: - Open Methods
    
    override open func route(to module: Module, with input: Value? = nil) {
        select(module: module, with: input)
    }
    
    
    // MARK: - Public Methods
    
    /// Switches to the given module.
    ///
    /// - Parameters:
    ///     - module: A child module that will be shown.
    ///     - input: Some value that you want to pass to this module before it is shown.
    ///
    public final func select(module: Module, with input: Value? = nil) -> Void {
        guard let index = tabBar.firstIndex(of: module), let controller else { return }
        if let child = children[module] {
            if let input { child.parentWillDisplay(with: input) }
        }
        controller.selectedIndex = index
    }
    
    
    // MARK: - Internal Methods
    
    override func routerIsLoading() -> Void {
        let controller = UITabBarController()
        view = controller
        var views = [UIViewController]()
        if tabBar.isEmpty { tabBar = allChildModules }
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
