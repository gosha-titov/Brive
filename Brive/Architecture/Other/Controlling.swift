import UIKit

/// A type that requires you to have a controller.
public protocol Controlling: AnyObject {
    
    /// A type that manages view controllers.
    associatedtype Controller: UIViewController
    
    /// The controller of this object.
    var controller: Controller { get set }
    
}
