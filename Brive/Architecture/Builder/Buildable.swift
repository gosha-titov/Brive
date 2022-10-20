import UIKit

/// A type that can build child modules.
///
/// A builder that conforms to `Buildable` protocol can build child modules.
/// To do this, you must implement `build(_:)` method that returns a child router and a child view to display.
/// You never call this method directly, because a parent router does, hiddenly.
///
/// In order for the builder can build a child module, it needs an argument that is `Enumeration`.
/// Implement this as in the example below:
///
///     enum Module { case .feed, .messages, .settings }
///
/// Implementation of `build(_:)` method shoud be as in the example below:
///
///     func build(_ module: Module) -> (Routable, UIViewController?) {
///         switch module {
///         case .feed: return buildFeedModule()
///         case .messages: return buildMessagesModule()
///         case .settings: return buildSettingsModule()
///         }
///     }
///
/// Building a concrete module should be as in the example below:
///
///     func buildFeedModule() -> (Routable, UIViewController?) {
///         let view = FeedView()
///         let interactor = FeedInteractor(view: view)
///         let router = FeedRouter(interactor: interactor)
///         view.interactor = interactor
///         interactor.router = router
///         return (router, view)
///     }
///
public protocol Buildable: AnyObject {
    
    /// Child modules that each parent router can build via its builder.
    ///
    /// Each child router is attached to its module.
    /// To implement this, use `Enumeration` as in the examle below:
    ///
    ///     enum Module { case .feed, .messages, .settings }
    ///
    associatedtype Module: Hashable
    
    /// Builds the given child module.
    ///
    /// Implementation of this method shoud be as in the example below:
    ///
    ///     func build(_ module: Module) -> (Routable, UIViewController?) {
    ///         switch module {
    ///         case .feed: return buildFeedModule()
    ///         case .messages: return buildMessagesModule()
    ///         case .settings: return buildSettingsModule()
    ///         }
    ///     }
    ///
    func build(_ module: Module) -> (Routable, UIViewController?)
    
}
