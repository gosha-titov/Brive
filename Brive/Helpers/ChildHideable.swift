protocol ChildHideable: AnyObject {
    
    func hide(_ child: AnyObject, with output: Any?, animateTransition animated: Bool, shouldKeepLoaded loaded: Bool) -> Void
    
}
