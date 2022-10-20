import UIKit

/// A type that can build a root module.
///
/// A builder that conforms to `AppBuildable` protocol can build a root module.
/// To do this, you must implement `buildRootModule()` method that returns a root router.
/// This router should conform to `Launchable` to be launched from a window.
///
/// Unlike other builders, you call `buildRootModule()` method directly.
/// You usually do this inside `SceneDelegate`.
///
/// Implementation of `buildRootModule()` method shoud be as in the example below:
///
///     func buildRootModule() -> RootRouter {
///         let view = RootView()
///         let interactor = RootInteractor(view: view)
///         let router = RootRouter(interactor: interactor)
///         view.interactor = interactor
///         interactor.router = router
///         router.setView(view)
///         return router
///     }
///
public protocol AppBuildable: AnyObject {
    
    /// The root router of this module that can be launched from a window.
    associatedtype RootRouter: Launchable
    
    /// Builds the root module.
    ///
    /// Implementation of this method shoud be as in the example below:
    ///
    ///     func buildRootModule() -> RootRouter {
    ///         let view = RootView()
    ///         let interactor = RootInteractor(view: view)
    ///         let router = RootRouter(interactor: interactor)
    ///         view.interactor = interactor
    ///         interactor.router = router
    ///         router.setView(view)
    ///         return router
    ///     }
    ///
    func buildRootModule() -> RootRouter
    
}
