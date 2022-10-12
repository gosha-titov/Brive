import UIKit

/// A type that indicating that a router owns a tab bar controller.
protocol TabBarControllable: Controllable {}


/// A type that indicating that a router owns a navigation controller.
protocol NavigationControllable: Controllable {
    
    /// Embeds view in the navigation controller.
    func embedView() -> Void
    
}


/// A type that indicating that a router owns a navigation or a tab bar controller.
protocol Controllable: AnyObject {}
