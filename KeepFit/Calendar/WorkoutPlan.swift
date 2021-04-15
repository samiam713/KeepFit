//
//  WorkoutPlan.swift
//  KeepFit
//
//  Created by Samuel Donovan on 4/12/21.
//

import Foundation

class WorkoutPlan: Equatable, Codable, Identifiable {
    
    static func ==(lhs: WorkoutPlan,rhs:WorkoutPlan) -> Bool {lhs.id == rhs.id}
    
    let id: String
    let userID: String
    let workoutID: String
    let date: Date
    
    func workout() -> Workout {Workout.getWorkout(id: workoutID)}
    
    init(workout: Workout, date: Date) {
        self.id = UUID().uuidString
        self.userID = User.currentUser.id
        
        self.workoutID = workout.id
        self.date = date
    }
    
    enum Key: String, CodingKey {
        case id, userID
        case workoutID, date
    }
    
    // DECODABLE
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: Key.self)
        
        id = try container.decode(String.self, forKey: .id)
        userID = try container.decode(String.self, forKey: .userID)
        workoutID = try container.decode(String.self, forKey: .workoutID)
        
        let dateDouble = try container.decode(Double.self, forKey: .date)
        date = Date(timeIntervalSince1970: dateDouble)
    }
    
    // ENCODABLE
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(userID, forKey: .userID)
        try container.encode(workoutID, forKey: .workoutID)
        
        try container.encode(date.timeIntervalSince1970, forKey: .date)
    }
}
