protocol Revokable: AnyObject {
    
    func revoke(_ child: AnyObject, byReceiving output: Any?, animated: Bool, shouldKeepModuleLoaded: Bool) -> Void
    
}
