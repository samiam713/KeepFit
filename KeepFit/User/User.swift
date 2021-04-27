//
//  User.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/19/21.
//

import Foundation
import UIKit
import SwiftUI

enum Sex: String, CaseIterable {case Male, Female, Unspecified}

class User: NSObject, ObservableObject, Codable {
    
    static var currentUser = User()
    
    override init() {super.init()}
    
    var id = UUID().uuidString
    
    @Published var username = ""
    @Published var password = ""
    
    // Hi I'm Sam! I'm at USC and am a Junior! I joined fit because...
    @Published var shortBiography = ""
    
    @Published var sex = Sex.Unspecified
    
    @Published var birthdate = Date()
    
    @Published var inches = 68
    @Published var pounds = 160
    
    @Published var profilePicture = UIImage(named: "DefaultProfile")!
    
    @Published var followingIDs = [String]()
    
    @Published var sessionIDs = [String]()
    @Published var likedWorkoutIDs = [String]()
    @Published var publishedWorkoutIDs = [String]()
    @Published var workoutPlans = [WorkoutPlan]()
    
    let eventStore = EventStore()
    
    @Published var tenRecentSearches = [String]()
    
    @Published var following = [UserPreview]()
    func updateFollowing() {
        keepFitAppController.networkRequests += 1
        DispatchQueue.global(qos: .userInitiated).async {
            let following = self.followingIDs.map(UserPreview.getUserPreview(id:))
            DispatchQueue.main.async {
                self.following = following
                keepFitAppController.networkRequests -= 1
            }
        }
    }
    func sessions() -> [WorkoutSession] {sessionIDs.map(WorkoutSession.getWorkoutSession(id:))}
    func likedWorkouts() -> [Workout] {likedWorkoutIDs.map(Workout.getWorkout(id:))}
    func publishedWorkouts() -> [Workout] {publishedWorkoutIDs.map(Workout.getWorkout(id:))}
    
    @Published var usernameError = ""
    @Published var passwordError = ""
    @Published var changingSourceType: UIImagePickerController.SourceType? = nil
    
    @Published var userRegistered = false
    @Published var destroyingUser = false
    
    @Published var validationError = false
    func regUpdErrorString() -> String {"\(userRegistered ? "Update" : "Registration") Error"}
    
    // potentially keep track of when last update to server was
    // so when the users update their data, they can see that the last
    // update changed to now o'clock
    // @Published var lastUpdate = Date()
    
    func heightDescription() -> String {"Height: \(inches/12)' \(inches%12)\""}
    func weightDescription() -> String {"Weight: \(pounds) lbs"}
    
    func toUserPreview() -> UserPreview {
        UserPreview(id: id, username: username, shortBiography: shortBiography, profilePicture: profilePicture, sessionIDs: sessionIDs, likedWorkoutIDs: likedWorkoutIDs, publishedWorkoutIDs: publishedWorkoutIDs)
    }
    
    static func nearestPlanReducer(current: WorkoutPlan?, next: WorkoutPlan) -> WorkoutPlan? {
        guard let current = current else {return next}
        return current.date < next.date ? current : next
    }
    
    var nearestPlan: WorkoutPlan? {
        return workoutPlans.reduce(nil, Self.nearestPlanReducer(current:next:))
    }
    
    // returns true iff valid username/password
    // if not valid, adds helpful error messages
    func validateData() -> Bool {
        var successful = true
        
        // update username error
        if !(4...16).contains(username.count) {
            usernameError = "Username must be 4-16 characters long"
            successful = false
        } else {
            usernameError = ""
        }
        
        if !userRegistered || password != "" {
            if !(4...16).contains(password.count) {
                passwordError = "Password must be 4-16 characters long"
                successful = false
            }
            
            else if !password.allSatisfy({$0.isASCII}) {
                password = "Password must use ASCII characters"
                successful = false
            } else {
                passwordError = ""
            }
        }
        
        if !successful {validationError = true}
        return successful
    }
    
    func logout() {
        User.currentUser = User()
        keepFitAppController.currentView = .entry
    }
    
    func attemptToRegister() {
        guard validateData() else {return}
        userRegistered = HTTPRequester.registerUser(user: self)
        if userRegistered {
            keepFitAppController.currentView = .mainView
        } else {
            usernameError = "Username already in use"
            validationError = true
        }
    }
    
    func destroyUser() {
        HTTPRequester.deleteAccount(userID: id)
        User.currentUser = User()
        keepFitAppController.currentView = .entry
    }
    
    func attemptToUpdate() {
        guard validateData() else {return}
        HTTPRequester.updateUser(user: self)
        
    }
    
    func selectImage(sourceType: UIImagePickerController.SourceType) {
        self.changingSourceType = sourceType
    }
    
    func clearWorkoutSessions() {
        for workoutSession in sessions() {
            clearWorkoutSession(session: workoutSession)
        }
    }
    
    func completeWorkoutSession(session: WorkoutSession) {
        WorkoutSession.workoutSessionCache[session.id] = session
        HTTPRequester.publishWorkoutSession(session: session)
        eventStore.addSession(session: session)
        sessionIDs.append(session.id)
    }
    
    func clearWorkoutSession(session: WorkoutSession) {
        session.isDeleted = true
        HTTPRequester.deleteWorkoutSession(workoutSessionID: session.id)
        eventStore.removeSession(session: session)
        sessionIDs.removeAll(where: {$0 == session.id})
    }
    
    func deleteWorkout(id: String) {
        HTTPRequester.deleteWorkout(workoutID: id)
        publishedWorkoutIDs.removeAll(where: {$0 == id})
        likedWorkoutIDs.removeAll(where: {$0 == id})
        workoutPlans.removeAll() {(plan: WorkoutPlan) in plan.workoutID == id}
        sessionIDs.removeAll(where: {WorkoutSession.getWorkoutSession(id: $0).workoutID == id})
    }
    
    func addSearch(keyword: String) {
        tenRecentSearches.insert(keyword, at: 0)
        HTTPRequester.storeSearch(userID: id, keyword: keyword, date: Date().timeIntervalSince1970)
        // could be if instead of while... defensive programming
        while tenRecentSearches.count > 10 {_ = tenRecentSearches.popLast()}
    }
    
    func addPlan(workout: Workout, date: Date) -> Bool {
        
        guard !(DayComponents(date: date) < eventStore.today) else {return false}
        
        // create plan
        let workoutPlan = WorkoutPlan(workout: workout, date: date)
        
        // post to server
        HTTPRequester.publishWorkoutPlan(plan: workoutPlan)
        
        // add to list
        workoutPlans.append(workoutPlan)
        
        // add to eventstore
        eventStore.addPlan(plan: workoutPlan)
        
        return true
    }
    
    func deletePlan(plan: WorkoutPlan) {
        // remove from server
        HTTPRequester.deleteWorkoutPlan(id: plan.id)
        
        // remove from list
        workoutPlans.removeAll() {$0 == plan}
        
        // remove from eventstores
        eventStore.removePlan(plan: plan)
    }
    
    enum Key: String, CodingKey {
        case id, username, password
        case shortBiography, sex, inches, pounds, birthdate
        case profilePicture
        case tenRecentSearches
        case followingIDs, sessionIDs, likedWorkoutIDs, publishedWorkoutIDs, workoutPlans
    }
    
    required init(from decoder: Decoder) throws {
        
        super.init()
        
        let container = try decoder.container(keyedBy: Key.self)
        
        id = try container.decode(String.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        // password = try container.decode(String.self, forKey: .password)
        
        shortBiography = try container.decode(String.self, forKey: .shortBiography)
        let sexString = try container.decode(String.self, forKey: .sex)
        sex = Sex(rawValue: sexString)!
        inches = try container.decode(Int.self, forKey: .inches)
        pounds = Int(try container.decode(Double.self, forKey: .pounds))
        
        let profilePictureString = try container.decode(String.self, forKey: .profilePicture)
        let profilePictureData = Data(base64Encoded: profilePictureString)!
        profilePicture = UIImage(data: profilePictureData)!
        
        tenRecentSearches = try container.decode([String].self, forKey: .tenRecentSearches)
        
        followingIDs = try container.decode([String].self, forKey: .followingIDs)
        sessionIDs = try container.decode([String].self, forKey: .sessionIDs)
        likedWorkoutIDs = try container.decode([String].self, forKey: .likedWorkoutIDs)
        publishedWorkoutIDs = try container.decode([String].self, forKey: .publishedWorkoutIDs)
        let workoutPlans = try container.decode([WorkoutPlan].self, forKey: .workoutPlans)
        for workoutPlan in workoutPlans {
            if DayComponents(date: workoutPlan.date) < eventStore.today {
                HTTPRequester.deleteWorkoutPlan(id: workoutPlan.id)
            } else {
                self.workoutPlans.append(workoutPlan)
            }
        }
        
        birthdate = Date(timeIntervalSince1970: try container.decode(Double.self, forKey: .birthdate))
        
        // not from JSON
        self.userRegistered = true
        
        DispatchQueue.main.async {
            self.eventStore.populate(user: self)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(username, forKey: .username)
        try container.encode(password, forKey: .password)
        
        try container.encode(shortBiography, forKey: .shortBiography)
        try container.encode(sex.rawValue, forKey: .sex)
        try container.encode(inches, forKey: .inches)
        try container.encode(pounds, forKey: .pounds)
        try container.encode(birthdate.timeIntervalSince1970, forKey: .birthdate)
        
        try container.encode(profilePicture.pngData()!.base64EncodedString(), forKey: .profilePicture)
        // try container.encode("This is a stand in string. Normally this is a massive string encodeding the profile picture", forKey: .profilePicture)
        
        try container.encode(followingIDs, forKey: .followingIDs)
        try container.encode(sessionIDs, forKey: .sessionIDs)
        try container.encode(likedWorkoutIDs, forKey: .likedWorkoutIDs)
        try container.encode(publishedWorkoutIDs, forKey: .publishedWorkoutIDs)
    }
}

class UserPreview: Decodable, Identifiable {
    init(id: String, username: String, shortBiography: String, profilePicture: UIImage, sessionIDs: [String], likedWorkoutIDs: [String], publishedWorkoutIDs: [String]) {
        self.id = id
        self.username = username
        self.shortBiography = shortBiography
        self.profilePicture = profilePicture
        self.sessionIDs = sessionIDs
        self.likedWorkoutIDs = likedWorkoutIDs
        self.publishedWorkoutIDs = publishedWorkoutIDs
    }
    
//    init() {
//        id = "x"
//        username = "x"
//        shortBiography = "x"
//        profilePicture = UIImage(named: "LarryWheels")!
//        sessionIDs = []
//        likedWorkoutIDs = []
//        publishedWorkoutIDs = []
//    }
    static var userPreviewCache = [String:UserPreview]()
    
    // used for efficiency
    // we never download the same UserPreview twice
    static func getUserPreview(id: String) -> UserPreview {
        
        if id == User.currentUser.id {return User.currentUser.toUserPreview()}
        
        if let userPreview = Self.userPreviewCache[id] {
            return userPreview
        }
        
        let userPreview = HTTPRequester.getUserPreview(id: id)
        
        Self.userPreviewCache[id] = userPreview
        
        return userPreview
    }
    
    let id: String
    
    let username: String
    let shortBiography: String
    let profilePicture: UIImage
    
    let sessionIDs: [String]
    let likedWorkoutIDs: [String]
    let publishedWorkoutIDs: [String]
    
    func sessions() -> [WorkoutSession] {sessionIDs.map(WorkoutSession.getWorkoutSession(id:))}
    func likedWorkouts() -> [Workout] {likedWorkoutIDs.map(Workout.getWorkout(id:))}
    func publishedWorkouts() -> [Workout] {likedWorkoutIDs.map(Workout.getWorkout(id:))}
    
    func follow() {
        HTTPRequester.followUser(otherID: id)
        UserPreview.userPreviewCache[id] = self
        User.currentUser.followingIDs.append(id)
    }
    
    func unfollow() {
        HTTPRequester.unfollowUser(otherID: id)
        User.currentUser.followingIDs.removeAll(where: {$0 == id})
    }
    
    enum Key: String, CodingKey {
        case id, username
        case shortBiography
        case profilePicture
        case sessionIDs, likedWorkoutIDs, publishedWorkoutIDs
    }
    
    // DECODABLE
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        id = try container.decode(String.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        shortBiography = try container.decode(String.self, forKey: .shortBiography)
        
        let profilePictureString = try container.decode(String.self, forKey: .profilePicture)
        let profilePictureData = Data(base64Encoded: profilePictureString)!
        profilePicture = UIImage(data: profilePictureData)!
        
        sessionIDs = try container.decode([String].self, forKey: .sessionIDs)
        likedWorkoutIDs = try container.decode([String].self, forKey: .likedWorkoutIDs)
        publishedWorkoutIDs = try container.decode([String].self, forKey: .publishedWorkoutIDs)
    }
    
}
