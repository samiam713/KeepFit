//
//  KeepFitApp.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/19/21.
//

import SwiftUI

let keepFitAppController = KeepFitAppController()

class KeepFitAppController: ObservableObject {
    enum CurrentView: Equatable {case entry, registering, mainView, creatingWorkout, recommendingWorkout(workout: Workout)}
    func getRecommending() -> Workout? {
        switch currentView {
        case .recommendingWorkout(workout: let workout):
            return workout
        default: return nil
        }
    }
    
    @Published var currentView = CurrentView.entry
    
    enum CurrentTab: String {case Profile, Explore, Exercise, Search, Categories}
    
    @Published var currentTab = CurrentTab.Exercise
    
    @Published var networkRequests = 0
    
    func getTabName() -> String {currentTab.rawValue}
    
    func login(user: User) {
        User.currentUser = user
        if let session = user.mostRecentSession(),
           let recommendedID = HTTPRequester.getMostLikedWorkoutOfCategory(category: session.workout().category.rawValue) {
            let recommended = Workout.getWorkout(id: recommendedID)
            currentView = .recommendingWorkout(workout: recommended)
        } else {
            keepFitAppController.currentView = .mainView
        }
    }
}

@main
struct KeepFitApp: App {
    
    @ObservedObject var controller = keepFitAppController
    
    init() {
        //        let encoder =  JSONEncoder()
        //        encoder.outputFormatting = .prettyPrinted
        //        let exampleUserJSON = try! encoder.encode(User.currentUser)
        //        print(String(data: exampleUserJSON, encoding: .utf8)!)
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if controller.currentView == .entry {
                    EntryView()
                } else if controller.currentView == .registering {
                    UserProfileView(user: User.currentUser)
                } else if controller.currentView == .mainView {
                    MainView()
                } else if controller.currentView == .creatingWorkout {
                    CreateWorkoutView()
                }
                else if let recommended = controller.getRecommending() {
                    
                }
                
                if controller.networkRequests > 0 {
                    LoadingAnimationView()
                }
            }
        }
    }
}
