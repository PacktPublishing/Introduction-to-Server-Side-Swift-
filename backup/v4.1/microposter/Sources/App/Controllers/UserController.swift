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
        usersRouter.get(User.PublicUser.parameter, use: show)
        usersRouter.get(User.PublicUser.parameter, "posts", use: showPosts)
        // users/:id/posts
    }
    
    
    func index(_ req:Request) throws -> Future<[User.PublicUser]> {
        return User.PublicUser.query(on: req).all()
    }
    
    
    func create(_ req: Request) throws -> Future<User.PublicUser> {
        /*
         { username: "johann", "password": "ilovevapor" }
         
         */
        return try req.content.decode(User.self).flatMap(to: User.PublicUser.self) { user in
            
            let hasher = try req.make(BCryptHasher.self)
            user.password = try hasher.make(user.password)
            user.save(on: req)
            let publicUser = User.PublicUser(user: user)
            
            return Future(publicUser)
            
            
            
        }
        
    }
    
    
    /// GET /posts/:id
    
    func show(_ req: Request) throws -> Future<User.PublicUser> {
        return try req.parameter(User.PublicUser.self)
    }
    
    
    func showPosts(_ req: Request) throws -> Future<[Post]> {
        return try req.parameter(User.self).flatMap(to: [Post].self) { user in
            return try user.posts.query(on: req).all()
            
        }
    }
    
    
    
}

