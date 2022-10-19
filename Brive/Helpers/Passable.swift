protocol Passable: AnyObject {
    
    func passToChild(_ module: Any, _ value: Any) -> Void
    
    func passToParent(_ value: Any) -> Void
    
}


extension Passable {
    
    func passToChild(_ module: Any, _ value: Any) -> Void {}
    
    func passToParent(_ value: Any) -> Void {}
    
}
