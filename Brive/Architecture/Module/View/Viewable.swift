/// A type that all views should conform to.
public protocol Viewable: AnyObject {
    
    /// The interactor that is responsible for business logic.
    var interactor: ViewInteracting { get }
    
}
