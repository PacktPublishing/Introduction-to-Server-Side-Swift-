//
//  Token.swift
//  App
//
//  Created by Johann Kerr on 3/19/18.
//

import Foundation
import Vapor
import Authentication
import FluentMySQL
import Crypto

final class Token: Content {
    var id: Int?
    var token: String
    var userID: User.ID
    
    
    init(token: String, userID: User.ID) {
        self.token = token
        self.userID = userID
    }
    
    init(_ user: User) throws {
        let token = OSRandom().data(count: 16).base64EncodedString()
        self.token = token
        self.userID = try user.requireID()
    }
}

extension Token: MySQLModel {}
extension Token: Migration {}

extension Token {
    var user: Parent<Token, User> {
        return parent(\.userID)
    }
}

extension Token: Authentication.Token {
    static let userIDKey: UserIDKey = \Token.userID
    typealias UserType = User
}

extension Token: BearerAuthenticatable {
    static let tokenKey: TokenKey = \Token.token
}
