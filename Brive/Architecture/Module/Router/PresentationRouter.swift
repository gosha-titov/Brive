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
/// **The essence of a parent router is to own child modules and route to them.**
///
/// Each child router is attached to its module. Use `Enumeration` to create modules as it's done in the example:
///
///     enum SomeModule { case feed, messages, settings }
///
/// Pay attention, that the router and builder modules are the same.
///
/// Use ``present(module:with:animated:completion:)`` method to present a child module modally.
/// The ``route(to:with:)`` method of `Routing` protocol that does the same thing.
///
open class PresentationRouter<Module, Builder: Buildable>: DefaultRouter, Routing where Builder.Module == Module {
    
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
    open func route(to module: Module, with input: Input? = nil) -> Void {
        present(module: module, with: input)
    }
    
    
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
    public final func present(module: Module, with input: Input? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> Void {
        
        // Look for a view that can present.
        var containerOrView = view
        
        // For some reasons, this project doesn't build but Playground does and work.
        // Error: Command CompileSwift failed with a nonzero exit code.
//        if let self = self as? any Controllable {
//            containerOrView = self.container
//        }
        
        if let self = self as? any TabBarControllable {
            containerOrView = self.container
        } else if let self = self as? any NavigationControllable {
            containerOrView = self.container
        }
        guard let containerOrView else { return }

        // Build a module.
        let child = buildChildModuleIfNeeded(module)
        if let input { child.receive(input) }

        // Look for a view that can be presented.
        var viewToPresent: UIViewController? = child.view
        
//        if let child = child as? any Controllable {
//            viewToPresent = child.container
//        }
        
        if let child = child as? any TabBarControllable {
            viewToPresent = child.container
        } else if let child = child as? any NavigationControllable {
            viewToPresent = child.container
        }
        
        // Try to present
        if let viewToPresent {
            containerOrView.present(viewToPresent, animated: animated, completion: completion)
        } else {
            child.view = containerOrView
        }
        
    }
    
    
    // MARK: - Internal Methods
    
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
