//
//  Post.swift
//  App
//
//  Created by Johann Kerr on 2/27/18.
//

import Foundation
import Vapor
import FluentMySQL




final class Post: Content {
    var content: String
    var authorID: User.ID
    var id: Int?
    
    
    init(content: String, authorID: User.ID) {
        
        self.content = content
        self.authorID = authorID
    }
}


struct PostData: Content {
    var content: String
}

extension Post {
    var author: Parent<Post, User> {
        return parent(\.authorID)
    }
}

extension Post: MySQLModel {}
extension Post: Migration {}
extension Post: Parameter {}


