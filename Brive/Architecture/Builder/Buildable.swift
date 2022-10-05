import UIKit

public protocol Buildable: AnyObject {
    
    /// Modules that each parent router can run.
    /// To implement this, use `Enumeration`.
    associatedtype Module: Hashable
    
    /// Builds the given module.
    /// - Returns: The router of this module and the view to display.
    func build(module: Module) -> (DefaultRouter, UIViewController?)
    
}
