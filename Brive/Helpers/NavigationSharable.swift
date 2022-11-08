import UIKit

protocol NavigationSharable: AnyObject {
    
    func share(_ navigationController: UINavigationController?, with child: Any) -> Void
    
}
