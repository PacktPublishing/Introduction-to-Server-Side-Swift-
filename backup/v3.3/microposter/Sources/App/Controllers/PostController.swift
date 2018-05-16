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
        postRouter.get(Post.parameter, use: show)
        postRouter.delete(Post.parameter, use: destroy)
        postRouter.patch(Post.parameter, use: update)
        // Create Read Update Destroy
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
    
    
    /// GET /posts/:id
    
    func show(_ req: Request) throws -> Future<Post> {
        return try req.parameter(Post.self)
    }
    
    /// DELETE /posts/:id
    
    
    func destroy(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameter(Post.self).flatMap(to: HTTPStatus.self) { post in
            return post.delete(on: req).transform(to: .noContent)
            
        }
    }
    
    /// PATCH /posts/:id
    /// { content: "hello from vapor 3!!", author: "johann" }
    func update(_ req: Request) throws -> Future<Post> {
        return try flatMap(to: Post.self, req.parameter(Post.self), req.content.decode(Post.self)) { post, updatedPost in
            
            post.content = updatedPost.content
            post.author = updatedPost.author
            
            return post.save(on: req)
            
        }
    }
    
}
