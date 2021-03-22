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
                    }
                    .tag(KeepFitAppController.CurrentTab.Profile)
                Text("b")
                    .tabItem {
                        Label("Explore", systemImage: "network")
                    }
                    .tag(KeepFitAppController.CurrentTab.Explore)
                Text("c")
                    .tabItem {
                        Label("Exercise", systemImage: "heart.circle")
                    }
                    .tag(KeepFitAppController.CurrentTab.Exercise)
                
                SearchView(text: .constant(""))
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .tag(KeepFitAppController.CurrentTab.Search)
                
                Text("TO BE IMPLEMENTED LATER")
                    .tabItem {
                        Label("Livestream", systemImage: "video")
                    }
                    .tag(KeepFitAppController.CurrentTab.Livestream)
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
