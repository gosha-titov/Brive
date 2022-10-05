import UIKit

/// A type that the app builder shoud conform to.
public protocol AppBuildable: AnyObject {
    
    /// The root router of this module.
    associatedtype RootRouter: RootRoutable
    
    /// Builds the root module.
    /// - Returns: The root router of this module and the view to display.
    func buildRootModule() -> (RootRouter, UIViewController)
    
}
