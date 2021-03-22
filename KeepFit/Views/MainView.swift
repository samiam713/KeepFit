//
//  MainView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/20/21.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var controller = keepFitAppController
    
    var body: some View {
        NavigationView {
            TabView(selection: $controller.currentTab) {
                ProfileView(user:User())
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }.tag(KeepFitAppController.CurrentTab.Profile)
                ExploreView()
                    .tabItem {
                        Label("Explore", systemImage: "network")
                    }
                    .tag(KeepFitAppController.CurrentTab.Explore)
                ExerciseView()
                    .tabItem {
                        Label("Exercise", systemImage: "heart.circle")
                    }
                    .tag(KeepFitAppController.CurrentTab.Exercise)
                
                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .tag(KeepFitAppController.CurrentTab.Search)
                
                CreateWorkoutView(workout: Workout())
                    .tabItem {
                        Label("Upload", systemImage: "video")
                    }
                    .tag(KeepFitAppController.CurrentTab.Upload)
            }
            .navigationBarTitle(controller.getTabName())
            .navigationBarItems(trailing:
            NavigationLink(
                destination: UserProfileView(user: User.currentUser),
                label: {
                    Label("Edit Profile", systemImage: "gear")
                })
            )
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
