/// The base class that is sort of a protocol for all interactors that is used for internal work.
open class Interactable: ModuleBelongable, Eventable {
    
    /// The module that owns this interactor.
    weak var module: DefaultModule?
    
    
    // MARK: - Lifecycle
    
    /// Called after the module is activated.
    func activate() -> Void {}
    
    /// Called when the module is about to be suspended.
    func suspend() -> Void {}
    
    /// Called after the module is resumed.
    func resume() -> Void {}
    
    /// Called when the module is about to be deactivated.
    func deactivate() -> Void {}
    
}
