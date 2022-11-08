/// An interface for the interactor trough which it communicates with its view.
public protocol InteractorToViewInterface: AnyObject {
    
    /// Shows loading.
    func showLoading() -> Void
    
    /// Hides loading.
    func hideLoading() -> Void
    
}
