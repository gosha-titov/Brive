import UIKit

/// A type that the app builder shoud conform to.
public protocol AppBuildable: AnyObject {
    
    /// The root router of this module.
    associatedtype RootRouter: Launchable
    
    /// Builds the root module.
    /// - Returns: The root router of this module.
    func buildRootModule() -> RootRouter
    
}
