//
//  UserHTTPRequester.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/19/21.
//

import Foundation

extension HTTPRequester {
    
//    static func getUserPreview(id: String, callback: @escaping (UserPreview) -> ()) {
//        keepFitAppController.networkRequests += 1
//        DispatchQueue.global(qos: .userInitiated).async {
//
//            let userPreview = _getUserPreview(id: id)
//
//            DispatchQueue.main.async {
//                callback(userPreview)
//                keepFitAppController.networkRequests -= 1
//            }
//        }
//    }
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
    
    struct ResetPassword: Codable {
        let id: String
        let oldPassword: String
        let newPassword: String
    }
    
    static func resetPassword(oldPassword: String, newPassword: String, callback: @escaping (Bool) -> ()) {
        keepFitAppController.networkRequests += 1
        DispatchQueue.global(qos: .userInitiated).async {
            
            let passwordReset = _resetPassword(oldPassword: oldPassword, newPassword: newPassword)
            
            DispatchQueue.main.async {
                callback(passwordReset)
                keepFitAppController.networkRequests -= 1
            }
        }
    }
    static func _resetPassword(oldPassword: String, newPassword: String) -> Bool {
        let completionGroup = DispatchGroup()
        completionGroup.enter()
        
        var succeeded = false
        
        //Create the request
        var request = URLRequest(url: getURL(path: "resetPassword/"))
//        print(request.url!.absoluteString)
        
        // Construct the request
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let resetPassword = ResetPassword(id: User.currentUser.id, oldPassword: oldPassword, newPassword: newPassword)
        request.httpBody = try! encoder.encode(resetPassword)
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
                        
            guard let _succeeded = try? decoder.decode(Bool.self, from: data) else {
                fatalError("NOT A VALID USER JSON")
            }
            
            succeeded = _succeeded
            completionGroup.leave()
        }
        
        dataTask.resume()
        
        completionGroup.wait()
        return succeeded
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
        
//        let user = User()
//        user.userRegistered = true
//        user.username = username
//        return .success(user)
        
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
            
            guard data != "badpassword".data(using: .utf8) else {
                loginResult = LoginResult.badPassword
                completionGroup.leave()
                return
            }
            
            guard data != "badusername".data(using: .utf8) else {
                loginResult = LoginResult.badUsername
                completionGroup.leave()
                return
            }
            
            guard let user = try? decoder.decode(User.self, from: data) else {
                // print(String(data: data, encoding: .utf8)!)
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
    
    struct UnfollowUser: Encodable {
        let followerID: String
        let followingID: String
    }
    static func unfollowUser(otherID: String) {
        let myID = User.currentUser.id
        
        let completionGroup = DispatchGroup()
        completionGroup.enter()
        
        //Create the request
        var request = URLRequest(url: getURL(path: "unfollow/"))
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
    
    static func deleteWorkoutSession(workoutSessionID: String)  {
        
        let completionGroup = DispatchGroup()
        completionGroup.enter()
        
        //Create the request
        var request = URLRequest(url: getURL(path: "deleteWorkoutSession/"))
        print(request.url!.absoluteString)
        
        // Construct the request
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! encoder.encode(workoutSessionID)
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
    
    static func deleteWorkout(workoutID: String)  {
        
        let completionGroup = DispatchGroup()
        completionGroup.enter()
        
        //Create the request
        var request = URLRequest(url: getURL(path: "deleteWorkout/"))
        print(request.url!.absoluteString)
        
        // Construct the request
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! encoder.encode(workoutID)
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
