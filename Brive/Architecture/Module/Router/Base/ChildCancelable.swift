protocol ChildCancelable: AnyObject {
    
    func cancel(_ child: DefaultRouter, with result: DefaultRouter.Value?, _ unloaded: Bool, _ animated: Bool) -> Void
    
}
