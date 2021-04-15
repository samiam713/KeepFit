//
//  SearchHTTPRequester.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/20/21.
//

import Foundation

extension HTTPRequester {
    
    struct StoreSearch: Encodable {
        let id = UUID().uuidString
        let userID: String
        let keyword: String
        let date: Double
    }
    
    static func storeSearch(userID: String, keyword: String, date: Double) {
        let completionGroup = DispatchGroup()
        completionGroup.enter()
        
        //Create the request
        // TODO: update path
        var request = URLRequest(url: getURL(path: "storeSearch/"))
        print(request.url!.absoluteString)
        
        // Construct the request
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! encoder.encode(StoreSearch(userID: userID, keyword: keyword, date: date))
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
    
    // perhaps these should be an [String]
    static func searchWorkouts(prefix: String) -> [Workout] {
        let completionGroup = DispatchGroup()
        completionGroup.enter()
        
        //Create the request
        // TODO: update path
        var request = URLRequest(url: getURL(path: "searchWorkouts/"))
        print(request.url!.absoluteString)
        
        var workouts = [Workout]()
        
        // Construct the request
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! encoder.encode(prefix)
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
            
            guard let _workouts = try? decoder.decode([Workout].self, from: data) else {
                fatalError("Bad JSON")
            }
            
            workouts = _workouts
            
            completionGroup.leave()
        }
        
        dataTask.resume()
        
        completionGroup.wait()
        
        return workouts
    }
    
    static func searchUsers(prefix: String) -> [UserPreview] {
        let completionGroup = DispatchGroup()
        completionGroup.enter()
        
        //Create the request
        // TODO: update path
        var request = URLRequest(url: getURL(path: "searchUsers/"))
        print(request.url!.absoluteString)
        
        var users = [UserPreview]()
        
        // Construct the request
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! encoder.encode(prefix)
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
            
            guard let _users = try? decoder.decode([UserPreview].self, from: data) else {
                fatalError("Bad JSON")
            }
            
            users = _users
            
            completionGroup.leave()
        }
        
        dataTask.resume()
        
        completionGroup.wait()
        
        return users
    }
    
    static func getWorkoutsOfCategory(category: WorkoutCategory) -> [Workout] {
        
        let completionGroup = DispatchGroup()
        completionGroup.enter()
        
        //Create the request
        // TODO: update path
        var request = URLRequest(url: getURL(path: "searchCategories/"))
        print(request.url!.absoluteString)
        
        var workouts = [Workout]()
        
        // Construct the request
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! encoder.encode(category.rawValue)
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
            
            guard let _workouts = try? decoder.decode([Workout].self, from: data) else {
                fatalError("Bad JSON")
            }
            
            workouts = _workouts
            
            completionGroup.leave()
        }
        
        dataTask.resume()
        
        completionGroup.wait()
        
        return workouts
    }
}
