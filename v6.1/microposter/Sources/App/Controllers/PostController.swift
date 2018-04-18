//
//  PostController.swift
//  App
//
//  Created by Johann Kerr on 3/6/18.
//

import Foundation
import Vapor
import Fluent
import Authentication
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
        postRouter.get(Post.parameter, "author", use: showAuthor)
        
        
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let tokenGroup = postRouter.grouped(tokenAuthMiddleware)
        
        tokenGroup.post("/", use: authPostCreate)
        // posts/:id/author
//        postRouter.get("/search", use: search)
        // Create Read Update Destroy
    }
    
    
    func authPostCreate(_ req: Request) throws -> Future<Post> {
        // { content: "auth isnt so hard" }
        let post = try req.content.decode(PostData.self).await(on: req)
        let user = try req.requireAuthenticated(User.self)
        let savedPost = Post(content: post.content, authorID: user.id!)
        
        return savedPost.save(on: req)
    }
    
    
    func index(_ req:Request) throws -> Future<[Post]> {
        return Post.query(on: req).all()
    }
    
    
    func create(_ req: Request) throws -> Future<Post> {
        /*
         { content: "hello world", authorID: 1 }
 
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
            post.authorID = updatedPost.authorID
            
            return post.save(on: req)
            
        }
    }
    
    func showAuthor(_ req: Request) throws -> Future<User> {
        return try req.parameter(Post.self).flatMap(to: User.self) { post in
            return post.author.get(on: req)
        }
    }
    
    /// /posts/search?author=Johann
    
//    
//    func search(_ req: Request) throws -> Future<[Post]> {
//        guard let searchItem = req.query[String.self, at: "author"] else {
//            throw Abort(.badRequest)
//        }
//        
//        return Post.query(on: req).filter(\.author == searchItem).all()
//        
//    }
    
}
