//
//  UserController.swift
//  App
//
//  Created by Johann Kerr on 3/12/18.
//

import Foundation
import Vapor
import Fluent

final class UserController : RouteCollection {
    func boot(router: Router) throws {
        // GET /posts
        // POST /posts
        
        let usersRouter = router.grouped("users")
        usersRouter.get("/",use: index)
        usersRouter.post("/", use: create)
        usersRouter.get(User.parameter, use: show)
        usersRouter.get(User.parameter, "posts", use: showPosts)
        // users/:id/posts
    }
    
    
    func index(_ req:Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }
    
    
    func create(_ req: Request) throws -> Future<User> {
        /*
         { username: "johann" }
         
         */
        let user = try req.content.decode(User.self).await(on: req)
        return user.save(on: req)
        
    }
    
    
    /// GET /posts/:id
    
    func show(_ req: Request) throws -> Future<User> {
        return try req.parameter(User.self)
    }
    
    
    func showPosts(_ req: Request) throws -> Future<[Post]> {
        return try req.parameter(User.self).flatMap(to: [Post].self) { user in
            return try user.posts.query(on: req).all()
            
        }
    }
    
    
    
}

