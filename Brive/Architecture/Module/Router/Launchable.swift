import UIKit

/// A type that the root router should conform to.
public protocol Launchable where Self: Routable {
    
    /// Sets the router's view to display.
    func setView(_ view: UIViewController?)-> Void
    
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
    
    func launch(from window: UIWindow?) -> Void {
        guard let window else { return }
        window.rootViewController = view
        window.makeKeyAndVisible()
        load()
    }
    
}
