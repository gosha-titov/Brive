import UIKit

/// A type that requires you to have a  tab bar controller.
protocol TabBarControllable: Controllable where Container == UITabBarController {}


/// A type that requires you to have a navigation controller.
protocol NavigationControllable: Controllable where Container == UINavigationController {}


/// A type that requires you to have a container view controller.
protocol Controllable: AnyObject {
    
    /// A type that can keep child view controllers.
    associatedtype Container: UIViewController
    
    /// A container that keeps child view controllers.
    /// It is a navigation or tab bar controller.
    var container: Container { get set }
    
}
