//
//  Workout.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/20/21.
//

import Foundation
import AVKit

enum WorkoutCategory: String, CaseIterable {
    case HIIT, Yoga, Aerobics, Bodyweight
}

class Workout: NSObject, Codable, ObservableObject {
    static var workoutCache = [String:Workout]()

    static func getWorkout(id: String) -> Workout {

        if let workout = Self.workoutCache[id] {
            return workout
        }

        let workout = HTTPRequester.getWorkout(id: id)

        Self.workoutCache[id] = workout

        return workout
    }
    
    override init() {super.init()}
    
    var id = UUID().uuidString
    
    // the creator of the workout
    var creatorID = User.currentUser.id
    
    let createdDate = Date()
    
    @Published var title = ""
    @Published var caption = ""
    
    @Published var category = WorkoutCategory.HIIT
    
    @Published var beenPublished = false
    
    // the video URL while we are in the progress of creating this thing
    @Published var creatingVideoURL: URL? = nil
    
    @Published var recordingVideo = false
    
    func attemptToPublishWorkout() {
        // check if URL != nil
        // if so, set error message
        
        // TODO: Make Error Message Alert in CreateWorkoutView
    }
    
    func videoURL() -> URL {WorkoutVideoStore.getVideoURL(id: id)}
    
    func publishAndCacheVideo(url: URL) {
        HTTPRequester.publishVideo(id: id, fromURL: url)
        WorkoutVideoStore.addToStore(id: id, url: url)
    }
    
    // DECODABLE
    required init(from decoder: Decoder) throws {
        fatalError()
    }
    
    // ENCODABLE
    func encode(to encoder: Encoder) throws {
        fatalError()
    }
}


class WorkoutVideoStore {
    static var videoPathCache = [String:URL]()
    
    static func getVideoURL(id: String) -> URL {
        if let url = Self.videoPathCache[id] {
            return url
        }
        
        let url = HTTPRequester.downloadVideoToURL(workoutID: id)
        
        Self.videoPathCache[id] = url
        
        return url
    }
    
    static func addToStore(id: String, url: URL) {
        Self.videoPathCache[id] = url
    }
}

class WorkoutSession: ObservableObject, Codable {
    
    init(workoutID: String) {
        self.workoutID = workoutID
    }
    
    static var workoutSessionCache = [String:WorkoutSession]()

    static func getWorkoutSession(id: String) -> WorkoutSession {

        if let workoutSession = Self.workoutSessionCache[id] {
            return workoutSession
        }

        let workoutSession = HTTPRequester.getWorkoutSession(id: id)

        Self.workoutSessionCache[id] = workoutSession

        return workoutSession
    }
    
    let id = UUID().uuidString
    
    // the workout id this WorkoutSession references
    var workoutID: String
    
    // the user who completed the workout
    var userID = User.currentUser.id
    
    @Published var startTime = Date()
    @Published var endTime = Date()
    
    @Published var caloriesBurned = 0
    
    func workoutCompleted() -> Bool {caloriesBurned != 0}
    
    func completeWorkout() {
        // TODO: calculate calories burned
        caloriesBurned = 100
        endTime = Date()
        
        // TODO: Post to server
        HTTPRequester.publishWorkoutSession(session: self)
    }
    
    // DECODABLE
    required init(from decoder: Decoder) throws {
        fatalError()
    }
    
    // ENCODABLE
    func encode(to encoder: Encoder) throws {
        fatalError()
    }
}

