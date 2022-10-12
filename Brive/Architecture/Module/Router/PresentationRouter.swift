import ModKit
import UIKit

/// A presentation router that owns child routers.
///
/// The `PresentationRouter` class defines the shared behavior that’s common to parent routers.
/// You rarely create instances of the `PresentationRouter` class directly.
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
/// **The essence of a parent router is to own child modules and route to them.**
///
/// Each child router is attached to its module. Use `Enumeration` to create modules as it's done in the example:
///
///     enum SomeModule { case feed, messages, settings }
///
/// Pay attention, that the router and builder modules are the same.
///
/// You can handle result of a child module's completion by overriding the ``childDidComplete(_:with:)`` method.
///
/// Use ``present(module:with:animated:completion:)`` method to present a child module modally.
/// The ``route(to:with:)`` method of `Routing` protocol that does the same thing.
///
open class PresentationRouter<Module, Builder: Buildable>: DefaultRouter, ChildCancelable, Routing where Builder.Module == Module {
    
    // MARK: - Internal Properties
    
    /// The dictionary of routers that are children of the current router.
    var children = [Module: DefaultRouter]()
    
    /// The builder that builds child modules.
    let builder: Builder
    
    
    // MARK: - Open Methods
    
    /// Routes to the given module by default transition.
    ///
    /// The default transition for a presentation router is ``present(module:with:animated:completion:)`` method,
    /// for a navigation router is ``push(module:with:animated)`` method,
    /// for a tab bar router is ``select(module:with)`` method.
    ///
    /// Override this method to change the transition to another.
    /// You should never call the `super` method.
    ///
    /// - Parameter module: A child module to display.
    /// - Parameter input: Some value to pass to this module before the module is displayed.
    ///
    open func route(to module: Module, with input: Value? = nil) -> Void {
        present(module: module, with: input)
    }
    
    /// Called after the child module is completed.
    ///
    /// Override this method to handle the result.
    /// You don't need to call the `super` method.
    open func childDidComplete(_ module: Module, with result: Value?) -> Void {}
    
    
    // MARK: - Public Methods
    
    /// Presents the given module modally.
    ///
    /// If module has not been built yet, then this method builds, activates and presents it.
    ///
    /// - Parameter module: A child module to display.
    /// - Parameter input: Some value to pass to this module before the module is displayed.
    /// - Parameter animated: Pass `true` to animate the presentation; otherwise, pass `false`.
    /// - Parameter completion: The block to execute after the presentation finishes. This block has no return value and takes no parameters.
    ///
    public final func present(module: Module, with input: Value? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> Void {

        let child = buildChildModuleIfNeeded(module)
        if let input { child.receive(input) }
        
        if !(self is Controllable), let child = child as? NavigationControllable {
            child.embedView()
        }
        
        if let viewToPresent = child.view {
            view?.present(viewToPresent, animated: animated, completion: completion)
            child.transition = .presented
        } else {
            child.view = view
        }
        
    }
    
    
    // MARK: - Internal Methods
    
    /// Hides and unloads the given router.
    final func cancel(_ child: DefaultRouter, with result: Value?, _ unloaded: Bool, _ animated: Bool) -> Void {
        
        guard let module = children.key(byReference: child),
              let transition = child.transition
        else { return }
        
        switch transition {
        case .pushed: (view as? UINavigationController)?.popViewController(animated: animated)
        case .presented: child.view?.dismiss(animated: animated)
        case .selected: return
        }
        
        if unloaded { detachChild(from: module) }
        childDidComplete(module, with: result)
    }
    
    /// Attaches the given router to the module and activates it.
    final func attach(_ child: DefaultRouter, to module: Module) -> Void {
        children[module] = child
        child.parent = self
        child.activate()
    }
    
    /// Detaches the child router from the module and deactivates it.
    final func detachChild(from module: Module) -> Void {
        guard let child = children[module] else { return }
        children.removeValue(forKey: module)
        child.deactivate()
    }
    
    /// Detaches all child routers and deactivates them.
    final func detachAllChildren() -> Void {
        children.values.forEach { $0.deactivate() }
        children.removeAll()
    }
    
    /// Builds the given module if it's not been yet.
    /// - Returns: The router of this module.
    @discardableResult
    final func buildChildModuleIfNeeded(_ module: Module) -> DefaultRouter {
        if let child = children[module] {
            return child
        } else {
            let (child, view) = builder.build(module)
            attach(child, to: module)
            child.view = view
            didBuildChildModule(child)
            return child
        }
    }
    
    /// Called after the child module is built.
    func didBuildChildModule(_ child: DefaultRouter) -> Void {}
    
    override func routerIsDeactivating() -> Void {
        detachAllChildren()
    }
    
    
    // MARK: - Init
    
    /// Creates a router with interactor and builder.
    public init(interactor: RouterInteracting, builder: Builder) {
        self.builder = builder
        super.init(interactor: interactor)
    }
    
}
