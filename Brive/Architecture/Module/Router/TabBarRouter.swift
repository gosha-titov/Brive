import ModKit
import UIKit

/// The tab bar router that owns child routers.
open class TabBarRouter<Module, Builder: Buildable>: PresentationRouter<Module, Builder>, TabBarControllable, Routing where Builder.Module == Module {
    
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
    public final var container = UITabBarController()
    
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
        if let child = children[module], let input {
            child.receive(input)
        }
        container.selectedIndex = index
    }
    
    
    // MARK: Internal Methods
    
    override func routerIsActivating() -> Void {
        var views = [UIViewController]()
        for module in tabBar {
            let (child, view) = builder.build(module)
            attach(child, to: module)
            child.view = view
            if let child = child as? NavigationControllable {
                let controller = UINavigationController()
                child.container = controller
                if let view { controller.pushViewController(view) }
                views.append(controller)
            } else if let child = child as? TabBarControllable {
                views.append(child.container)
            } else {
                if let view { views.append(view) }
            }
        }
        container.setViewControllers(views, animated: true)
    }
    
    override func routerIsDeactivating() -> Void {
        detachAllChildren()
    }
    
}
