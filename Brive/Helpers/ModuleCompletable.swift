protocol ModuleCompletable: AnyObject {
    
    func complete(byPassing output: Any?, animated: Bool, shouldKeepModuleLoaded loaded: Bool) -> Void
    
}
