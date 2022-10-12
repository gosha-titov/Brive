import UIKit

/// A default router that doesn't own child routers.
///
/// The `DefaultRouter` class defines the shared behavior that’s common to all routers.
/// You rarely create instances of the `DefaultRouter` class directly.
/// Instead, you subclass it and add the methods and properties needed to manage the module.
///
/// The router's main responsibility is to activate and deactivate the module. The implementation is hidden,
/// but if you want to perform any additional work, override ``routerDidActivate()``
/// and ``routerWillDeactivate()`` methods.
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
open class DefaultRouter {
    
    /// Some data that is passed between parent and child modules.
    public typealias Value = Any
    
    /// A transition that is performed to the child module.
    enum Transition { case presented, pushed, selected }
    
    
    // MARK: - Properties
    
    /// The interactor that is responsible for business logic.
    public let interactor: RouterInteracting
    
    /// The parent router of this router.
    ///
    /// If this router does not a parent router, the value in this property is `nil`.
    public internal(set) var parent: DefaultRouter?
    
    /// The view to display.
    var view: UIViewController?
    
    /// The transition that was performed to this module.
    var transition: Transition?
    
    
    // MARK: - Open Methods
    
    /// Called before the module is shown if some data has been passed.
    ///
    /// Override this method to handle the input data.
    /// You don't need to call the `super` method.
    open func receive(_ input: Value) -> Void {}
    
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
    
    
    // MARK: - Public Methods
    
    /// Completes the module.
    ///
    /// It hides this module and shows the parent one.
    /// There are some cases when the method isn't executed:
    /// - The router doesn't have a parent,
    /// + The router is a tab of the parent tab bar router.
    ///
    /// - Parameter result: You can pass some data to the parent router. Default value is `nil`.
    /// - Parameter unloaded: Pass `false` to keep this module loaded while the parent is loaded; otherwise, pass `true`. Default value is `true`.
    /// - Parameter animated: Pass `true` to animate the transition; otherwise, pass `false`. Default value is `true`.
    ///
    public final func complete(with result: Value? = nil, unloaded: Bool = true, animated: Bool = true) -> Void {
        guard let parent = parent as? ChildCancelable else { return }
        parent.cancel(self, with: result, unloaded, animated)
    }
    
    
    // MARK: - Internal Methods
    
    /// Called when the router is activating.
    func routerIsActivating() -> Void {}
    
    /// Called when the router is deactivating.
    func routerIsDeactivating() -> Void {}
    
    
    /// Activates this router and therefore its module.
    final func activate() -> Void {
        routerIsActivating()
        interactor.activate()
        routerDidActivate()
    }
    
    /// Deactivates this router and therefore its module.
    final func deactivate() -> Void {
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
    
    deinit { deactivate() }
    
}
