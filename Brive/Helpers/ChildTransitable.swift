protocol ChildTransitable: AnyObject {
    
    func transition(_ transition: DefaultRouter.Transition, for type: Any) -> Void
    
    func transition(of type: Any) -> DefaultRouter.Transition?
    
}
