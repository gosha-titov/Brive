/// A type that all parent routers should conform to.
protocol ParentRoutable: Routable {
    
    /// The list of child routers.
    var children: [Routable] { get set }
    
    /// Attaches the given router to the child routers.
    func attach(child: Routable) -> Void
    
    /// Detaches the given router from the child routers.
    func detach(child: Routable) -> Void
    
    /// Detaches all child routers.
    func detachChildren() -> Void
    
}


extension ParentRoutable {
    
    func attach(child: Routable) -> Void {
        children.append(child)
        child.parent = self
        child.activate()
    }
    
    func detach(child: Routable) -> Void {
        let detached = children.filter { $0 === child }
        detached.forEach { $0.deactivate() }
        children = children.filter { $0 !== child }
    }
    
    func detachChildren() -> Void {
        children.forEach { $0.deactivate() }
        children.removeAll()
    }
    
}
