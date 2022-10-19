import UIKit

/// A type that all views should conform to.
public protocol Viewable where Self: UIViewController {
    
    associatedtype Interacting: ViewToInteractorInterface
    
    /// The interactor that is responsible for business logic.
    /* weak */ var interactor: Interacting? { get set }
    
}
