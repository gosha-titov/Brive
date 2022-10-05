/// A type that all views should conform to.
public protocol Viewable: AnyObject {
    
    /// An interface from this presenter to the interactor.
    associatedtype Interacting
    
    /// The interactor that is responsible for business logic.
    var interactor: Interacting { get }
    
}
