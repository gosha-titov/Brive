import UIKit

/// A module that can be launched from a window.
///
/// The purpose of a launch module is to run the module tree by calling ``launch(from:)`` method.
///
/// Subclass the `LaunchModule` class to simplify its creation:
///
///     final class AppModule: LaunchModule {
///         init() {
///             let builder = AppBuilder()
///             super.init(builder: builder)
///         }
///     }
///
/// Insert the following code into the `SceneDelegate` class of your application:
///
///     func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
///
///         guard let windowScene = (scene as? UIWindowScene) else { return }
///         let window = UIWindow(windowScene: windowScene)
///         self.window = window
///
///         let appModule = AppModule()
///         appModule.launch(from: window)
///     }
///
open class LaunchModule {
    
    /// A builder that can build a root module.
    let builder: any MainBuildable
    
    
    /// Launches this module from the given window.
    public final func launch(from window: UIWindow) -> Void {
        
        let child = builder.buildRootModule()
        var viewToDisplay = UIViewController()
        child.state = .active
        
        if let upperView = child.router.upperView { viewToDisplay = upperView }
        else { child.router.substitutedView = viewToDisplay }
        
        window.rootViewController = viewToDisplay
        window.makeKeyAndVisible()
    }
    
    
    /// Creates a module with a main builder.
    public init(builder: any MainBuildable) {
        self.builder = builder
    }
    
}
