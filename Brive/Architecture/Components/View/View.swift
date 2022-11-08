import ModKit
import UIKit

open class View<Interacting: ViewToInteractorInterface>: Viewable, InteractorToViewInterface {
    
    // MARK: - Open Properties
    
    /// A view that contains the activity label and indicator.
    open lazy var activityContainer: UIView = {
        let view = UIView(frame: view.frame)
        view.addSubviews(activityIndicator, activityLabel)
        view.backgroundColor = .black
        return view
    }()
    
    /// A view that shows that a task is in progress.
    open lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.center = activityContainer.center
        indicator.hidesWhenStopped = true
        indicator.style = .large
        indicator.color = .white
        return indicator
    }()
    
    /// A view that displays a text under the activity indicator.
    open lazy var activityLabel: UILabel = {
        let label = UILabel(frame: CGRect(width: 100, height: 25))
        label.frame.topPoint = activityIndicator.frame.bottomPoint + CGPoint(x: 0, y: 25)
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .systemGray
        label.text = "Loading"
        return label
    }()
    
    
    // MARK:  Public Properties
    
    /// A State value that indicating the current state of the module.
    ///
    /// There are only two possible states: active and inactive.
    public final var state: DefaultModule.State { module?.state ?? .inactive }
    
    /// The interactor that is responsible for business logic.
    ///
    /// You can access this interactor only if the state of the module is active;
    /// otherwise the value in this property is `nil`.
    public final var interactor: Interacting? {
        return state == .active ? _interactor : nil
    }
    
    
    // MARK: Private Properties
    
    /// The internal interactor of this view.
    private var _interactor: Interacting? { module?.interactor as? Interacting }
    
    
    // MARK: - Open Methods
    
    /// Shows loading.
    ///
    /// Adds the activity container to subviews, then starts animating of the activity indicator.
    /// Override this method to perform any additional work.
    /// You need to call the `super` method.
    open func showLoading() -> Void {
        view.addSubview(activityContainer)
        activityIndicator.startAnimating()
    }
    
    /// Hides loading.
    ///
    /// Stops animating of the activity indicator, then removes the activity container from subviews.
    /// Override this method to perform any additional work.
    /// You need to call the `super` method.
    open func hideLoading() -> Void {
        activityIndicator.stopAnimating()
        activityContainer.removeFromSuperview()
    }
    
}
