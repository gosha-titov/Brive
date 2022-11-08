import UIKit

protocol ChildUpperViewable: AnyObject {
    
    func upperView(of type: Any) -> UIViewController?
    
}
