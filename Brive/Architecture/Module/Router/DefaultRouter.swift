import UIKit

/// The default router that does not own child routers.
open class DefaultRouter {
    
    // MARK: - Properties
    
    /// The interactor that is responsible for business logic.
    public let interactor: RouterInteracting
    
    /// The parent router of this router.
    ///
    /// If this router does not a parent router, the value in this property is `nil`.
    /// You should never change this property directly.
    public final var parent: DefaultRouter?
    
    
    // MARK: - Open Methods
    
    /// Called after the router is activated.
    ///
    /// Override this method to perform additional work.
    /// You don't need to call the `super` method.
    open func routerDidActivate() -> Void {}
    
    /// Called when the router is about to be deactivated.
    ///
    /// Override this method to perform additional work.
    /// You don't need to call the `super` method.
    open func routerWillDeactivate() -> Void {}
    
    
    // MARK: Internal Methods
    
    /// Called when the router is activating.
    func routerIsActivating() -> Void {}
    
    /// Called when the router is deactivating.
    func routerIsDeactivating() -> Void {}
    
    
    /// Activates this router.
    ///
    /// You should never call this method directly. It activates this router and therefore the module.
    /// If you want to perform any additional work, do so in the `routerDidActivate()` method.
    func activate() -> Void {
        interactor.activate()
        routerIsActivating()
        routerDidActivate()
    }
    
    /// Deactivates this router.
    ///
    /// You should never call this method directly.  It deactivates this router and therefore the module.
    /// If you want to perform any additional work, do so in the `routerWillDeactivate()` method.
    func deactivate() -> Void {
        routerWillDeactivate()
        routerIsDeactivating()
        interactor.deactivate()
        parent = nil
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
