/// A default interactor which module doesn't own child modules.
///
/// The `DefaultInteractor` class defines the shared behavior that’s common to all interactors.
/// You rarely create instances of the `DefaultInteractor` class directly.
/// Instead, you subclass it and add the methods and properties needed to manage the business logic of this module.
///
/// If this module should have an associated `View`, then use the ``ViewOwnable`` protocol.
///
/// The interactor's lifecycle consists of activation and deactivation, but in the interval between them,
/// there may also be suspending and resuming. The implementation is hidden, but if you need to perform any additional work,
/// override ``interactorDidActivate()``, ``interactorDidSuspend()``, ``interactorWillResume()``
/// and/or ``interactorWillDeactivate()`` methods.
///
/// The ``state`` property is indicating the current state of the interactor.
/// There're three possible states: `active`, `suspended` or `inactive`.
///
/// When a parent interactor is about to display this module, it can pass some input data.
/// To handle this, override ``parent(willDisplayModuleWith:)`` method.
///
/// The parent interactor can pass some data to this interactor while it's activated.
/// To handle this, override ``parent(didPass:)`` method.
///
/// In order to pass some data to the parent module, call ``pass(_:to:)`` method.
///
open class DefaultInteractor<Routing: InteractorToRouterInterface> {
    
    /// A type that representing a lifecycle of the interactor.
    public enum Lifecycle { case active, suspended, inactive }
    
    /// A type that associating with a parent interactor.
    public enum ParentReceiver { case parent }
    
    /// Some data that is passed between parent and child modules.
    public typealias Value = Any
    
    // MARK: - Properties
    
    /// A Lifecycle value that indicating the current state of the interactor.
    public private(set) var state: Lifecycle = .inactive
    
    /// The router that is responsible for navigation between screens.
    public weak var router: Routing?
    
    // MARK: - Open Methods
    
    /// Called before the parent module displayes this module.
    ///
    /// Override this method to perform additional work and/or to handle the input.
    /// If the result was not passed, then the value is `nil`.
    /// You don't need to call the `super` method.
    open func parent(willDisplayModuleWith input: Value?) -> Void {}
    
    /// Called when the parent module passes a value.
    ///
    /// Override this method to handle the passed value.
    /// You don't need to call the `super` method.
    open func parent(didPass value: Value) -> Void {}
    
    
    // MARK: Lifecycle
    
    /// Called after the interactor is activated.
    ///
    /// Override this method to perform additional work.
    /// You don't need to call the `super` method.
    open func interactorDidActivate() -> Void {}
    
    /// Called after the interactor is suspended.
    ///
    /// Override this method to perform additional work.
    /// You don't need to call the `super` method.
    open func interactorDidSuspend() -> Void {}
    
    /// Called when the interactor is about to be resumed.
    ///
    /// Override this method to perform additional work.
    /// You don't need to call the `super` method.
    open func interactorWillResume() -> Void {}
    
    /// Called when the interactor is about to be deactivated.
    ///
    /// Override this method to perform additional work.
    /// You don't need to call the `super` method.
    open func interactorWillDeactivate() -> Void {}
    
    
    // MARK: - Public Methods
    
    /// Passes some value to a specific receiver.
    public final func pass(_ value: Value, to receiver: ParentReceiver) -> Void {
        passToParent(value)
    }
    
}


extension DefaultInteractor: ParentDisplayable {
    
    /// Called before the parent module displayes this module.
    final func parentWillDisplayModule(with input: Any?) -> Void {
        parent(willDisplayModuleWith: input)
    }
    
}


extension DefaultInteractor: ParentCommunicable {
    
    /// Called when the parent module passes some value.
    final func receiveFromParent(_ value: Any) -> Void {
        parent(didPass: value)
    }
    
    /// Passes some value to a parent interactor.
    final func passToParent(_ value: Any) -> Void {
        guard let router = router as? ParentCommunicable else { return }
        router.passToParent(value)
    }
    
}


extension DefaultInteractor: Eventable {
    
    /// Activates this interactor.
    final func activate() -> Void {
        state = .active
        interactorDidActivate()
    }
    
    /// Suspends this interactor.
    final func suspend() -> Void {
        state = .suspended
        interactorDidSuspend()
    }
    
    /// Resumes this interactor.
    final func resume() -> Void {
        interactorWillResume()
        state = .active
    }
    
    /// Deactivates this interactor.
    final func deactivate() -> Void {
        interactorWillDeactivate()
        state = .inactive
        router = nil
    }
    
}
