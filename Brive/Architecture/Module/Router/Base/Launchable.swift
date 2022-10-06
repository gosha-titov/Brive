import UIKit

/// A type that the root router should conform to.
public protocol Launchable where Self: DefaultRouter {
    
    /// Launches the router from the given window.
    func launch(from window: UIWindow) -> Void
    
}


public extension Launchable where Self: NavigationControllable {
    
    func launch(from window: UIWindow) -> Void {
        rootController = UINavigationController()
        window.rootViewController = rootController
        window.makeKeyAndVisible()
        activate()
    }
    
}


public extension Launchable where Self: TabBarControllable {
    
    func launch(from window: UIWindow) -> Void {
        window.rootViewController = rootController
        window.makeKeyAndVisible()
        activate()
    }
    
}
