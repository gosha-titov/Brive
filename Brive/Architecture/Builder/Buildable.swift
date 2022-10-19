import UIKit

/// A type that all builders should conform to.
public protocol Buildable: AnyObject {
    
    /// Modules that each parent router can run.
    /// Each child router is attached to its module.
    /// To implement this, use `Enumeration` as in the examle:
    ///
    ///     enum Module { case .feed, .messages, .settings }
    ///
    associatedtype Module: Hashable, CaseIterable
    
    /// Builds the given module.
    /// - Returns: The router of this module and the view to display.
    func build(_ module: Module) -> (Routable, UIViewController?)
    
}
