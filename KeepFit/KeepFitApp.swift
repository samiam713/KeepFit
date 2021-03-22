//
//  KeepFitApp.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/19/21.
//

import SwiftUI

let keepFitAppController = KeepFitAppController()

class KeepFitAppController: ObservableObject {
    enum CurrentView: Int {case entry = 0, registering, editing, mainView}
    
    @Published var currentView = CurrentView.entry
    
    enum CurrentTab: String {case Profile, Explore, Exercise, Search, Upload}
    
    @Published var currentTab = CurrentTab.Exercise
    
    func getTabName() -> String {
        return currentTab.rawValue
    }
}

@main
struct KeepFitApp: App {
    
    @ObservedObject var controller = keepFitAppController
    
    var body: some Scene {
        WindowGroup {
            
//                 CreateWorkoutView(workout: Workout())
            
            if controller.currentView == .entry {
                 EntryView()
            } else if controller.currentView == .registering {
                UserProfileView(user: User.currentUser)
            } else if controller.currentView == .mainView {
                 MainView()
            }
            
        }
    }
}
