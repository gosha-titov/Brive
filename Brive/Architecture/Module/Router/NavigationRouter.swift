import UIKit

/// The navigation router that owns child routers. 
open class NavigationRouter<Module, Builder: Buildable>: DefaultRouter, ParentRoutable, NavigationControllable, Routing where Builder.Module == Module {
    
    // MARK: - Properties
    
    /// The navigation controller that binds other routers together,
    /// allowing you to move through the navigation stack.
    public final var controller: UINavigationController?
    
    /// The list of child routers.
    var children = [Routable]()
    
    /// The builder that builds child modules.
    let builder: Builder
    
    
    // MARK: - Public Methods
    
    /// Routes to the given module.
    public final func route(to module: Module) -> Void {
        guard let controller = controller else { return }
        let (child, view) = builder.build(module: module)
        attach(child: child)
        if let child = child as? NavigationControllable {
            if let view = view { controller.pushViewController(view, animated: true) }
            child.controller = controller
        } else if let child = child as? TabBarControllable {
            controller.pushViewController(child.controller, animated: true)
        } else if let view = view {
            controller.pushViewController(view, animated: true)
        }
    }
    
    
    // MARK: Internal Methods
    
    /// Activates this router.
    override func activate() -> Void {
        interactor.activate()
        routerDidActivate()
    }
    
    /// Deactivates this router.
    override func deactivate() -> Void {
        routerWillDeactivate()
        interactor.deactivate()
        controller = nil
        detachChildren()
        detachParent()
    }
    
    
    // MARK: - Init
    
    public init(interactor: RouterInteracting, builder: Builder) {
        self.builder = builder
        super.init(interactor: interactor)
    }
    
}
