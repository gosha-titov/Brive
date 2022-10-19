protocol ChildCompletable: AnyObject {
    
    func childDidComplete(_ module: Any, with output: Any?) -> Void
    
}


extension ChildCompletable {
    
    func childDidComplete(_ module: Any, with output: Any?) -> Void {}
    
}
