import UIKit

open class Viewable: UIViewController, ModuleBelongable {
    
    /// The module that owns this view.
    weak var module: DefaultModule?
    
}
