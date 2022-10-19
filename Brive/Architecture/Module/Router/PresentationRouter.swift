import ModKit
import UIKit

/// A presentation router that owns child routers.
///
/// The `PresentationRouter` class defines the shared behavior that’s common to parent routers.
/// You rarely create instances of the `PresentationRouter` class directly.
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
/// You can communicate with a parent through your child-to-parent interface:
///
///     if let parent = parent as? YourChildToParentInterface {
///         parent.doSomething()
///     }
///
/// **The essence of a parent router is to own child modules and route to them.**
/// Each child router is attached to its module.
///
/// You can handle result of a child module's completion by overriding the ``childDidComplete(_:with:)`` method.
///
/// Use ``present(module:with:animated:completion:)`` method to present a child module modally.
/// The ``route(to:with:)`` method of `Routing` protocol that does the same thing.
///
open class PresentationRouter<Builder: Buildable, Interacting: RouterToInteractorInterface>: DefaultRouter<Interacting>, Routing {
    
    /// Child modules of this module.
    public typealias Module = Builder.Module
    
    // MARK: - Internal Properties
    
    var allChildModules = Module.allCases.map{$0}
    
    /// The dictionary of routers that are children of the current router.
    var children = [Module: Routable]()
    
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
    
    // MARK: - Public Methods
    
    /// Presents the given module modally.
    ///
    /// If module has not been built yet, then this method builds, activates and presents it.
    ///
    /// - Parameter module: A child module to display.
    /// - Parameter input: Some value to pass to this module before the module is displayed. Default value is `nil`.
    /// - Parameter animated: Pass `true` to animate the presentation; otherwise, pass `false`. Default value is `true`.
    /// - Parameter completion: The block to execute after the presentation finishes. This block has no return value and takes no parameters.
    ///
    public func present(module: Module, with input: Value? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> Void {

        let child = buildChildModuleIfNeeded(module)
        if let input { child.parentWillDisplay(with: input) }
        
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
    
    final func hide(_ child: AnyObject, with output: Any?, _ animated: Bool, keep loaded: Bool) {
        guard let child = child as? Routable,
              let module = children.key(byReference: child)
        else { return }
        if let transition = child.transition {
            switch transition {
            case .pushed: (view as? UINavigationController)?.popViewController(animated: animated)
            case .presented: child.view?.dismiss(animated: animated)
            case .permanent: return
            }
        }
        if !loaded { detachChild(from: module) }
        
        guard let interactor = interactor as? ChildCompletable else { return }
        interactor.childDidComplete(module, with: output)
    }
    
    final func receiveFromChild(_ sender: Any, _ value: Any) -> Void {
        guard let child = sender as? Routable,
              let module = children.key(byReference: child),
              let interactor = interactor as? Receivable
        else { return }
        interactor.receiveFromChild(module, value)
    }
    
    final func passToChild(_ module: Any, _ value: Value) -> Void {
        guard let module = module as? Module,
              let child = children[module]
        else { return }
        child.receiveFromParent(value)
    }
    
    /// Attaches the given router to the module and activates it.
    final func attach(_ child: Routable, to module: Module) -> Void {
        children[module] = child
        child.parent = self
        child.load()
    }
    
    /// Detaches the child router from the module and deactivates it.
    final func detachChild(from module: Module) -> Void {
        guard let child = children[module] else { return }
        children.removeValue(forKey: module)
        child.unload()
    }
    
    /// Detaches all child routers and deactivates them.
    final func detachAllChildren() -> Void {
        children.values.forEach { $0.unload() }
        children.removeAll()
    }
    
    /// Builds the given module if it's not been yet.
    /// - Returns: The router of this module.
    @discardableResult
    final func buildChildModuleIfNeeded(_ module: Module) -> Routable {
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
    func didBuildChildModule(_ child: Routable) -> Void {}
    
    override func routerIsUnloading() -> Void {
        detachAllChildren()
    }
    
    
    // MARK: - Init
    
    /// Creates a router with interactor and builder.
    public init(interactor: Interacting, builder: Builder) {
        self.builder = builder
        super.init(interactor: interactor)
    }
    
}
