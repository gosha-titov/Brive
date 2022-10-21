import UIKit

/// A default router that doesn't own child routers.
///
/// The `DefaultRouter` class defines the shared behavior that’s common to all routers.
/// You almost always subclass the `DefaultRouter` but you rarely implement it,
/// since each router has already organized flow logic between modules.
/// You usually do this as in the example below:
///
///     final class SettingsRouter: DefaultRouter<SettingsInteractor> {}
///
/// But if you need to, then subclass it and add the methods and properties to manage the router.
///
/// The router's lifecycle is loading and unloading. The implementation is hidden,
/// but if you need to perform any additional work, override ``routerDidLoad()``
/// and ``routerWillUnload()`` methods.
///
/// In order to complete this module and display the parent one,
/// call ``complete(with:animated:shouldKeepModuleLoaded:)`` method.
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
    /// - Parameter output: You can pass some data to the parent router. Default value is `nil`.
    /// - Parameter animated: Pass `true` to animate the transition; otherwise, pass `false`. Default value is `true`.
    /// - Parameter loaded: Pass `true` to keep this module loaded while the parent is loaded; otherwise, pass `false`. Default value is `false`.
    ///
    public final func complete(with output: Value? = nil, animated: Bool = true, shouldKeepModuleLoaded loaded: Bool = false) -> Void {
        guard let parent = parent as? ChildHideable else { return }
        parent.hide(self, with: output, animateTransition: animated, shouldKeepLoaded: loaded)
    }
    
    
    // MARK: - Internal Methods
    
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
    
    final override func suspend() -> Void {
        guard let interactor = interactor as? Eventable else { return }
        interactor.suspend()
    }
    
    final override func resume() -> Void {
        guard let interactor = interactor as? Eventable else { return }
        interactor.resume()
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


extension DefaultRouter: ParentDisplayable {
    
    /// Called before the parent module displayes this module.
    final func parentWillDisplayModule(with input: Value?) -> Void {
        guard let interactor = interactor as? ParentDisplayable else { return }
        interactor.parentWillDisplayModule(with: input)
    }
    
}


extension DefaultRouter: ParentCommunicable {
    
    /// Called when the parent module passes some value.
    final func receiveFromParent(_ value: Value) -> Void {
        guard let interactor = interactor as? ParentCommunicable else { return }
        interactor.receiveFromParent(value)
    }
    
    /// Passes some value to a parent interactor.
    final func passToParent(_ value: Value) -> Void {
        guard let parent = parent as? ChildCommunicable else { return }
        parent.receiveFromChild(self, value)
    }
    
}
