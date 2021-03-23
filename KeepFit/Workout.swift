//
//  Workout.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/20/21.
//

import Foundation
import AVKit

enum WorkoutCategory: String, CaseIterable {
    case HIIT, Yoga, Aerobics, Bodyweight, Cardio, Strength
}

class Workout: NSObject, Codable, ObservableObject, Identifiable {
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
    func creator() -> UserPreview {
        return UserPreview.getUserPreview(id: creatorID)
    }
    
    var createdDate = Date()
    
    @Published var title = ""
    @Published var caption = ""
    
    @Published var category = WorkoutCategory.HIIT
    
    @Published var beenPublished = false
    
    // the video URL while we are in the progress of creating this thing
    @Published var creatingVideoURL: URL? = nil
    
    @Published var recordingVideo = false
    
    @Published var videoLiked = false
    
    func likeVideo() {
        HTTPRequester.likeWorkout(id: id)
        User.currentUser.likedWorkoutIDs.append(self.id)
        videoLiked = true
    }
    
    func unlikeVideo() {
        HTTPRequester.unlikeWorkout(id: id)
        User.currentUser.likedWorkoutIDs.removeAll(where: {$0 == self.id})
        videoLiked = false
    }
    
    func attemptToPublishWorkout() {
        // check if URL != nil
        // if so, set error message
        // TODO: Make Error Message Alert in CreateWorkoutView
        
        // TODO: Publish workout to backend
        // TODO:
    }
    
    
    func videoURL() -> URL {WorkoutVideoStore.getVideoURL(id: id)}
    
    func publishAndCacheVideo(url: URL) {
        HTTPRequester.publishVideo(id: id, fromURL: url)
        WorkoutVideoStore.addToStore(id: id, url: url)
    }
    
    enum Key: String, CodingKey {
        case id, creatorID
        case createdDate
        case title, caption, category
    }
    
    // DECODABLE
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: Key.self)
        
        id = try container.decode(String.self, forKey: .id)
        creatorID = try container.decode(String.self, forKey: .creatorID)
        
        let createdDateDouble = try container.decode(Double.self, forKey: .createdDate)
        createdDate = Date(timeIntervalSince1970: createdDateDouble)
        
        title = try container.decode(String.self, forKey: .title)
        caption = try container.decode(String.self, forKey: .caption)
        let categoryString = try container.decode(String.self, forKey: .category)
        category = WorkoutCategory(rawValue: categoryString)!
        
        // custom
        beenPublished = true
        videoLiked = User.currentUser.likedWorkoutIDs.contains(id)
    }
    
    // ENCODABLE
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(creatorID, forKey: .creatorID)
        
        try container.encode(createdDate.timeIntervalSince1970, forKey: .createdDate)
        
        try container.encode(title, forKey: .title)
        try container.encode(caption, forKey: .caption)
        try container.encode(category.rawValue, forKey: .category)
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
    
    var id = UUID().uuidString
    
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
        caloriesBurned = 3*5*7 + Int.random(in: 0..<10)
        endTime = Date()
        
        // TODO: Post to server
        HTTPRequester.publishWorkoutSession(session: self)
    }
    
    enum Key: String, CodingKey {
        case id, workoutID, userID
        case startTime, endTime, caloriesBurned
    }
    
    // DECODABLE
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        id = try container.decode(String.self, forKey: .id)
        workoutID = try container.decode(String.self, forKey: .workoutID)
        userID = try container.decode(String.self, forKey: .userID)
        
        startTime = Date(timeIntervalSince1970: try container.decode(Double.self, forKey: .startTime))
        endTime = Date(timeIntervalSince1970: try container.decode(Double.self, forKey: .endTime))
        caloriesBurned = try container.decode(Int.self, forKey: .caloriesBurned)
    }
    
    // ENCODABLE
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(workoutID, forKey: .workoutID)
        try container.encode(userID, forKey: .userID)
        
        try container.encode(startTime.timeIntervalSince1970, forKey: .startTime)
        try container.encode(endTime.timeIntervalSince1970, forKey: .endTime)
        try container.encode(caloriesBurned, forKey: .caloriesBurned)
    }
}
