//
//  UserPreviewView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/21/21.
//

import SwiftUI

struct UserPreviewView: View {
    
    //  LazyView({viewUsingStringID})
    
    static func createNavigationLink(userPreview: UserPreview) -> some View {
        return NavigationLink(destination: LazyView({UserPreviewView(userPreview: userPreview)})) {
            Text(userPreview.username)
                .italic()
                .centered()
                .foregroundColor(.noncontrast)
                .padding()
                .background(Capsule().foregroundColor(.contrast))
                .padding()
        }
    }
    
    let userPreview: UserPreview
    
    @ObservedObject var currentUser = User.currentUser
    
    init(userPreview: UserPreview) {
        self.userPreview = userPreview
    }
    
    var body: some View {
        Form {
            Section(header: Text("Profile Picture")) {
                Image(uiImage: userPreview.profilePicture)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }
            
            Section(header: Text(userPreview.username)) {
                Text(userPreview.shortBiography)
                    .centered()
                if currentUser.id != userPreview.id {
                    if !currentUser.followingIDs.contains(userPreview.id) {
                        Button(action: userPreview.follow) {
                            Label("Follow User", systemImage: "person.fill.badge.plus")
                        }
                    } else {
                        Button(action: userPreview.unfollow) {
                            Label("Unfollow User", systemImage: "person.fill.badge.minus")
                        }
                    }
                }
            }
            
            Section(header: Text("Liked Workouts")) {
                List(userPreview.likedWorkouts()) {(workout: Workout) in
                    WorkoutView.createNavigationLink(workout: workout)
                }
            }
            
            Section(header: Text("Published Workouts")) {
                List(userPreview.publishedWorkouts()) {(workout: Workout) in
                    WorkoutView.createNavigationLink(workout: workout)
                }
            }
            
            Section(header: Text("Completed Workouts")) {
                List(userPreview.sessions()) {(session: WorkoutSession) in
                    WorkoutSessionView.createNavigationLink(session: session)
                }
            }
        }
        .navigationTitle(userPreview.username)
    }
}

//struct UserPreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserPreviewView()
//    }
//}
