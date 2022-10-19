protocol ParentDisplayable: AnyObject {
    
    func parentWillDisplay(with input: Any?) -> Void
    
}


extension ParentDisplayable {
    
    func parentWillDisplay(with input: Any?) -> Void {}
    
}
