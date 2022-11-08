/// A default interactor which module doesn't own child modules.
///
/// The `DefaultInteractor` class defines the shared behavior that’s common to all interactors.
/// You rarely create instances of the `DefaultInteractor` class directly.
/// Instead, you subclass it and add the methods and properties needed to manage the business logic of this module.
///
/// If this module should not have an associated `View`, then use the ``NonViewing`` protocol as in the example below:
///
///     class SomeInteractor: DefaultInteractor<..., NonViewing>
///
/// The module's lifecycle consists of: activation and deactivation, but between them there can also be suspening and resuming.
/// The implementation is hidden, but if you need to perform any additional work,
/// override ``moduleDidActivate()``, ``moduleWillSuspend()``, ``moduleDidResume()``
/// and/or ``moduleWillDeactivate()`` methods.
///
/// The `state` property is indicating the current state of the module that is active or inactive.
///
/// When a parent module is about to display this module, it can pass some input data.
/// To handle this, override ``parent(willDisplayModuleByPassing:)`` method.
///
/// A parent module can pass some data to this module while it's active.
/// To handle this, override ``parent(didPass:)`` method.
///
/// In order to pass some data to a parent module, call ``pass(_:to:)`` method.
///
open class DefaultInteractor<Routing: InteractorToRouterInterface, Viewing: InteractorToViewInterface>: Interactable {
    
    /// A type that associating with a parent module.
    public enum ParentReceiver { case parent }
    
    
    // MARK: - Public Properties
    
    /// A State value that indicating the current state of the module.
    ///
    /// There are only two possible states: active and inactive.
    public final var state: DefaultModule.State { module?.state ?? .inactive }
    
    /// The router that is responsible for navigation between screens.
    ///
    /// You can access this router only if the state of the module is active;
    /// otherwise the value in this property is `nil`.
    public final var router: Routing? {
        return state == .active ? _router : nil
    }
    
    /// The view that is responsible for configurating and updating UI, catching and handling user interactions.
    ///
    /// You can access this view only if the state of the module is active;
    /// otherwise the value in this property is `nil`.
    ///
    /// The view of the `NonViewing` type is always `nil`.
    public final var view: Viewing? {
        if _view is NonViewing { return nil }
        return state == .active ? _view : nil
    }
    
    
    // MARK: Private Properties
    
    /// The private router of this interactor.
    private var _router: Routing? { module?.router as? Routing }
    
    /// The private view of this interactor.
    private var _view: Viewing? { module?.view as? Viewing }
    
    
    // MARK: - Open Methods
    
    /// Called before the parent module displayes this module.
    ///
    /// Override this method to perform any additional work and/or to handle the input.
    /// If the result was not passed, then the value is `nil`.
    /// You don't need to call the `super` method.
    open func parent(willDisplayModuleByPassing input: Any?) -> Void {}
    
    /// Called when the parent module passes a value.
    ///
    /// Override this method to handle the passed value.
    /// You don't need to call the `super` method.
    open func parent(didPass data: Any) -> Void {}
    
    
    // MARK: Lifecycle
    
    /// Called after the module is activated.
    ///
    /// Override this method to perform any additional work.
    /// You don't need to call the `super` method.
    open func moduleDidActivate() -> Void {}
    
    /// Called when the module is about to be suspended.
    ///
    /// Override this method to perform any additional work.
    /// You don't need to call the `super` method.
    open func moduleWillSuspend() -> Void {}
    
    /// Called after the module is resumed.
    ///
    /// Override this method to perform any additional work.
    /// You don't need to call the `super` method.
    open func moduleDidResume() -> Void {}
    
    /// Called when the interactor is about to be deactivated.
    ///
    /// Override this method to perform any additional work.
    /// You don't need to call the `super` method.
    open func moduleWillDeactivate() -> Void {}
    
    
    // MARK: - Public Methods
    
    /// Passes some value to a specific module.
    public final func pass(_ data: Any, to parent: ParentReceiver) -> Void {
        passToParent(data)
    }
    
    
    // MARK: - Internal Methods
    
    /// Called after the module is activated.
    final override func activate() -> Void {
        moduleDidActivate()
    }
    
    /// Called when the module is about to be suspended.
    final override func suspend() -> Void {
        moduleWillSuspend()
    }
    
    /// Called after the module is resumed.
    final override func resume() -> Void {
        moduleDidResume()
    }
    
    /// Called when the interactor is about to be deactivated.
    final override func deactivate() -> Void {
        moduleWillDeactivate()
    }
    
}

extension DefaultInteractor: ParentDisplayable {
    
    /// Called before the parent module displayes this module.
    func parentWillDisplayModule(ByPassing input: Any?) -> Void {
        parent(willDisplayModuleByPassing: input)
    }
    
}

extension DefaultInteractor: ParentContactable {
    
    /// Called when the parent module passes some value.
    func receiveFromParent(_ data: Any) -> Void {
        parent(didPass: data)
    }
    
    /// Passes some value to a parent interactor.
    func passToParent(_ data: Any) -> Void {
        guard let module else { return }
        module.passToParent(data)
    }
    
}
