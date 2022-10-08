import UIKit

/// A type that requires you to have a navigation controller.
protocol TabBarControllable: AnyObject {
    
    /// The navigation controller of this router.
    var container: UITabBarController { get set }
    
}


/// A type that requires you to have a tab bar controller.
protocol NavigationControllable: AnyObject {
    
    /// The tab bar controller of this router.
    var container: UINavigationController? { get set }
    
}
