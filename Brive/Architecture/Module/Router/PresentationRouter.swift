import ModKit
import UIKit

/// A presentation router that owns child routers.
///
/// The `PresentationRouter` class defines the shared behavior that’s common to all parent routers.
/// You almost always subclass the `PresentationRouter` but you rarely implement it,
/// since each router has already organized flow logic between modules.
/// You usually do this as in the example below:
///
///     final class SettingsRouter: PresentationRouter<SettingsInteractor, SettingsBuilder> {}
///
/// But if you need to, then subclass it and add the methods and properties to manage the router.
///
/// The router's lifecycle is loading and unloading. The implementation is hidden,
/// but if you need to perform any additional work, override ``routerDidLoad()``
/// and ``routerWillUnload()`` methods.
///
/// In order to complete this module and display the parent one,
/// call ``complete(with:animateTransition:shouldKeepModuleLoaded:)`` method.
///
/// A feature of a presentation router is to present a child module modally.
/// To do this, call ``present(module:with:animated:completion:)`` method.
///
open class PresentationRouter<Interacting: RouterToInteractorInterface, Builder: Buildable>: DefaultRouter<Interacting>, Routing {
    
    /// Child modules of this module.
    public typealias Module = Builder.Module
    
    // MARK: - Internal Properties
    
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
        pass(input, to: child)
        
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
    
    final func pass(_ input: Value?, to child: Routable) -> Void {
        guard let child = child as? ParentDisplayable else { return }
        child.parentWillDisplayModule(with: input)
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
            child.resume()
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


extension PresentationRouter: ChildHideable {
    
    /// Hides the child module.
    final func hide(_ child: AnyObject, with output: Any?, animateTransition animated: Bool, shouldKeepLoaded: Bool) {
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
        if shouldKeepLoaded { child.suspend() } else { detachChild(from: module) }
        
        guard let interactor = interactor as? ChildCompletable else { return }
        interactor.childDidComplete(module, with: output)
    }
    
}


extension PresentationRouter: ChildCommunicable {
    
    /// Called when the child module passes a value.
    final func receiveFromChild(_ sender: Any, _ value: Any) -> Void {
        guard let child = sender as? Routable,
              let module = children.key(byReference: child),
              let interactor = interactor as? ChildCommunicable
        else { return }
        interactor.receiveFromChild(module, value)
    }
    
    /// Passes some value to a child module.
    final func passToChild(_ module: Any, _ value: Value) -> Void {
        guard let module = module as? Module,
              let child = children[module] as? ParentCommunicable
        else { return }
        child.receiveFromParent(value)
    }
    
}
