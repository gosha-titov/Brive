import UIKit

/// The default router that does not own child routers.
open class DefaultRouter: Routable {
    
    // MARK: - Properties
    
    /// The interactor that is responsible for business logic.
    public let interactor: RouterInteracting
    
    /// The parent router.
    var parent: Routable?
    
    
    // MARK: - Open Methods
    
    /// Called after the router is activated.
    /// - Note: Override this method to perform additional work.
    open func routerDidActivate() -> Void {}
    
    /// Called when the router is about to be deactivated.
    /// - Note: Override this method to perform additional work.
    open func routerWillDeactivate() -> Void {}
    
    
    // MARK: Internal Methods
    
    /// Activates this router.
    func activate() -> Void {
        interactor.activate()
        routerDidActivate()
    }
    
    /// Deactivates this router.
    func deactivate() -> Void {
        routerWillDeactivate()
        interactor.deactivate()
        detachParent()
    }
    
    
    // MARK: - Init
    
    public init(interactor: RouterInteracting) {
        self.interactor = interactor
    }
    
}
