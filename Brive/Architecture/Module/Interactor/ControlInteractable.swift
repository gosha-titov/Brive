/// A type that all control interactors should conform to.
/// It has no view presentation.
public protocol ControlInteractable: AnyObject {
    
    /// An interface from this interactor to the router.
    associatedtype Routing
    
    /// The router that is responsible for navigation between screens.
    var router: Routing { get }
    
}
