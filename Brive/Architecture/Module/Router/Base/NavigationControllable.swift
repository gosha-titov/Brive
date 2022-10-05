import UIKit

/// A type that requires you to have a tab bar controller.
protocol NavigationControllable: AnyObject {
    
    /// The tab bar controller of this router.
    var controller: UINavigationController? { get set }
    
}
