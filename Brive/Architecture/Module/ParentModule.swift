import ModKit
import UIKit

/// A module that is a concrete part of the application.
///
/// The `ParentModule` class defines the shared behavior that’s common to all modules.
/// You always create instances of the `ParentModule` class directly,
/// since the module is already complete and doesn't need any modifications.
/// All implementation is hidden. There is no way you can interact with the module directly.
///
/// **The parent module owns child modules.**
///
/// Each module has three main components: Router, Interactor and View.
/// A router is responsible for the view hierarchy, an interactor is responsible for business logic,
/// a view is responsible for configurating and updating UI, catching and handling user interactions.
/// But a parent module has another additional component: Builder.
/// A builder builds child modules when needed.
///
/// The module's lifecycle consists of: activation and deactivation,
/// but between them there can also be suspening and resuming.
/// An interactor's lifecycle exactly coincides with the lifecycle of its module.
///
/// The module automatically provides connection to a parent module and child ones,
/// automatically creates and deletes child modules.
///
/// Each parent module can receive/pass some data from/to related modules, but doesn't process this, since
/// its interactor is responsible for passing and receiving this data.
///
public final class ParentModule<Builder: ChildBuildable>: DefaultModule {
    
    typealias ChildType = Builder.ChildType
    
    
    // MARK: - Properties
    
    /// A builder that builds child modules.
    var builder: Builder
    
    /// Child modules that are loaded.
    var children = [ChildType: DefaultModule]()
    
    /// Attaches the given module to the type and activates it.
    private func attach(_ child: DefaultModule, to type: ChildType) -> Void {
        children[type] = child
        child.parent = self
    }
    
    /// Detaches the child module from the type.
    private func detachChild(from type: ChildType) -> Void {
        guard let child = children[type] else { return }
        children.removeValue(forKey: type)
        child.parent = nil
    }
    
    /// Detaches all child routers.
    private func detachAllChildren() -> Void {
        children.values.forEach { $0.parent = nil }
        children.removeAll()
    }
    
    /// Returns a child of the given type.
    private func child(of type: Any) -> DefaultModule? {
        guard let type = type as? ChildType else { return nil }
        return children[type]
    }
    
    
    // MARK: - Init
    
    /// Creates a module with a child builder, a router, an interactor and a view.
    public init(builder: Builder, router: DefaultRouter, interactor: Interactable, view: Viewable? = nil) {
        self.builder = builder
        super.init(router: router, interactor: interactor, view: view)
    }
    
}

extension ParentModule: Invokable, Revokable {
    
    /// Called when the router of this module displays the child module.
    /// - Returns: A view container or a view of child module.
    @discardableResult
    func invoke(_ type: Any, byPassing input: Any? = nil) -> UIViewController? {
        guard let type = type as? ChildType else { return nil }
        let child: DefaultModule
        if children.hasKey(type) {
            child = children[type]!
            child.resume()
        } else {
            child = builder.build(childModuleOf: type)
            attach(child, to: type)
            child.activate()
        }
        child.parentWillDisplayModule(ByPassing: input)
        return child.view
    }
    
    /// Called when the child module completes.
    func revoke(_ child: AnyObject, byReceiving output: Any?, animated: Bool, shouldKeepModuleLoaded: Bool) -> Void {
        guard let child = child as? DefaultModule,
              let type = children.key(byReference: child),
              let interactor = interactor as? ChildCompletable,
              let router = router as? ChildRemovable else { return }
        if shouldKeepModuleLoaded {
            child.suspend()
        } else {
            child.deactivate()
            detachChild(from: type)
        }
        interactor.childDidComplete(type, with: output)
        router.removeChild(type, animated: animated)
    }
    
}

extension ParentModule: ChildUpperViewable {

    func upperView(of type: Any) -> UIViewController? {
        guard let child = child(of: type) else { return nil }
        return child.router.upperView
    }

}

extension ParentModule: ChildContactable {
    
    /// Called when the child module passes a value to this module.
    func receiveFromChild(_ sender: Any, _ value: Any) -> Void {
        guard let child = sender as? DefaultModule,
              let type = children.key(byReference: child),
              let interactor = interactor as? ChildContactable else { return }
        interactor.receiveFromChild(type, value)
    }
    
    /// Called when the interactor of this module passes some value to a child module.
    func passToChild(_ receiver: Any, _ value: Any) -> Void {
        guard let type = receiver as? ChildType,
              let child = children[type] else { return }
        child.receiveFromParent(value)
    }
    
}

extension ParentModule: ChildStatable {
    
    /// Called when the interactor of this module needs to know a state of the child module.
    func state(of type: Any) -> State {
        guard let child = child(of: type) else { return .inactive }
        return child.state
    }
    
}

extension ParentModule: ChildTransitable {
    
    /// Sets a transition for a child.
    func transition(_ transition: DefaultRouter.Transition, for type: Any) -> Void {
        guard let child = child(of: type) else { return }
        child.router.transition = transition
    }
    
    /// Returns a transition of a child.
    func transition(of type: Any) -> DefaultRouter.Transition? {
        guard let child = child(of: type) else { return nil }
        return child.router.transition
    }

}

extension ParentModule: NavigationSharable {
    
    /// Shares a navigation controller with a child.
    func share(_ navigationController: UINavigationController?, with type: Any) -> Void {
        guard let child = child(of: type) else { return }
        child.router.navigationController = navigationController
    }

}

extension ParentModule: ChildSubstitutable {
    
    /// Substitutes a view of a child for the given one.
    func substituteView(of type: Any, for substitutedView: UIViewController) {
        guard let child = child(of: type) else { return }
        child.router.substitutedView = substitutedView
    }
    
}

extension ParentModule: ChildDismissingCompletionKeepable {
    
    /// Returns a dismissing completion of a child.
    func dismissingCompletion(of type: Any) -> (() -> Void)? {
        guard let child = child(of: type) else { return nil }
        return child.router.dismissingCompletion
    }
    
}
