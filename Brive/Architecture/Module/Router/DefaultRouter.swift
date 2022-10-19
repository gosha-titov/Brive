import UIKit

/// A default router that doesn't own child routers.
///
/// The `DefaultRouter` class defines the shared behavior that’s common to all routers.
/// You rarely create instances of the `DefaultRouter` class directly.
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
open class DefaultRouter<Interacting: RouterToInteractorInterface>: Routable {
    
    /// Some data that is passed between parent and child modules.
    public typealias Value = Any
    
    
    // MARK: - Properties
    
    /// The interactor that is responsible for business logic.
    public let interactor: Interacting
    
    
    // MARK: - Open Methods
    
    /// Called after the router is loaded.
    ///
    /// Override this method to perform additional work.
    /// You don't need to call the `super` method.
    open func routerDidLoad() -> Void {}
    
    /// Called when the router is about to be unloaded.
    ///
    /// Override this method to perform additional work.
    /// You don't need to call the `super` method.
    open func routerWillUnload() -> Void {}
    
    
    // MARK: - Public Methods
    
    /// Completes the module.
    ///
    /// It hides this module and shows the parent one.
    /// There are some cases when the method isn't executed:
    /// - The router doesn't have a parent,
    /// + The router is a tab of the parent tab bar router.
    ///
    /// - Parameter result: You can pass some data to the parent router. Default value is `nil`.
    /// - Parameter loaded: Pass `true` to keep this module loaded while the parent is loaded; otherwise, pass `false`. Default value is `true`.
    /// - Parameter animated: Pass `true` to animate the transition; otherwise, pass `false`. Default value is `true`.
    ///
    public final func complete(with result: Value? = nil, loaded: Bool = true, animated: Bool = true) -> Void {
        guard let parent = parent as? ChildHideable else { return }
        parent.hide(self, with: result, animated, keep: loaded)
    }
    
    
    // MARK: - Internal Methods
    
    /// Called before the parent module displayes this module.
    final func parentWillDisplay(with input: Value?) -> Void {
        guard let interactor = interactor as? ParentDisplayable else { return }
        interactor.parentWillDisplay(with: input)
    }
    
    /// Called when the parent module passes some value.
    final func receiveFromParent(_ value: Value) -> Void {
        guard let interactor = interactor as? Receivable else { return }
        interactor.receiveFromParent(value)
    }
    
    /// Passes some value to a parent interactor.
    final func passToParent(_ value: Value) -> Void {
        guard let parent else { return }
        parent.receiveFromChild(self, value)
    }
    
    /// Called when the router is loading.
    func routerIsLoading() -> Void {}
    
    /// Called when the router is unloading.
    func routerIsUnloading() -> Void {}
    
    /// Loads this router and therefore its module.
    final override func load() -> Void {
        guard let interactor = interactor as? Eventable else { return }
        routerIsLoading()
        routerDidLoad()
        interactor.activate()
    }
    
    /// Unloads this router and therefore its module.
    final override func unload() -> Void {
        guard let interactor = interactor as? Eventable else { return }
        routerWillUnload()
        interactor.deactivate()
        routerIsUnloading()
        parent = nil
        view = nil
    }
    
    
    // MARK: - Init
    
    /// Creates a router with interactor.
    public init(interactor: Interacting) {
        self.interactor = interactor
    }
    
    deinit { unload() }
    
}
