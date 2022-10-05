import UIKit

/// The tab bar router that owns child routers.
open class TabBarRouter<Module, Builder: Buildable>: DefaultRouter, ParentRoutable, TabBarControllable where Builder.Module == Module {
    
    // MARK: - Properties
    
    /// The navigation controller that binds other routers together,
    /// allowing you to move to the selected module.
    public final var controller = UITabBarController()
    
    /// The tab bar to display.
    /// - Important: Before activation, It must contain all modules.
    public final var tabBar = [Module]()
    
    /// The list of child routers.
    var children = [Routable]()
    
    /// The builder that builds child modules.
    let builder: Builder
    
    
    // MARK: - Internal Methods
    
    /// Activates this router.
    override func activate() -> Void {
        interactor.activate()
            
        var views = [UIViewController]()
        for module in tabBar {
            let (child, view) = builder.build(module: module)
            attach(child: child)
            if let child = child as? NavigationControllable {
                let controller = UINavigationController()
                child.controller = controller
                if let view = view { controller.pushViewController(view, animated: true) }
                views.append(controller)
            } else if let child = child as? TabBarControllable {
                views.append(child.controller)
            } else if let view = view {
                views.append(view)
            }
        }
        controller.setViewControllers(views, animated: true)
        
        routerDidActivate()
    }
    
    /// Deactivates this router.
    override func deactivate() -> Void {
        routerWillDeactivate()
        interactor.deactivate()
        detachChildren()
        detachParent()
    }
    
    
    // MARK: - Init
    
    public init(interactor: RouterInteracting, builder: Builder) {
        self.builder = builder
        super.init(interactor: interactor)
    }
    
}
