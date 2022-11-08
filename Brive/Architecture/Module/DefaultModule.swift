import UIKit

/// A module that is a concrete part of the application.
///
/// The `DefaultModule` class defines the shared behavior that’s common to all modules.
/// You always create instances of the `DefaultModule` class directly,
/// since the module is already complete and doesn't need any modifications.
/// All implementation is hidden. There is no way you can interact with the module directly.
///
/// **The default module does not own child modules.**
///
/// Each module has three main components: Router, Interactor and View.
/// A router is responsible for the view hierarchy, an interactor is responsible for business logic,
/// a view is responsible for configurating and updating UI, catching and handling user interactions.
///
/// The module's lifecycle consists of: activation and deactivation,
/// but between them there can also be suspening and resuming.
/// An interactor's lifecycle exactly coincides with the lifecycle of its module.
///
/// A default module automatically provides connection to a parent module.
///
/// Each default module can receive some data from a parent module, but doesn't process this, since
/// its interactor is responsible for receiving this data.
///
public class DefaultModule {
    
    /// A type that representing a state of the module.
    ///
    /// There are only two possible states: active and inactive.
    public enum State { case active, inactive }
    
    public typealias Interactor = Interactable
    public typealias Router = DefaultRouter
    public typealias View = Viewable
    
    typealias Parent = DefaultModule & ChildContactable & Revokable
    
    
    // MARK: - Properties
    
    /// A parent module of this.
    weak var parent: Parent?
    
    /// A value that indicating the current state of the module.
    var state: State = .inactive
    
    /// An interactor of this module.
    var interactor: Interactor
    
    /// A router of this module.
    var router: Router
    
    /// A view of this module.
    var view: View?
    
    
    // MARK: - Lifecycle
    
    /// Activates this module.
    func activate() -> Void {
        state = .active
        interactor.activate()
    }
    
    /// Suspends this module.
    func suspend() -> Void {
        interactor.suspend()
        state = .inactive
    }
    
    /// Resumes this module.
    func resume() -> Void {
        state = .active
        interactor.resume()
    }
    
    /// Deactivates this module.
    func deactivate() -> Void {
        interactor.deactivate()
        state = .inactive
    }
    
    
    // MARK: - Init
    
    /// Creates a module with a router, an interactor and a view.
    public init(router: Router, interactor: Interactor, view: View?) {
        self.interactor = interactor
        self.router = router
        self.view = view
        interactor.module = self
        router.module = self
        view?.module = self
    }
    
}

extension DefaultModule: ParentDisplayable {
    
    /// Called before the parent module displayes this module.
    func parentWillDisplayModule(ByPassing input: Any?) -> Void {
        guard let interactor = interactor as? ParentDisplayable else { return }
        interactor.parentWillDisplayModule(ByPassing: input)
    }
    
}

extension DefaultModule: ParentContactable {
    
    /// Called when the parent module passes some value to this module.
    func receiveFromParent(_ data: Any) -> Void {
        guard let interactor = interactor as? ParentContactable else { return }
        interactor.receiveFromParent(data)
    }
    
    /// Called when the interactor of this module passes some value to the parent module.
    func passToParent(_ data: Any) -> Void {
        guard let parent else { return }
        parent.receiveFromChild(self, data)
    }
    
}

extension DefaultModule: ModuleCompletable {
    
    func complete(byPassing output: Any?, animated: Bool, shouldKeepModuleLoaded loaded: Bool) -> Void {
        guard let parent else { return }
        parent.revoke(self, byReceiving: output, animated: animated, shouldKeepModuleLoaded: loaded)
    }
    
}
