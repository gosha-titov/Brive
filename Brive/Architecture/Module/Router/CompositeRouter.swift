import UIKit

/// a router whose view consists of other views.
open class CompositeRouter<Builder: Buildable, Interacting: RouterToInteractorInterface>: PresentationRouter<Builder, Interacting> {
    
    public var components = [Module]() {
        didSet { components.removeDuplicates() }
    }
    
    override public func present(module: Module, with input: Value? = nil, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard !components.contains(module) else { return }
        super.present(module: module, with: input, animated: animated, completion: completion)
    }
    
    override func routerIsLoading() -> Void {
//        guard let container = view as? CompositeView<Module> else { return }
        if components.isEmpty { components = allChildModules }
        for module in components {
            let child = buildChildModuleIfNeeded(module)
//            if let view = child.view {
//                child.transition = .permanent
//                container.components[module] = view
//            }
        }
    }
    
    override func didBuildChildModule(_ child: Routable) {
        if let child = child as? NavigationControllable {
            child.embedView()
        } else if child.view.isNil {
            child.view = .init()
        }
    }
    
}
