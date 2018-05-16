//
//  Post.swift
//  App
//
//  Created by Johann Kerr on 2/27/18.
//

import Foundation
import Vapor

final class Post: Content {
    var content: String
    var author: String
    
    
    init(content: String, author: String) {
        
        self.content = content
        self.author = author
    }
}
