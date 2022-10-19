protocol ChildHideable: AnyObject {
    
    func hide(_ child: AnyObject, with output: Any?, _ animated: Bool, keep loaded: Bool) -> Void
    
}
