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
    
    
    init(username: String) {
        self.username = username
    }
}

extension User {
    var posts: Children<User, Post> {
        return children(\.authorID)
    }
}


extension User: SQLiteModel {}
extension User: Parameter {}
extension User: Migration {}
