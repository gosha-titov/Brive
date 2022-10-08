/// An interface for the interactor trough which it communicates with this view.
public protocol Viewing: AnyObject {
    
    /// Shows loading indicator.
    func showLoading() -> Void
    
    /// Hides loading indicator.
    func hideLoading() -> Void
    
}
