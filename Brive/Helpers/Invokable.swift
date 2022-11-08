import UIKit

protocol Invokable: AnyObject {
    
    @discardableResult func invoke(_ type: Any, byPassing input: Any?) -> UIViewController?
    
}
