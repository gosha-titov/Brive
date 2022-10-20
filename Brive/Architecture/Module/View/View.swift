import ModKit
import UIKit

open class View<Interacting: ViewToInteractorInterface>: UIViewController, Viewable, InteractorToViewInterface {
    
    public weak var interactor: Interacting?
    
    
    // MARK: - Properties
    
    /// A view that shows that a task is in progress.
    public lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.center = view.center
        indicator.style = .large
        indicator.color = .white
        return indicator
    }()
    
    /// A view that displays a text under the activity indicator.
    public lazy var activityLabel: UILabel = {
        let label = UILabel(frame: CGRect(width: 100, height: 25))
        label.frame.topMiddle = activityIndicator.frame.bottomMiddle + CGPoint(x: 0, y: 25)
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .systemGray
        label.text = "Loading"
        return label
    }()
    
    public lazy var activityContainer: UIView = {
        let view = UIView(frame: view.frame)
        view.addSubviews(activityIndicator, activityLabel)
        view.backgroundColor = .black
        return view
    }()
    
    
    // MARK: - Open Methods
    
    /// Shows loading.
    ///
    /// Adds the activity container to subviews.
    /// Override this method to perform additional work.
    /// You need to call the `super` method.
    open func showLoading() -> Void {
        view.addSubview(activityContainer)
        activityIndicator.startAnimating()
    }
    
    /// Hides loading.
    ///
    /// Removes the activity container from subviews.
    /// Override this method to perform additional work.
    /// You need to call the `super` method.
    open func hideLoading() -> Void {
        activityIndicator.stopAnimating()
        activityContainer.removeFromSuperview()
    }
    
}
