//
//  UserHTTPRequester.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/19/21.
//

import Foundation

extension HTTPRequester {
    static func getUserPreview(id: String) -> UserPreview {

        
        let completionGroup = DispatchGroup()
        completionGroup.enter()
        
        var userPreviewResult: UserPreview? = nil
        
        //Create the request
        var request = URLRequest(url: getURL(path: "getUserPreview/"))
        print(request.url!.absoluteString)
        
        // Construct the request
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! encoder.encode(id)
        request.timeoutInterval = 10
        
        //Create a URL Session
        
        let dataTask = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            
            //ensure the response status is 200 OK and that there is data
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode), let data = data else {
                fatalError("Not a valid response")
            }
                        
            guard let userPreview = try? decoder.decode(UserPreview.self, from: data) else {
                fatalError("NOT A VALID USER JSON")
            }
            
            userPreviewResult = userPreview
            completionGroup.leave()
        }
        
        dataTask.resume()
        
        completionGroup.wait()
        return userPreviewResult!
    }
    
    // returns true iff registered user
    // returns false iff username in use
    static func registerUser(user: User) -> Bool {
        
        let completionGroup = DispatchGroup()
        completionGroup.enter()
        
        var registered = false
        
        //Create the request
        var request = URLRequest(url: getURL(path: "register/"))
        print(request.url!.absoluteString)
        
        // Construct the request
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! encoder.encode(user)
        request.timeoutInterval = 10
        
        //Create a URL Session
        
        let dataTask = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            
            //ensure the response status is 200 OK and that there is data
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {fatalError()}
            
            guard let data = data else {
                fatalError("Not a valid response")
            }
  
            
            guard let _registered = try? decoder.decode(Bool.self, from: data) else {
                fatalError("Not valid boolean JSON")
            }
            
           registered = _registered
            completionGroup.leave()
        }
        
        dataTask.resume()
        
        completionGroup.wait()
        return registered
    }
    
    static func updateUser(user: User) {
        
        let completionGroup = DispatchGroup()
        completionGroup.enter()
        
        //Create the request
        var request = URLRequest(url: getURL(path: "update/"))
        print(request.url!.absoluteString)
        
        // Construct the request
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! encoder.encode(user)
        request.timeoutInterval = 10
        
        //Create a URL Session
        
        let dataTask = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            
            //ensure the response status is 200 OK and that there is data
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode), let _ = data else {
                fatalError("Not a valid response")
            }
  
            completionGroup.leave()
        }
        
        dataTask.resume()
        
        completionGroup.wait()
    }
    
    struct LoginData: Codable {
        let username: String
        let password: String
    }
    enum LoginResult {case success(User), badPassword, badUsername}
    static func attemptLogin(username: String, password: String) -> LoginResult {
        
        let user = User()
        user.userRegistered = true
        return .success(user)
        
        let completionGroup = DispatchGroup()
        completionGroup.enter()
        
        var loginResult: LoginResult? = nil
        
        //Create the request
        var request = URLRequest(url: getURL(path: "login/"))
        print(request.url!.absoluteString)
        
        // Construct the request
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! encoder.encode(LoginData(username: username, password: password))
        request.timeoutInterval = 10
        
        //Create a URL Session
        
        let dataTask = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            
            //ensure the response status is 200 OK and that there is data
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode), let data = data else {
                fatalError("Not a valid response")
            }
            
            guard data != "BADPASSWORD".data(using: .utf8) else {
                loginResult = LoginResult.badPassword
                return
            }
            
            guard data != "BADUSERNAME".data(using: .utf8) else {
                loginResult = LoginResult.badUsername
                return
            }
            
            guard let user = try? decoder.decode(User.self, from: data) else {
                fatalError("NOT A VALID USER JSON")
            }
            
            loginResult = LoginResult.success(user)
            completionGroup.leave()
        }
        
        dataTask.resume()
        
        completionGroup.wait()
        return loginResult!
    }
    
    struct FollowUser: Encodable {
        let followerID: String
        let followingID: String
    }
    static func followUser(otherID: String) {
        let myID = User.currentUser.id
        
        let completionGroup = DispatchGroup()
        completionGroup.enter()
        
        //Create the request
        var request = URLRequest(url: getURL(path: "follow/"))
        print(request.url!.absoluteString)
        
        // Construct the request
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! encoder.encode(FollowUser(followerID: myID, followingID: otherID))
        request.timeoutInterval = 10
        
        //Create a URL Session
        
        let dataTask = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            
            //ensure the response status is 200 OK and that there is data
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode), let _ = data else {
                fatalError("Not a valid response")
            }
            
            completionGroup.leave()
        }
        
        dataTask.resume()
        
        completionGroup.wait()
    }
    
}
