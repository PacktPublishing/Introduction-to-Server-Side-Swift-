//
//  User.swift
//  App
//
//  Created by Johann Kerr on 3/12/18.
//

import Foundation
import Vapor
import FluentSQLite


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


extension User.PublicUser: SQLiteModel {
    static let entity = User.entity
}

extension User.PublicUser: Parameter {}


extension User: SQLiteModel {}
extension User: Parameter {}
extension User: Migration {}
