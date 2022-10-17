import UIKit

/// A type that all views should conform to.
public protocol Viewable where Self: UIViewController {
    
    /// The interactor that is responsible for business logic.
    var interactor: ViewInteracting? { get set }
    
}
