//
//  User.swift
//  App
//
//  Created by Johann Kerr on 3/12/18.
//

import Foundation
import Vapor
import FluentMySQL
import Authentication


final class User: Content {
    var id: Int?
    var username: String
    var password: String
    
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    final class PublicUser: Content {
        var id: Int?
        var username: String
        
        
        init(username: String) {
            self.username = username
        }
        
        init(user: User) {
            if let id = user.id {
                self.id = id
            }
            self.username = user.username
        }
    }
}

extension User {
    var posts: Children<User, Post> {
        return children(\.authorID)
    }
}


extension User.PublicUser: MySQLModel {
    static let entity = User.entity
}

extension User.PublicUser: Parameter {}


extension User: MySQLModel {}
extension User: Parameter {}
extension User: Migration {}

extension User: BasicAuthenticatable {
    static let usernameKey: UsernameKey = \User.username
    static let passwordKey: PasswordKey = \User.password
}

extension User: TokenAuthenticatable {
    typealias TokenType = Token
}
