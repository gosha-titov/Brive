import ModKit
import UIKit

/// The base router for tab bar and navigation routers.
open class PresentationRouter<Module, Builder: Buildable>: DefaultRouter where Builder.Module == Module {
    
    // MARK: - Internal Properties
    
    /// The dictionary of routers that are children of the current router.
    var children = [Module: DefaultRouter]()
    
    /// The builder that builds child modules.
    let builder: Builder
    
    
    // MARK: - Public Methods
    
    /// Presents the given module modally.
    ///
    /// There are two cases when the presenting will **not** be executed:
    /// - the router's `container` and `view` are `nil`, that is, there is no view that can present the module;
    /// + the child router's `container` and `view` are `nil`, that is, there is no view that can be presented.
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
        var view = view
        if let self = self as? TabBarControllable {
            view = self.container
        } else if let self = self as? NavigationControllable {
            self.container.executeSafely { view = $0 }
        }
        guard let view else { return }
        
        // Builds a module.
        if !children.hasKey(module) { build(module) }
        guard let child = children[module] else { return }
        if let input { child.receive(input) }
        
        // Look for a view that can be presented.
        var viewToPresent: UIViewController? = child.view
        if let child = child as? TabBarControllable {
            viewToPresent = child.container
        } else if let child = child as? NavigationControllable {
            child.container.executeSafely { viewToPresent = $0 }
        }
        
        // Present
        viewToPresent.executeSafely {
            view.present($0, animated: animated, completion: completion)
        }
        
    }
    
    
    // MARK: Internal Methods
    
    /// Attaches the given router to the module.
    func attach(_ child: DefaultRouter, to module: Module) -> Void {
        children[module] = child
        child.parent = self
        child.activate()
    }
    
    /// Detaches the child router from the module.
    func detachChild(from module: Module) -> Void {
        guard let child = children[module] else { return }
        children.removeValue(forKey: module)
        child.deactivate()
    }
    
    /// Detaches all child routers.
    func detachAllChildren() -> Void {
        children.values.forEach { $0.deactivate() }
        children.removeAll()
    }
    
    /// Builds the given module.
    func build(_ module: Module) -> Void {
        let (child, view) = builder.build(module)
        attach(child, to: module)
        child.view = view
        if let child = child as? NavigationControllable {
            child.container = UINavigationController()
        }
    }
    
    
    // MARK: - Init
    
    /// Creates a router with interactor and builder.
    public init(interactor: RouterInteracting, builder: Builder) {
        self.builder = builder
        super.init(interactor: interactor)
    }
    
}
