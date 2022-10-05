import UIKit

/// A type that requires you to have a navigation controller.
protocol TabBarControllable: AnyObject {
    
    /// The navigation controller of this router.
    var controller: UITabBarController { get set }
    
}
