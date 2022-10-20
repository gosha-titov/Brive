import UIKit

/// A type that can be launched from a window.
///
/// Routers that conform to `Launchable` protocol can be launched from a window using ``launch(from:)`` method.
/// Before you launch a router, you should call ``setView(_:)`` method to set a view to display;
/// otherwise none of the following modules can be displayed.
///
/// These methods are already inplemented by default, so you should never override them.
///
public protocol Launchable where Self: Routable {
    
    /// Sets the router's view to display.
    func setView(_ view: UIViewController?) -> Void
    
    /// Launches the router from the given window.
    func launch(from window: UIWindow?) -> Void
    
}


public extension Launchable {
    
    func setView(_ view: UIViewController?) -> Void {
        if let self = self as? NavigationControllable {
            self.embedView()
        } else {
            self.view = view ?? .init()
        }
    }
    
    func launch(from window: UIWindow) -> Void {
        window.rootViewController = view
        window.makeKeyAndVisible()
        load()
    }
    
}
