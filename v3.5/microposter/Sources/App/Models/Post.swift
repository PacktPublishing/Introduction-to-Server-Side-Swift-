//
//  Post.swift
//  App
//
//  Created by Johann Kerr on 2/27/18.
//

import Foundation
import Vapor
import FluentSQLite

final class Post: Content {
    var content: String
    var authorID: User.ID
    var id: Int?
    
    
    init(content: String, authorID: User.ID) {
        
        self.content = content
        self.authorID = authorID
    }
}

extension Post {
    var author: Parent<Post, User> {
        return parent(\.authorID)
    }
}

extension Post: SQLiteModel {}
extension Post: Migration {}
extension Post: Parameter {}


