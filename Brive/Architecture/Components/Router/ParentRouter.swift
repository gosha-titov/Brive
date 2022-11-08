import UIKit

/// A default router which module owns child modules.
///
/// The `ParentRouter` class defines the shared behavior that’s common to all routers.
/// You almost always subclass the `ParentRouter` but you rarely implement it,
/// since each router has already organized flow logic between modules.
/// You usually do this as in the example below:
///
///     final class SomeRouter: ParentRouter<SomeType> {}
///
/// The `state` property is indicating the current state of the module that is active and inactive.
///
/// In order to complete this module and display the parent one, call
/// the ``complete(byPassing:animated:shouldKeepModuleLoaded:)`` method.
///
/// If the module is presented, then you can set the block to execute after the module is dismissed.
/// Use `dismissingCompletion` property to do this.
///
/// **Ways to show a child module:**
///
/// - **Present Modally.** In order to present a child module modally, use
/// the ``present(module:byPassing:animated:completion:)`` method.
///
/// * **Using Navigation Controller.**
/// Use the ``push(module:byPassing:animated:)`` method to push a child module onto the navigation stack.
/// If you need this module as the root for a navigation controller, then call
/// the ``establish(navigationController:)`` method.
/// In other cases, the navigation controller is shared between related modules.
///
/// - **Using Tab  Bar Controller.** If you need to use a tab bar controller for this module, then call
/// the ``establish(tabBarController:tabBarModules:)`` method.
///  Use the ``select(module:byPassing:)`` method to select a child module directly.
///
/// - Note: When a child module is completed, the router automatically removes it in the same as it was shown.
///
open class ParentRouter<ChildType: Equatable>: DefaultRouter {
    
    /// A type that represents a parent module.
    typealias ParentModule = DefaultModule & Invokable & ChildTransitable & ChildUpperViewable & ChildSubstitutable & ChildContactable & NavigationSharable & ChildDismissingCompletionKeepable
    
    
    // MARK: - Internal Properties
    
    /// An array of modules that is used for a tab bar controller.
    var tabBarModules = [ChildType]()
    
    
    // MARK: - Public Methods
    
    /// Presents a child module modally.
    ///
    /// Before a child module is presented, it becomes active and receives some input data.
    ///
    /// If a child module doesn't have a view to present, then its view substituted for the view of this module, but a presentation is not performed.
    /// That is, a child module can present its own child modules.
    ///
    /// **The method is not executed if:**
    /// - a module doesn't have a view that can present a child module,
    /// * a module is inactive.
    ///
    /// - Parameter child: A child module to present.
    /// - Parameter input: Some input data you want to pass to the child module.
    /// - Parameter animated: Pass `true` to animate the transition; otherwise, pass `false`.
    /// - Parameter completion: The block to execute after the presentation finishes.
    ///
    public final func present(module child: ChildType, byPassing input: Any? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> Void {
        guard let view = navigationController ?? tabBarController ?? view ?? substitutedView,
              let module = module as? ParentModule,
              state == .active else { return }
        
        module.invoke(child, byPassing: input)
        let childView = module.upperView(of: child)
        if let childView {
            view.present(childView, animated: animated, completion: completion)
            module.transition(.presented, for: child)
        } else {
            module.substituteView(of: child, for: view)
        }
    }
    
    /// Pushes a child module onto a navigation stack.
    ///
    /// Before a child module is pushed, it becomes active and receives some input data.
    ///
    /// This method shares a navigation controller with a child, that is,
    /// a child module can pushes its own child modules onto the shared navigation stack.
    /// You don't need to establish a navigation controller for a child module.
    /// If you do this, then a child navigation controller will be replaced with a shared one.
    ///
    /// If a child module doesn't have a view to push, then a pushing is not performed,
    /// but a child module gets a shared navigation controller.
    ///
    /// If this module is a root for a navigation stack, you should call
    /// the ``establish(navigationController:)`` method before a module becomes active.
    ///
    /// **The method is not executed if:**
    /// - a module doesn't have a navigation controller that can push a child module,
    /// * a module is inactive.
    ///
    /// - Parameter child: A child module to push.
    /// - Parameter input: Some input data you want to pass to the child module.
    /// - Parameter animated: Pass `true` to animate the transition; otherwise, pass `false`.
    ///
    public final func push(module child: ChildType, byPassing input: Any? = nil, animated: Bool = true) -> Void {
        guard let module = module as? ParentModule,
              let navigationController,
              state == .active else { return }
        
        module.invoke(child, byPassing: input)
        module.share(nil, with: child)
        
        let childView = module.upperView(of: child)
        if let childView {
            navigationController.pushViewController(childView, animated: animated)
            module.transition(.pushed, for: child)
        }
        module.share(navigationController, with: child)
    }
    
    /// Selects a child module.
    ///
    /// Before a child module is selected, it becomes active and receives some input data.
    ///
    /// The tab bar controller should be established before a module becomes active. To do this, use
    /// the ``establish(tabBarController:tabBar:)`` method.
    ///
    /// **The method is not executed if:**
    /// - a module doesn't have a tab bar controller that can select a child module,
    /// * a child module is not a tab bar module,
    /// - a module is inactive.
    ///
    /// - Parameter child: A child module to select.
    /// - Parameter input: Some input data you want to pass to the child module.
    ///
    public final func select(module child: ChildType, byPassing data: Any? = nil) -> Void {
        guard let index = tabBarModules.firstIndex(of: child),
              let module = module as? ParentModule,
              let tabBarController else { return }
        
        tabBarController.selectedIndex = index
        if let data { module.passToChild(child, data) }
    }
    
    /// Establishes a navigation controller for this module.
    ///
    /// After the navigation controller is set, pushes a view of this module onto the navigation stack.
    /// If the module also uses a tab bar controller, then pushes it instead of a view.
    ///
    /// If you need to use a tab bar controller together with a navigation controller then call this method
    /// after a tab bar controller is established; otherwise, a tab bar is not in a view hierarchical.
    ///
    /// **Call this method before a module becomes active.**
    public func establish(navigationController: UINavigationController) -> Void {
        guard state == .inactive else { return }
        
        self.navigationController = navigationController
        if let view = tabBarController ?? view {
            navigationController.pushViewController(view, animated: false)
        }
    }
    
    /// Establishes a tab bar controller for this module.
    ///
    /// You need to pass modules that are used for a tab bar controller.
    /// They can't be completed.
    ///
    /// If you need to use a tab bar controller together with a navigation controller then call this method
    /// before a navigation controller is established; otherwise, a tab bar is not in a view hierarchical.
    ///
    /// Duplicates of tab bar modules will be removed.
    ///
    /// **Call this method before a module becomes active.**
    public final func establish(tabBarController: UITabBarController, tabBarModules childModules: [ChildType]) -> Void {
        guard state == .inactive, let module = module as? ParentModule else { return }
        tabBarModules = childModules.removedDuplicates()
        guard !tabBarModules.isEmpty else { return }
        
        self.tabBarController = tabBarController
        var views = [UIViewController]()
        for child in tabBarModules {
            module.invoke(child, byPassing: nil)
            let childView = module.upperView(of: child)
            if let childView {
                views.append(childView)
            } else {
                let emptyView = UIViewController()
                module.substituteView(of: child, for: emptyView)
                views.append(emptyView)
            }
            module.transition(.permanent, for: child)
        }
        tabBarController.setViewControllers(views, animated: false)
    }
    
}

extension ParentRouter: ChildRemovable {
    
    /// Removes child in a way it was shown.
    func removeChild(_ type: Any, animated: Bool) -> Void {
        guard let module = module as? ParentModule,
              let child = type as? ChildType,
              let transition = module.transition(of: child),
              let childView = module.upperView(of: child) else { return }
        switch transition {
        case .presented:
            let completion = module.dismissingCompletion(of: child)
            childView.dismiss(animated: animated, completion: completion)
        case .pushed: navigationController?.popViewController(animated: animated)
        case .permanent: return
        }
    }
    
}
