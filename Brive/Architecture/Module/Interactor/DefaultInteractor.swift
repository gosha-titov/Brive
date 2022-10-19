/// A default interactor which module doesn't own child modules.
///
/// The `DefaultInteractor` class defines the shared behavior that’s common to all interactors.
/// You rarely create instances of the `DefaultInteractor` class directly.
/// Instead, you subclass it and add the methods and properties needed to manage the business logic of this module.
///
/// If this module should have an associated `View`, then use `ViewOwnable` protocol.
///
/// The interactor's main responsibility is to be activated and deactivated. The implementation is hidden,
/// but if you want to perform any additional work, override ``interactorDidActivate()``
/// and ``interactorWillDeactivate()`` methods.
///
/// The parent module can pass some data to this module before displaying it.
/// To handle this, override ``parent(willDisplayWith:)`` method.
///
/// The parent module can pass some data to this module while it's activated.
/// To handle this, override ``parent(didPass:)`` method.
///
/// In order to pass data to the parent module, call ``pass(_:to:)`` method.
///
open class DefaultInteractor<Routing: InteractorToRouterInterface>: Interactable {
    
    /// A receiver that is a parent interactor.
    public enum ParentReceiver { case parent }
    
    /// Some data that is passed between parent and child modules.
    public typealias Value = Any
    
    // MARK: - Properties
    
    /// The router that is responsible for navigation between screens.
    public weak var router: Routing?
    
    
    // MARK: - Open Methods
    
    /// Called before the parent module displayes this module.
    ///
    /// Override this method to perform additional work and/or to handle the input.
    /// If the result was not passed, then the value is `nil`.
    /// You don't need to call the `super` method.
    open func parent(willDisplayWith input: Value?) -> Void {}
    
    /// Called when the parent module passes a value.
    ///
    /// Override this method to handle the passed value.
    /// You don't need to call the `super` method.
    open func parent(didPass value: Value) -> Void {}
    
    /// Called after this interactor is activated.
    ///
    /// Override this method to perform additional work.
    /// You don't need to call the `super` method.
    open func interactorDidActivate() -> Void {}
    
    /// Called when this interactor is about to be deactivated.
    ///
    /// Override this method to perform additional work.
    /// You don't need to call the `super` method.
    open func interactorWillDeactivate() -> Void {}
    
    
    // MARK: - Public Methods
    
    /// Passes some value to a specific receiver.
    public final func pass(_ value: Value, to receiver: ParentReceiver) -> Void {
        passToParent(value)
    }
    
    
    // MARK: - Internal Methods
    
    /// Called before the parent module displayes this module.
    final func parentWillDisplay(with input: Any?) -> Void {
        parent(willDisplayWith: input)
    }
    
    /// Called when the parent module passes some value.
    final func receiveFromParent(_ value: Any) -> Void {
        parent(didPass: value)
    }
    
    /// Passes some value to a parent interactor.
    final func passToParent(_ value: Any) -> Void {
        guard let router = router as? Passable else { return }
        router.passToParent(value)
    }
    
    /// Activates this interactor.
    final func activate() -> Void {
        interactorDidActivate()
    }
    
    /// Deactivates this interactor.
    final func deactivate() -> Void {
        interactorWillDeactivate()
        router = nil
    }
    
}
