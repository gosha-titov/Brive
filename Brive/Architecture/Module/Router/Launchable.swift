import ModKit
import UIKit

/// A type that the root router should conform to.
public protocol Launchable where Self: DefaultRouter {
    
    /// Launches the router from the given window.
    func launch(from window: UIWindow) -> Void
    
}


public extension Launchable {
    
    func launch(from window: UIWindow) -> Void {
        if let self = self as? NavigationControllable {
            self.rootController = UINavigationController()
            view.executeSafely { self.rootController!.pushViewController($0) }
            window.rootViewController = self.rootController
        } else if let self = self as? TabBarControllable {
            window.rootViewController = self.rootController
        } else {
            window.rootViewController = view
        }
        window.makeKeyAndVisible()
        activate()
    }
    
}
