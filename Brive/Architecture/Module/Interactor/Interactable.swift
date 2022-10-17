/// A type that all presentation interactors should conform to.
/// It has a view presentation.
public protocol Interactable: ControlInteractable {
    
    /// The view that is responsible for configurating and updating UI,
    /// catching and handling user interactions, managing the display of `View`.
    var view: Viewing? { get set }
    
}
