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

extension Workout {
    class Comment: ObservableObject, Codable, Identifiable {
        let id: String
        let userID: String
        let workoutID: String
        var comment: String
        
        init(comment: String, workoutID: String) {
            self.id = UUID().uuidString
            self.userID = User.currentUser.id
            self.comment = comment
            self.workoutID = workoutID
        }
        
        func userPreview() -> UserPreview {UserPreview.getUserPreview(id: userID)}
        
        enum Key: String, CodingKey {
            case id, userID, comment, workoutID
        }
        
        // DECODABLE
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Key.self)
            
            id = try container.decode(String.self, forKey: .id)
            userID = try container.decode(String.self, forKey: .userID)
            workoutID = try container.decode(String.self, forKey: .workoutID)
            comment = try container.decode(String.self, forKey: .comment)
        }
        
        // ENCODABLE
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: Key.self)
            
            try container.encode(id, forKey: .id)
            try container.encode(userID, forKey: .userID)
            try container.encode(workoutID, forKey: .workoutID)
            try container.encode(comment, forKey: .comment)
        }
    }
}

class Workout: NSObject, Codable, ObservableObject, Identifiable {
    
    static let maxWorkoutVideoBytes: Int = Int.max
    
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
    
    @Published var creationErrorMessage: String? = nil
    
    @Published var commentsEnabled = true
    @Published var comments = [Comment]()
    
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
        guard let creatingVideoURL = creatingVideoURL else {
            creationErrorMessage = "Must record a video!"
            return
        }
        
        // TODO: Publish workout to backend
        HTTPRequester.publishWorkout(workout: self)
        HTTPRequester.publishVideo(id: id, fromURL: creatingVideoURL)
        User.currentUser.publishedWorkoutIDs.append(id)
        Workout.workoutCache[id] = self
        keepFitAppController.currentView = .mainView
    }
    
    
    func videoURL() -> URL {WorkoutVideoStore.getVideoURL(id: id)}
    
    func publishAndCacheVideo(url: URL) {
        HTTPRequester.publishVideo(id: id, fromURL: url)
        WorkoutVideoStore.addToStore(id: id, url: url)
        User.currentUser.publishedWorkoutIDs.append(id)
    }
    
    func matches(keyword: String) -> Bool {
        let lc = keyword.lowercased()
        return creator().username.lowercased().contains(lc) ||
            title.lowercased().contains(lc)
    }
    
    func add(commentString: String) {
        let comment = Comment(comment: commentString, workoutID: id)
        self.comments.append(comment)
        HTTPRequester.publishComment(comment: comment)
    }
    
    enum Key: String, CodingKey {
        case id, creatorID
        case createdDate
        case title, caption, category
        case comments, commentsEnabled
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
        
        comments = try container.decode([Comment].self, forKey: .comments)
        commentsEnabled = try container.decode(Bool.self, forKey: .commentsEnabled)
        
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
        
        try container.encode(commentsEnabled, forKey: .commentsEnabled)
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

class WorkoutSession: ObservableObject, Codable, Identifiable, Equatable {
    
    static func ==(lhs: WorkoutSession, rhs: WorkoutSession) -> Bool {lhs.id == rhs.id}
    
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
    func workout() -> Workout {Workout.getWorkout(id: workoutID)}
    
    // the user who completed the workout
    var userID = User.currentUser.id
    func user() -> UserPreview {UserPreview.getUserPreview(id: userID)}
    
    @Published var startTime = Date()
    @Published var endTime = Date()
    
    @Published var caloriesBurned = 0.0
    @Published var caloriesError: String? = nil
    
    @Published var isDeleted = false
    
    func workoutCompleted() -> Bool {endTime != startTime}
    
    func completeWorkoutSession() {
        
        if caloriesBurned == 0.0 {
            caloriesError = "Record how many calories you burned!"
            return
        }
        
        endTime = Date()
        
        User.currentUser.completeWorkoutSession(session: self)
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
        caloriesBurned = try container.decode(Double.self, forKey: .caloriesBurned)
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
