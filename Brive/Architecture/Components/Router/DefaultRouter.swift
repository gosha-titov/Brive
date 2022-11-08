import UIKit

/// A default router which module doesn't own child modules.
///
/// The `DefaultRouter` class defines the shared behavior that’s common to all routers.
/// You almost always subclass the `DefaultRouter` but you rarely implement it,
/// since each router has already organized flow logic between modules.
/// You usually do this as in the example below:
///
///     final class SomeRouter: DefaultRouter {}
///
/// The `state` property is indicating the current state of the module.
/// There are only two possible states: active and inactive.
///
/// In order to complete this module and display the parent one, call
/// the ``complete(byPassing:animated:shouldKeepModuleLoaded:)`` method.
///
/// If the module is presented, then you can set the block to execute after the module is dismissed.
/// Use `dismissingCompletion` property to do this.
///
open class DefaultRouter {
    
    /// A type that can be performed to the module.
    enum Transition { case presented, pushed, permanent }
    
    
    // MARK: - Public Properties
    
    /// A State value that indicating the current state of the module.
    ///
    /// There are only two possible states: active and inactive.
    public final var state: DefaultModule.State { module?.state ?? .inactive }
    
    /// The block to execute after the module is dismissed.
    public var dismissingCompletion: (() -> Void)?
    
    
    // MARK: Internal Methods
    
    /// A Transition value that is performed to this module.
    var transition: Transition = .permanent
    
    /// The module that owns this router.
    weak var module: DefaultModule?
    
    /// The view of the module.
    var view: UIViewController? { module?.view }
    
    /// A navigation controller of this module.
    var navigationController: UINavigationController?
    
    /// A tab bar controller of this module.
    var tabBarController: UITabBarController?
    
    /// A view that can substitute the view of the module if it doesn't exist.
    weak var substitutedView: UIViewController?
    
    /// Returns an upper view of this module.
    final var upperView: UIViewController? {
        return navigationController ?? tabBarController ?? view
    }
    
    
    // MARK: - Public Methods
    
    /// Completes the module.
    ///
    /// It hides this module and shows a parent one by passing some output data.
    /// The transition is the reverse of the one that was performed to this module.
    /// You usually use this method when a module is presented modally.
    ///
    /// **The method is not executed if:**
    /// - a module is a tab of a parent's tab bar controller,
    /// * a module doesn't have a parent,
    /// - a module is a root module,
    /// * a module is inactive.
    ///
    /// - Parameter output: Some output data you want to pass to the parent module.
    /// - Parameter animated: Pass `true` to animate the transition; otherwise, pass `false`.
    /// - Parameter loaded: Pass `true` to keep this module loaded while the parent is loaded; otherwise, pass `false`.
    ///
    public func complete(byPassing output: Any? = nil, animated: Bool = true, shouldKeepModuleLoaded loaded: Bool = false) -> Void {
        guard state == .active, let module else { return }
        module.complete(byPassing: output, animated: animated, shouldKeepModuleLoaded: loaded)
    }
    
}
