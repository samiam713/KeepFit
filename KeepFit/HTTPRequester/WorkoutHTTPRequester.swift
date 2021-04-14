//
//  WorkoutHTTPRequester.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/20/21.
//

import Foundation

extension HTTPRequester {
    
    static func get10MostLikedWorkouts() -> [String] {
        let completionGroup = DispatchGroup()
        completionGroup.enter()
        
        var workoutIDs: [String]? = nil
        
        //Create the request
        // TODO: update path
        var request = URLRequest(url: getURL(path: "get10MostLikedWorkouts/"))
        print(request.url!.absoluteString)
        
        // Construct the request
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
                        
            guard let _workoutIDs = try? decoder.decode([String].self, from: data) else {
                fatalError("NOT A VALID USER JSON")
            }
            
            workoutIDs = _workoutIDs
            completionGroup.leave()
        }
        
        dataTask.resume()
        
        completionGroup.wait()
        return workoutIDs!
    }
    
    static func getWorkout(id: String) -> Workout {
        let completionGroup = DispatchGroup()
        completionGroup.enter()
        
        var workout: Workout? = nil
        
        //Create the request
        // TODO: update path
        var request = URLRequest(url: getURL(path: "getWorkout/"))
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
                        
            guard let _workout = try? decoder.decode(Workout.self, from: data) else {
                fatalError("NOT A VALID USER JSON")
            }
            
            workout = _workout
            completionGroup.leave()
        }
        
        dataTask.resume()
        
        completionGroup.wait()
        return workout!
    }
    
    static func publishWorkout(workout: Workout) {
        let completionGroup = DispatchGroup()
        completionGroup.enter()
        
        //Create the request
        // TODO: update path
        var request = URLRequest(url: getURL(path: "publishWorkout/"))
        print(request.url!.absoluteString)
        
        // Construct the request
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! encoder.encode(workout)
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
    
    struct LikeWorkout: Codable {
        let userID: String
        let workoutID: String
    }
    static func likeWorkout(id: String) {
        let myID = User.currentUser.id
        
        let completionGroup = DispatchGroup()
        completionGroup.enter()
        
        //Create the request
        // TODO: update path
        var request = URLRequest(url: getURL(path: "likeWorkout/"))
        print(request.url!.absoluteString)
        
        // Construct the request
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! encoder.encode(LikeWorkout(userID: myID, workoutID: id))
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
    
    static func unlikeWorkout(id: String) {
        let myID = User.currentUser.id
        
        let completionGroup = DispatchGroup()
        completionGroup.enter()
        
        //Create the request
        // TODO: update path
        var request = URLRequest(url: getURL(path: "unlikeWorkout/"))
        print(request.url!.absoluteString)
        
        // Construct the request
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! encoder.encode(LikeWorkout(userID: myID, workoutID: id))
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
    
    static func getWorkoutSession(id: String) -> WorkoutSession {
        // TODO: SERVER LOGIC
        let completionGroup = DispatchGroup()
        completionGroup.enter()
        
        var workoutSession: WorkoutSession? = nil
        
        //Create the request
        // TODO: update path
        var request = URLRequest(url: getURL(path: "getWorkoutSession/"))
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
                        
            guard let _workoutSession = try? decoder.decode(WorkoutSession.self, from: data) else {
                fatalError("NOT A VALID USER JSON")
            }
            
            workoutSession = _workoutSession
            completionGroup.leave()
        }
        
        dataTask.resume()
        
        completionGroup.wait()
        return workoutSession!
    }
    
    static func publishWorkoutSession(session: WorkoutSession) {
        let completionGroup = DispatchGroup()
        completionGroup.enter()
        
        //Create the request
        // TODO: update path
        var request = URLRequest(url: getURL(path: "completeWorkout/"))
        print(request.url!.absoluteString)
        
        // Construct the request
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! encoder.encode(session)
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
    
    static func downloadVideoToURL(workoutID: String) -> URL {
        let completionGroup = DispatchGroup()
        completionGroup.enter()
        
        //Create the request
        // TODO: update path
        var request = URLRequest(url: getURL(path: "downloadVideo/"))
        print(request.url!.absoluteString)
        
        var videoData = Data()
        
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
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode), let data = data else {
                fatalError("Not a valid response")
            }
            
            videoData = Data(base64Encoded: data)!
            
            completionGroup.leave()
        }
        
        dataTask.resume()
        
        completionGroup.wait()
        
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(workoutID, isDirectory: false).appendingPathExtension("MOV")
        try! videoData.write(to: url)
        return url
    }
    
    struct PostVideo: Codable {
        let workoutID: String
        let videoData: String
    }
    static func publishVideo(id: String, fromURL: URL) {
        let completionGroup = DispatchGroup()
        completionGroup.enter()
        
        //Create the request
        // TODO: update path
        var request = URLRequest(url: getURL(path: "uploadVideo/"))
        print(request.url!.absoluteString)
        
        // Construct the request
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let videoData = try! Data(contentsOf: fromURL)
        request.httpBody = try! encoder.encode(PostVideo(workoutID: id, videoData: videoData.base64EncodedString()))
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
    
    static func publishWorkoutPlan(plan: WorkoutPlan) {
        let completionGroup = DispatchGroup()
        completionGroup.enter()
        
        //Create the request
        // TODO: update path
        var request = URLRequest(url: getURL(path: "publishWorkoutPlan/"))
        print(request.url!.absoluteString)
        
        // Construct the request
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! encoder.encode(plan)
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
    
    static func deleteWorkoutPlan(id: String) {
        let completionGroup = DispatchGroup()
        completionGroup.enter()
        
        //Create the request
        // TODO: update path
        var request = URLRequest(url: getURL(path: "deleteWorkoutPlan/"))
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
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode), let _ = data else {
                fatalError("Not a valid response")
            }
            completionGroup.leave()
        }
        
        dataTask.resume()
        
        completionGroup.wait()
    }
}
