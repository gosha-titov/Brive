/// An interface for the interactor trough which it communicates with this view.
public protocol Viewing: AnyObject {
    
    /// Shows loading.
    func showLoading() -> Void
    
    /// Hides loading.
    func hideLoading() -> Void
    
}


public extension Viewing {
    
    func showLoading() -> Void {}
    
    func hideLoading() -> Void {}
    
}
