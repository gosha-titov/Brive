import UIKit

open class Routable: Passable, Receivable, ParentDisplayable {
    
    /// A transition that is performed to the child module.
    enum Transition { case presented, pushed, permanent }
    
    // MARK: - Properties
    
    /// The parent router of this router.
    var parent: Routable?
    
    /// The view to display.
    var view: UIViewController?
    
    /// The transition that was performed to this module.
    var transition: Transition?
    
    
    // MARK: - Methods
    
    /// Loads this router and therefore its module.
    func load() -> Void {}
    
    /// Unloads this router and therefore its module.
    func unload() -> Void {}
    
}
