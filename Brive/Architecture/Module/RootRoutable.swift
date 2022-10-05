import UIKit

/// A type that the root router should conform to.
public protocol Launching: AnyObject {
    
    /// Launches the router from the given window.
    func launch(from window: UIWindow) -> Void
    
}


public extension Launching {
    
    func launch(from window: UIWindow) -> Void {
//        window.rootViewController = controller
//        window.makeKeyAndVisible()
//        activate()
    }
    
}
