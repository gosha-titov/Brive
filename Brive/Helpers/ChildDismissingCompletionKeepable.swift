protocol ChildDismissingCompletionKeepable: AnyObject {
    
    func dismissingCompletion(of type: Any) -> (() -> Void)?
    
}
