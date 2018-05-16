//
//  UserController.swift
//  App
//
//  Created by Johann Kerr on 3/12/18.
//

import Foundation
import Vapor
import Fluent
import Authentication

final class UserController : RouteCollection {
    func boot(router: Router) throws {
        // GET /posts
        // POST /posts
        
        let usersRouter = router.grouped("users")
        usersRouter.get("/",use: index)
        usersRouter.post("/", use: create)
        usersRouter.get(User.PublicUser.parameter, use: show)
        usersRouter.get(User.PublicUser.parameter, "posts", use: showPosts)
        
        let basicAuthMiddleware = User.basicAuthMiddleware(using: BCryptVerifier())
        let authGroup = usersRouter.grouped(basicAuthMiddleware)
        authGroup.post("login", use: loginHandler)
        
        
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let tokenGroup = usersRouter.grouped(tokenAuthMiddleware)
        tokenGroup.get("posts", use: handleUserPosts)
        // users/:id/posts
    }
    
    
    
    func handleUserPosts(_ req: Request) throws -> Future<[Post]> {
        let user = try req.requireAuthenticated(User.self)
        return try user.posts.query(on: req).all()
    }
    
    func loginHandler(_ req: Request) throws -> Future<Token> {
        let user = try req.requireAuthenticated(User.self)
        let token = try Token(user)
        return token.save(on: req)
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

