/// A parent interactor which module owns child modules.
///
/// The `ParentInteractor` class defines the shared behavior that’s common to all parent interactors.
/// You rarely create instances of the `ParentInteractor` class directly.
/// Instead, you subclass it and add the methods and properties needed to manage the business logic of this module.
///
/// If this module should have an associated `View`, then use `ViewOwnable` protocol.
///
/// The interactor's main responsibility is to be activated and deactivated. The implementation is hidden,
/// but if you want to perform any additional work, override ``interactorDidActivate()``
/// and ``interactorWillDeactivate()`` methods.
///
/// The parent module can pass some data to this module before displaying it.
/// To handle this, override ``parent(willDisplayModuleWith:)`` method.
///
/// The parent module can pass some data to this module while it's activated.
/// To handle this, override ``parent(didPass:)`` method.
///
/// The child module can be completed with some output.
/// To handle this, override ``child(_:didCompleteWith:)`` method.
///
/// The child module can pass some data to this module while it's activated.
/// To handle this, override ``child(_:didPass:)`` method.
///
/// In order to pass data to the parent or child module, call ``pass(_:to:)`` method.
///
open class ParentInteractor<Routing: InteractorToRouterInterface, Module: Hashable>: DefaultInteractor<Routing> {
    
    /// A receiver that is a child interactor.
    public enum ChildReceiver {
        case child(Module)
        var module: Module {
            switch self { case .child(let module): return module }
        }
    }
    
    
    // MARK: - Open Methods
    
    /// Called when the child module is completed.
    ///
    /// Override this method to perform additional work and/or to handle the output.
    /// If the result was not passed, then the value is `nil`.
    /// You don't need to call the `super` method.
    open func child(_ module: Module, didCompleteWith output: Value?) -> Void {}
    
    /// Called when the child module passes a value.
    ///
    /// Override this method to handle the passed value.
    /// You don't need to call the `super` method.
    open func child(_ module: Module, didPass value: Value) -> Void {}
    
    
    // MARK: - Public Methods
    
    /// Passes some value to a specific receiver.
    public final func pass(_ value: Value, to receiver: ChildReceiver) -> Void {
        let module = receiver.module
        passToChild(module, value)
    }
    
    
    // MARK: - Internal Methods
    
    /// Called when the child module is completed.
    final func childDidComplete(_ module: Any, with output: Any?) -> Void {
        guard let module = module as? Module else { return }
        child(module, didCompleteWith: output)
    }
    
    /// Called when the child module passes a value.
    final func receiveFromChild(_ sender: Any, _ value: Any) -> Void {
        guard let module = sender as? Module else { return }
        child(module, didPass: value)
    }
    
    /// Passes some value to a child module.
    final func passToChild(_ module: Any, _ value: Any) -> Void {
        guard let router = router as? Passable else { return }
        router.passToChild(module, value)
    }
    
}
