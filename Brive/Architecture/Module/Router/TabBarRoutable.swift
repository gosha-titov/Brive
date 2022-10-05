import UIKit

/// A type that all tabbar routers should conform to.
public protocol TabBarRoutable: ParentRoutable {
    
    /// A controller that binds self to the following one.
    var controller: UITabBarController { get }
    
    /// Contains all tabbar modules.
    var tabbar: [ChildModule] { get }
    
}


public extension TabBarRoutable {
    
    /// Activates the tabbar router.
    func activate() {
        interactor.activate()
        var views = [UIViewController]()
        for module in tabbar {
            let view = attachChild(of: module)
            views.append(view)
        }
        controller.setViewControllers(views, animated: true)
    }
    
}
