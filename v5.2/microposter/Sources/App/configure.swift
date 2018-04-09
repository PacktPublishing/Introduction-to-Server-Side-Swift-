import FluentMySQL
import Vapor
import Leaf
import Authentication
import FluentMySQL

/// Called before your application initializes.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#configureswift)
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    // Register providers first
    try services.register(FluentMySQLProvider())
    try services.register(LeafProvider())
    try services.register(AuthenticationProvider())
    config.prefer(LeafRenderer.self, for: TemplateRenderer.self)
  

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(DateMiddleware.self) // Adds `Date` header to responses
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    
    let directoryConfig = DirectoryConfig.detect()
    services.register(directoryConfig)
    
    // Configure a SQLite database
    var databases = DatabaseConfig()
    let db = MySQLDatabase(hostname: "localhost", user: "micro", password: "micro", database: "microposter")
    try databases.add(database: db, as: .mysql)
    services.register(databases)

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Post.self, database: .mysql)
    migrations.add(model: User.self, database: .mysql)
    migrations.add(model: Token.self, database: .mysql)
    services.register(migrations)
    User.PublicUser.defaultDatabase = .mysql

    // Configure the rest of your application here
}
