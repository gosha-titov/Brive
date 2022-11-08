/// A parent interactor which module owns child modules.
///
/// The `ParentInteractor` class defines the shared behavior that’s common to all parent interactors.
/// You never create instances of the `ParentInteractor` class directly.
/// Instead, you subclass it and add the methods and properties needed to manage the business logic of this module.
///
/// If this module should not have an associated `View`, then use the ``NonViewing`` protocol as in the example below:
///
///     class SomeInteractor: ParentInteractor<..., NonViewing, ...>
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
/// When a child module completes, it can pass some output data.
/// To handle this, override ``child(_:didCompleteByPassing:)`` method.
///
/// A child module can pass some data to this module while it's active.
/// To handle this, override ``child(_:didPass:)`` method.
///
/// In order to pass some data to a parent or child module, call ``pass(_:to:)`` method.
///
open class ParentInteractor<Routing: InteractorToRouterInterface, Viewing: InteractorToViewInterface, ChildType>: DefaultInteractor<Routing, Viewing> {
    
    /// A type that associating with a child module.
    public enum ChildReceiver {
        case child(ChildType)
        var type: ChildType {
            switch self { case .child(let type): return type }
        }
    }
    
    
    // MARK: - Open Methods
    
    /// Called when the child module is completed.
    ///
    /// Override this method to perform any additional work and/or to handle the output.
    /// If the result was not passed, then the value is `nil`.
    /// You don't need to call the `super` method.
    open func child(_ child: ChildType, didCompleteByPassing output: Any?) -> Void {}
    
    /// Called when the child module passes a value.
    ///
    /// Override this method to handle the passed value.
    /// You don't need to call the `super` method.
    open func child(_ child: ChildType, didPass data: Any) -> Void {}
    
    
    // MARK: - Public Methods
    
    /// Passes some value to a specific module.
    public final func pass(_ data: Any, to child: ChildReceiver) -> Void {
        let type = child.type
        passToChild(type, data)
    }
    
    /// Returns a state of the child module.
    public final func state(of child: ChildType) -> DefaultModule.State {
        guard let module = module as? ChildStatable else { return .inactive }
        return module.state(of: child)
    }
    
}

extension ParentInteractor: ChildCompletable {
    
    /// Called when the child module is completed.
    func childDidComplete(_ type: Any, with output: Any?) -> Void {
        guard let type = type as? ChildType else { return }
        child(type, didCompleteByPassing: output)
    }
    
}

extension ParentInteractor: ChildContactable {
    
    /// Called when the child module passes a value.
    func receiveFromChild(_ receiver: Any, _ data: Any) -> Void {
        guard let type = receiver as? ChildType else { return }
        child(type, didPass: data)
    }
    
    /// Passes some value to a child module.
    func passToChild(_ type: Any, _ data: Any) -> Void {
        guard let module = module as? ChildContactable else { return }
        module.passToChild(type, data)
    }
    
}
