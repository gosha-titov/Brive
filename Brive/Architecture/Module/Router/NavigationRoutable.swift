import UIKit

/// A type that all navigation routers should conform to.
public protocol NavigationRoutable: ParentRoutable, Routing {
    
    /// A controller that binds self to the following one.
    var controller: UINavigationController { get }
    
}


public extension NavigationRoutable {
    
    func route(to module: ChildModule) {
        let view = attachChild(of: module)
        controller.pushViewController(view, animated: true)
    }
    
}
