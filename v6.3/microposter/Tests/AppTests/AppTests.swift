@testable import App
import Dispatch
import XCTest
import Vapor

final class AppTests : XCTestCase {
    var app: Application!
    
    override func setUp() {
        self.app = try! Application.setUp()
    }
    
    override func tearDown() {
        self.app = nil
    }
    func testNothing() throws {
        // 1 grab some value
        // 2 prove that it should be so
        XCTAssert(true)
    }
    
    func testPublicUserInit() throws {
        let user = User(username: "johann", password: "vaportest")
        let publicUser = User.PublicUser(user: user)
        
        XCTAssertEqual(user.username, publicUser.username, "PublicUser Init keeps user value")
        XCTAssertNotEqual(user.password, publicUser.username)
    }
    
    
    func testUserController() throws {
        // 1. Create a user
        // 2. Send a request to the index action
        // 3. Compare details about our user with the response
        let request = Request(using: self.app)
        let user = User(username: "johann", password: "vapor")
        user.save(on: request)
        
        
        let userController = UserController()
        let users = try userController.index(request).wait()
        
        let lastUser = users.last!
        XCTAssertEqual(lastUser.username, user.username)
        XCTAssertNotEqual(users.count, 0)
    }

    static let allTests = [
        ("testNothing", testNothing),("testPublicUser", testPublicUserInit)
    ]
}


extension Application {
    static func setUp() throws -> Application {
        var config = Config.default()
        var env = try Environment.detect()
        var services = Services.default()
        
        try App.configure(&config, &env, &services)
        
        let app = try Application(
            config: config,
            environment: env,
            services: services
        )
        
        try App.boot(app)
        return app
    }
}
