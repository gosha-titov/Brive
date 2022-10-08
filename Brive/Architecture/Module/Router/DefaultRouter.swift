import UIKit

/// The default router that does not own child routers.
open class DefaultRouter {
    
    /// Some data that is passed between parent and child modules.
    public typealias Input = Any
    
    
    // MARK: - Properties
    
    /// The interactor that is responsible for business logic.
    public let interactor: RouterInteracting
    
    /// The parent router of this router.
    ///
    /// If this router does not a parent router, the value in this property is `nil`.
    /// You should never change this property.
    public final var parent: DefaultRouter?
    
    /// The view that will be displayed.
    var view: UIViewController?
    
    
    // MARK: - Open Methods
    
    /// Called before the module is shown if some data has been passed.
    ///
    /// Override this method to handle the input data.
    /// You don't need to call the `super` method.
    /// You should never call this method.
    open func receive(_ input: Input) -> Void {}
    
    /// Called after the router is activated.
    ///
    /// Override this method to perform additional work.
    /// You don't need to call the `super` method.
    /// You should never call this method.
    open func routerDidActivate() -> Void {}
    
    /// Called when the router is about to be deactivated.
    ///
    /// Override this method to perform additional work.
    /// You don't need to call the `super` method.
    /// You should never call this method.
    open func routerWillDeactivate() -> Void {}
    
    
    // MARK: Internal Methods
    
    /// Called when the router is activating.
    func routerIsActivating() -> Void {}
    
    /// Called when the router is deactivating.
    func routerIsDeactivating() -> Void {}
    
    
    /// Activates this router.
    ///
    /// It activates this router and therefore the module.
    /// If you want to perform any additional work, do so in the `routerDidActivate()` method.
    func activate() -> Void {
        routerIsActivating()
        routerDidActivate()
        interactor.activate()
    }
    
    /// Deactivates this router.
    ///
    /// It deactivates this router and therefore the module.
    /// If you want to perform any additional work, do so in the `routerWillDeactivate()` method.
    func deactivate() -> Void {
        routerWillDeactivate()
        interactor.deactivate()
        routerIsDeactivating()
        parent = nil
        view = nil
    }
    
    
    // MARK: - Init
    
    /// Creates a router with interactor.
    public init(interactor: RouterInteracting) {
        self.interactor = interactor
    }
    
    deinit {
        deactivate()
    }
    
}
