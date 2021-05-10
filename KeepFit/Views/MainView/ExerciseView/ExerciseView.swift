//
//  ExerciseView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/21/21.
//

import SwiftUI

struct ExerciseView: View {
    
    @ObservedObject var user = User.currentUser
    
    var body: some View {
        ScrollView {
            VStack {
                Button(action: {
                    keepFitAppController.currentView = .creatingWorkout
                }) {
                    HStack {
                        Text("Create")
                            .font(.largeTitle)
                            .foregroundColor(.noncontrast)
                        Text("Workout")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                    }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.contrast))
                        .padding()
                }
                Divider()
                
                NavigationLink(destination: SitupView()) {
                    Label("Do Situps!", systemImage: "face.smiling.fill")
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke().foregroundColor(.contrast))
                .padding()
                
                NavigationLink(destination: FollowingPublishedWorkoutsView()) {
                    Label("Followings' Published Workouts", systemImage: "flame.fill")
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke().foregroundColor(.contrast))
                        .padding()
                }
                
                Divider()
                Text("Liked Workouts")
                    .font(.title)
                    .bold()
                ForEach(user.likedWorkouts()) {(workout: Workout) in
                    WorkoutView.createNavigationLink(workout: workout)
                }
                Divider()
                Text("My Workouts")
                    .font(.title)
                    .bold()
                ForEach(user.publishedWorkouts()) {(workout: Workout) in
                    WorkoutView.createNavigationLink(workout: workout)
                }
            }
        }
    }
}

struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseView()
    }
}
