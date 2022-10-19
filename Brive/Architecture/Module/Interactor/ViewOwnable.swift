public protocol ViewOwnable: AnyObject {
    
    associatedtype Viewable: InteractorToViewInterface
    
    /// The view that is responsible for configurating and updating UI,
    /// catching and handling user interactions, managing the display of `View`.
    var view: Viewable { get }
    
    /// Creates an object with a view.
    init(view: Viewable)
    
}
