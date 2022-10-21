/// A parent interactor which module owns child modules.
///
/// The `ParentInteractor` class defines the shared behavior that’s common to all parent interactors.
/// You rarely create instances of the `ParentInteractor` class directly.
/// Instead, you subclass it and add the methods and properties needed to manage the business logic of this module.
///
/// If this module should have an associated `View`, then use the `ViewOwnable` protocol.
///
/// The interactor's lifecycle consists of activation and deactivation. The implementation is hidden,
/// but if you need to perform any additional work, override ``interactorDidActivate()``
/// and ``interactorWillDeactivate()`` methods.
///
/// When a parent interactor is about to display this module, it can pass some input data.
/// To handle this, override ``parent(willDisplayModuleWith:)`` method.
///
/// The parent interactor can pass some data to this interactor while it's activated.
/// To handle this, override ``parent(didPass:)`` method.
///
/// When a child module completes, it can pass some output data.
/// To handle this, override ``child(_:didCompleteWith:)`` method.
///
/// The child interactor can pass some data to this interactor while it's activated.
/// To handle this, override ``child(_:didPass:)`` method.
///
/// In order to pass some data to the parent module, call ``pass(_:to:)`` method.
///
open class ParentInteractor<Routing: InteractorToRouterInterface, Module>: DefaultInteractor<Routing> {
    
    /// A type that associating with a child interactor.
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
    
}


extension ParentInteractor: ChildCompletable {
    
    /// Called when the child module is completed.
    final func childDidComplete(_ module: Any, with output: Any?) -> Void {
        guard let module = module as? Module else { return }
        child(module, didCompleteWith: output)
    }
    
}


extension ParentInteractor: ChildCommunicable {
    
    /// Called when the child module passes a value.
    final func receiveFromChild(_ sender: Any, _ value: Any) -> Void {
        guard let module = sender as? Module else { return }
        child(module, didPass: value)
    }
    
    /// Passes some value to a child module.
    final func passToChild(_ module: Any, _ value: Any) -> Void {
        guard let router = router as? ChildCommunicable else { return }
        router.passToChild(module, value)
    }
    
}
