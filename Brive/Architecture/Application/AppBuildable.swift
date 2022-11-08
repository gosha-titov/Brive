import UIKit

/// A type that can build a root module.
///
/// A builder that conforms to the `MainBuildable` protocol can build a root module.
///
/// The `buildRootModule()` method shoud be implemented in one of the following ways:
///
///     // Returns a default module
///     func buildRootModule() -> RootModule {
///         let router = RootRouter()
///         let interactor = RootInteractor()
///         let view = RootView()
///         return DefaultModule(router: router, interactor: interactor, view: view)
///     }
///
///     // Returns a non-viewing default module
///     func buildRootModule() -> RootModule {
///         let router = RootRouter()
///         let interactor = RootInteractor()
///         return DefaultModule(router: router, interactor: interactor)
///     }
///
///     // Returns a parent module
///     func buildRootModule() -> RootModule {
///         let builder = RootBuilder()
///         let router = RootRouter()
///         let interactor = RootInteractor()
///         let view = RootView()
///         return ParentModule(builder: builder, router: router, interactor: interactor, view: view)
///     }
///
///     // Returns a non-viewing parent module
///     func buildRootModule() -> RootModule {
///         let builder = RootBuilder()
///         let router = RootRouter()
///         let interactor = RootInteractor()
///         return ParentModule(builder: builder, router: router, interactor: interactor)
///     }
///
public protocol MainBuildable: AnyObject {
    
    /// A child root module.
    associatedtype RootModule: DefaultModule
    
    /// Builds the root module.
    ///
    /// This method shoud be implemented in one of the following ways:
    ///
    ///     // Returns a default module
    ///     func buildRootModule() -> RootModule {
    ///         let router = RootRouter()
    ///         let interactor = RootInteractor()
    ///         let view = RootView()
    ///         return DefaultModule(router: router, interactor: interactor, view: view)
    ///     }
    ///
    ///     // Returns a non-viewing default module
    ///     func buildRootModule() -> RootModule {
    ///         let router = RootRouter()
    ///         let interactor = RootInteractor()
    ///         return DefaultModule(router: router, interactor: interactor)
    ///     }
    ///
    ///     // Returns a parent module
    ///     func buildRootModule() -> RootModule {
    ///         let builder = RootBuilder()
    ///         let router = RootRouter()
    ///         let interactor = RootInteractor()
    ///         let view = RootView()
    ///         return ParentModule(builder: builder, router: router, interactor: interactor, view: view)
    ///     }
    ///
    ///     // Returns a non-viewing parent module
    ///     func buildRootModule() -> RootModule {
    ///         let builder = RootBuilder()
    ///         let router = RootRouter()
    ///         let interactor = RootInteractor()
    ///         return ParentModule(builder: builder, router: router, interactor: interactor)
    ///     }
    ///
    func buildRootModule() -> RootModule
    
}
