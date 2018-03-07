//
//  PostController.swift
//  App
//
//  Created by Johann Kerr on 3/6/18.
//

import Foundation
import Vapor

final class PostController : RouteCollection {
    func boot(router: Router) throws {
        // GET /posts
        // POST /posts
        
        let postRouter = router.grouped("posts")
        postRouter.get("/",use: index)
        postRouter.post("/", use: create)
    }
    
    
    func index(_ req:Request) throws -> Future<[Post]> {
        return Post.query(on: req).all()
    }
    
    
    func create(_ req: Request) throws -> Future<Post> {
        /*
         { content: "hello world", author: "johann" }
 
        */
        let post = try req.content.decode(Post.self).await(on: req)
        return post.save(on: req)
        
    }
}
