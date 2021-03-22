//
//  WorkoutHTTPRequester.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/20/21.
//

import Foundation

extension HTTPRequester {
    static func getWorkout(id: String) -> Workout {
        // TODO: SERVER LOGIC
        fatalError()
    }
    
    static func publishWorkout(workout: Workout) {
        // TODO: SERVER LOGIC
        fatalError()
    }
    
    static func likeWorkout(id: String) {
        let myID = User.currentUser.id
        // TODO: SERVER LOGIC
        fatalError()
    }
    
    static func getWorkoutSession(id: String) -> WorkoutSession {
        // TODO: SERVER LOGIC
        fatalError()
    }
    
    static func publishWorkoutSession(session: WorkoutSession) {
        // TODO: SERVER LOGIC
        fatalError()
    }
    
    static func downloadVideoToURL(workoutID: String) -> URL {
        // TODO: SERVER LOGIC
        
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(workoutID, isDirectory: false).appendingPathExtension("MOV")
        let videoData = Data()
        try! videoData.write(to: url)
        return url
    }
    
    static func publishVideo(id: String, fromURL: URL) {
        // TODO: SERVER LOGIC
        fatalError()
    }
}
