//
//  User.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/19/21.
//

import Foundation
import UIKit

enum Sex: String, CaseIterable {case Male, Female, Unspecified}

class User: NSObject, ObservableObject {
    
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
    
    @Published var profilePicture = UIImage(named: "LarryWheels")!
    
    @Published var following = [String]()
    
    @Published var sessionIDs = [String]()
    @Published var likedWorkoutIDs = [String]()
    @Published var publishedWorkoutIDs = [String]()
    
    func sessions() -> [WorkoutSession] {sessionIDs.map(WorkoutSession.getWorkoutSession(id:))}
    func likedWorkouts() -> [Workout] {likedWorkoutIDs.map(Workout.getWorkout(id:))}
    func publishedWorkouts() -> [Workout] {likedWorkoutIDs.map(Workout.getWorkout(id:))}
    
    @Published var usernameError = ""
    @Published var passwordError = ""
    @Published var changingSourceType: UIImagePickerController.SourceType? = nil
    
    @Published var userRegistered = false
    
    @Published var validationError = false
    func regUpdErrorString() -> String {"\(userRegistered ? "Update" : "Registration") Error"}
    
    // potentially keep track of when last update to server was
    // so when the users update their data, they can see that the last
    // update changed to now o'clock
    // @Published var lastUpdate = Date()
    
    func heightDescription() -> String {"Height: \(inches/12)' \(inches%12)\""}
    func weightDescription() -> String {"Weight: \(pounds) lbs"}
    
    // returns true iff valid username/password
    // if not valid, adds helpful error messages
    func validateData() -> Bool {
        var successful = true
        
        // update username error
        if !(5...15).contains(username.count) {
            usernameError = "Username must be 5-15 characters long"
            successful = false
        } else {
            usernameError = ""
        }
        
        if !userRegistered || password != "" {
            if !(5...15).contains(password.count) {
                passwordError = "Password must be 5-15 characters long"
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
    
    func attemptToUpdate() {
        guard validateData() else {return}
        HTTPRequester.updateUser(user: self)
        
    }
    
    func selectImage(sourceType: UIImagePickerController.SourceType) {
        self.changingSourceType = sourceType
    }
    
    enum Key: String, CodingKey {
        case id, username, password
        case shortBiography, sex, inches, pounds
        case profilePicture
        case following, sessionIDs, likedWorkoutIDs, publishedWorkoutIDs
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        id = try container.decode(String.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        // try container.encode(name, forKey: .name)
       //  try container.encode(days, forKey: .days)
    }
}

class UserPreview: Codable {
    init(){fatalError()}
    static var userPreviewCache = [String:UserPreview]()
    
    // used for efficiency
    // we never download the same UserPreview twice
    static func getUserPreview(id: String) -> UserPreview {
        
        if let userPreview = Self.userPreviewCache[id] {
            return userPreview
        }
        
        let userPreview = HTTPRequester.getUserPreview(id: id)
        
        Self.userPreviewCache[id] = userPreview
        
        return userPreview
    }
    
    let username: String
    let shortBiography: String
    let profilePicture: UIImage
    let birthdate: String
    
    let sessionIDs: [String]
    let likedWorkoutIDs: [String]
    let publishedWorkoutIDs: [String]
    
    func sessions() -> [WorkoutSession] {sessionIDs.map(WorkoutSession.getWorkoutSession(id:))}
    func likedWorkouts() -> [Workout] {likedWorkoutIDs.map(Workout.getWorkout(id:))}
    func publishedWorkouts() -> [Workout] {likedWorkoutIDs.map(Workout.getWorkout(id:))}
    
    // DECODABLE
    required init(from decoder: Decoder) throws {
        fatalError()
    }
    
    // ENCODABLE
    func encode(to encoder: Encoder) throws {
        fatalError()
    }
}
