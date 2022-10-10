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
        if let self = self as? any NavigationControllable, let view {
            self.container.pushViewController(view)
        }
    }
    
    func launch(from window: UIWindow) -> Void {
        
        // For some reasons, this project doesn't build but Playground does and work.
        // Error: Command CompileSwift failed with a nonzero exit code.
//        if let self = self as? any Controllable {
//            window.rootViewController = self.container
//        }
        
        if let self = self as? any NavigationControllable {
            window.rootViewController = self.container
        } else if let self = self as? any TabBarControllable {
            window.rootViewController = self.container
        } else {
            if view.isNil { view = .init() }
            window.rootViewController = view
        }
        window.makeKeyAndVisible()
        activate()
    }
    
}
