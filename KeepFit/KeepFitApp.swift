//
//  KeepFitApp.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/19/21.
//

import SwiftUI

let keepFitAppController = KeepFitAppController()

class KeepFitAppController: ObservableObject {
    enum CurrentView: Int {case entry = 0, registering, mainView, creatingWorkout}
    
    @Published var currentView = CurrentView.entry
    
    enum CurrentTab: String {case Profile, Explore, Exercise, Search, Categories}
    
    @Published var currentTab = CurrentTab.Exercise
    
    func getTabName() -> String {
        return currentTab.rawValue
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
            
//                 CreateWorkoutView(workout: Workout())
            
            if controller.currentView == .entry {
                 EntryView()
            } else if controller.currentView == .registering {
                UserProfileView(user: User.currentUser)
            } else if controller.currentView == .mainView {
                 MainView()
            } else if controller.currentView == .creatingWorkout {
                CreateWorkoutView()
            }
            
        }
    }
}
