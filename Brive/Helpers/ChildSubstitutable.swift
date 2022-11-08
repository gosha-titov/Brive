import UIKit

protocol ChildSubstitutable: AnyObject {
    
    func substituteView(of type: Any, for substitutedView: UIViewController) -> Void
    
}
