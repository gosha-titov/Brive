import UIKit

/// A type that requires you to have a navigation controller.
public protocol TabBarControllable: AnyObject {
    
    /// The navigation controller of this router.
    var rootController: UITabBarController { get set }
    
}


/// A type that requires you to have a tab bar controller.
public protocol NavigationControllable: AnyObject {
    
    /// The tab bar controller of this router.
    var rootController: UINavigationController? { get set }
    
}
