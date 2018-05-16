@testable import App
import Dispatch
import XCTest

final class AppTests : XCTestCase {
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

    static let allTests = [
        ("testNothing", testNothing),("testPublicUser", testPublicUserInit)
    ]
}
