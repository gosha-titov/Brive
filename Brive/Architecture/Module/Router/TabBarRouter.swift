import ModKit
import UIKit

/// The tab bar router that owns child routers.
open class TabBarRouter<Module, Builder: Buildable>: ParentRouter<Module, Builder>, TabBarControllable, Routing where Builder.Module == Module {
    
    /// Modules that each parent router can run.
    ///
    /// To implement this, use `Enumeration`. For instance:
    ///
    ///     enum Module { case feed, messages, settings }
    ///
    public typealias Module = Module
    
    
    // MARK: - Properties
    
    /// The tab bat controller.
    ///
    /// It is connected to the window root view controller, that is, it is displayed on the screen.
    /// You should never change the tab bar controller to another,
    /// because this and the following modules will not be displayed.
    public final var rootController = UITabBarController()
    
    /// The tab bar modules.
    ///
    /// Before activation, you must set all child modules in the order in which they should be displayed.
    ///
    ///     someRouter.tabBar = [.feed, .messages, .settings]
    ///
    /// The duplicate modules will be removed.
    public final var tabBar = [Module]() {
        didSet { tabBar.removeDuplicates() }
    }
    
    
    // MARK: - Public Methods
    
    /// Routes to the given module.
    /// - Parameters:
    ///     - module: A child module that will be shown.
    ///     - input: Some value that you want to pass to this module before it is shown.
    ///
    public final func route(to module: Module, with input: Input? = nil) -> Void {
        guard let index = tabBar.firstIndex(of: module) else { return }
        if let (child, _) = children[module] {
            input.executeSafely { child.receive($0) }
        }
        rootController.selectedIndex = index
    }
    
    
    // MARK: Internal Methods
    
    override func routerIsActivating() -> Void {
        var views = [UIViewController]()
        for module in tabBar {
            let (child, view) = builder.build(module)
            attach(child, with: view, to: module)
            if let child = child as? NavigationControllable {
                let controller = UINavigationController()
                child.rootController = controller
                view.executeSafely { controller.pushViewController($0) }
                views.append(controller)
            } else if let child = child as? TabBarControllable {
                views.append(child.rootController)
            } else {
                view.executeSafely { views.append($0) }
            }
        }
        rootController.setViewControllers(views, animated: true)
    }
    
    override func routerIsDeactivating() -> Void {
        detachAllChildren()
    }
    
}
