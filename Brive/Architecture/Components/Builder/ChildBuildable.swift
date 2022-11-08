/// A type that can build child modules.
///
/// A builder that conforms to the `ChildBuildable` protocol can build child modules by calling
/// the ``build(childModuleOf:)`` method.
///
/// Each child module is associated with a specific child type. Implement this as in the example below:
///
///     enum ChildType { case .messages, .settings }
///
/// The implementation of `build(childModuleOf:)` method shoud be as in the example below:
///
///     func build(childModuleOf type: ChildType) -> ChildModule {
///         switch type {
///         case .messages: return buildMessagesModule()
///         case .settings: return buildSettingsModule()
///         }
///     }
///
/// Building a specific module shoud be implemented in one of the following ways:
///
///     // Returns a default module
///     func buildSomeModule() -> ChildModule {
///         let router = SomeRouter()
///         let interactor = SomeInteractor()
///         let view = SomeView()
///         return DefaultModule(router: router, interactor: interactor, view: view)
///     }
///
///     // Returns a non-viewing default module
///     func buildSomeModule() -> ChildModule {
///         let router = SomeRouter()
///         let interactor = SomeInteractor()
///         return DefaultModule(router: router, interactor: interactor)
///     }
///
///     // Returns a parent module
///     func buildSomeModule() -> ChildModule {
///         let builder = SomeBuilder()
///         let router = SomeRouter()
///         let interactor = SomeInteractor()
///         let view = SomeView()
///         return ParentModule(builder: builder, router: router, interactor: interactor, view: view)
///     }
///
///     // Returns a non-viewing parent module
///     func buildSomeModule() -> ChildModule {
///         let builder = SomeBuilder()
///         let router = SomeRouter()
///         let interactor = SomeInteractor()
///         return ParentModule(builder: builder, router: router, interactor: interactor)
///     }
///
public protocol ChildBuildable: AnyObject {
    
    /// A child module.
    typealias ChildModule = DefaultModule
    
    /// A type that associated with a specific child module.
    ///
    /// Implement this as in the example below:
    ///
    ///     enum ChildType { case .messages, .settings }
    ///
    associatedtype ChildType: Hashable
    
    /// Builds a specific child module.
    ///
    /// The implementation of this method shoud be as in the example below:
    ///
    ///     func build(childModuleOf type: ChildType) -> ChildModule {
    ///         switch type {
    ///         case .messages: return buildMessagesModule()
    ///         case .settings: return buildSettingsModule()
    ///         }
    ///     }
    ///
    /// Building a specific module shoud be implemented in one of the following ways:
    ///
    ///     // Returns a default module
    ///     func buildSomeModule() -> ChildModule {
    ///         let router = SomeRouter()
    ///         let interactor = SomeInteractor()
    ///         let view = SomeView()
    ///         return DefaultModule(router: router, interactor: interactor, view: view)
    ///     }
    ///
    ///     // Returns a non-viewing default module
    ///     func buildSomeModule() -> ChildModule {
    ///         let router = SomeRouter()
    ///         let interactor = SomeInteractor()
    ///         return DefaultModule(router: router, interactor: interactor)
    ///     }
    ///
    ///     // Returns a parent module
    ///     func buildSomeModule() -> ChildModule {
    ///         let builder = SomeBuilder()
    ///         let router = SomeRouter()
    ///         let interactor = SomeInteractor()
    ///         let view = SomeView()
    ///         return ParentModule(builder: builder, router: router, interactor: interactor, view: view)
    ///     }
    ///
    ///     // Returns a non-viewing parent module
    ///     func buildSomeModule() -> ChildModule {
    ///         let builder = SomeBuilder()
    ///         let router = SomeRouter()
    ///         let interactor = SomeInteractor()
    ///         return ParentModule(builder: builder, router: router, interactor: interactor)
    ///     }
    func build(childModuleOf type: ChildType) -> ChildModule
    
}
