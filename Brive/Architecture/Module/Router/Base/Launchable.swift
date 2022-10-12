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
        if let self = self as? NavigationControllable {
            self.embedView()
        } else {
            self.view = view ?? .init()
        }
    }
    
    func launch(from window: UIWindow) -> Void {
        window.rootViewController = view
        window.makeKeyAndVisible()
        activate()
    }
    
}
