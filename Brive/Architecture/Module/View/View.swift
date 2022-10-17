import ModKit
import UIKit

open class View: UIViewController, Viewing {
    
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
    
    
    // MARK: - Open Methods
    
    /// Shows loading.
    ///
    /// Adds the activity indicator and label to subviews.
    /// Override this method to perform additional work.
    /// You need to call the `super` method.
    open func showLoading() -> Void {
        view.addSubview(activityIndicator)
        view.addSubview(activityLabel)
        activityIndicator.startAnimating()
    }
    
    /// Hides loading.
    ///
    /// Removes the activity indicator and label from subviews.
    /// Override this method to perform additional work.
    /// You need to call the `super` method.
    open func hideLoading() -> Void {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        activityLabel.removeFromSuperview()
    }
    
}
