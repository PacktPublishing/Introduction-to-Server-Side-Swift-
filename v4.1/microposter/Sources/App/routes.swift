import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    let postController = PostController()
    let userController = UserController()
    try router.register(collection: userController)
    try router.register(collection: postController)
    
}
