//
//  UserHTTPRequester.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/19/21.
//

import Foundation

extension HTTPRequester {
    static func getUserPreview(id: String) -> UserPreview {
        fatalError()
    }
    
    // returns true iff registered user
    // returns false iff username in use
    static func registerUser(user: User) -> Bool {
        // TODO: SERVER LOGIC
        return true
    }
    
    static func updateUser(user: User) {
        // TODO: SERVER LOGIC
        
    }
    
    enum LoginResult {case success(User), badPassword, badUsername}
    static func attemptLogin(username: String, password: String) -> LoginResult {
        // TODO: SERVER LOGIC
        return .success(User())
    }
    
    static func followUser(otherID: String) {
        let myID = User.currentUser.id
        // TODO: SERVER LOGIC
    }
    
}
