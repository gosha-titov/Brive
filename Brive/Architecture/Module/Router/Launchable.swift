import ModKit
import UIKit

/// A type that the root router should conform to.
public protocol Launchable where Self: DefaultRouter {
    
    /// Sets the router's view that will be shown.
    func set(view: UIViewController?)-> Void
    
    /// Launches the router from the given window.
    func launch(from window: UIWindow) -> Void
    
}


public extension Launchable {
    
    func set(view: UIViewController?) -> Void {
        self.view = view
        if let self = self as? NavigationControllable {
            self.rootController = UINavigationController()
            view.executeSafely {
                self.rootController!.pushViewController($0)
            }
        }
    }
    
    func launch(from window: UIWindow) -> Void {
        if let self = self as? NavigationControllable {
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
