//
//  ProfileView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/21/21.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var user = User.currentUser
    
    var body: some View {
        //        NavigationView {
        VStack {
            KeepFitLogoView()
            
            Form {
                Section(header: Text("Profile Picture")) {
                    Image(uiImage: user.profilePicture)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .shadow(radius: 10)
                }
                
                Section(header: Text(user.username)) {
                    Text(user.shortBiography)
                        .centered()
                    Text("Birthday: \(user.birthdate.dateString())")
                }
                
                Section(header: Text("Fitness Data")) {
                    Text(user.heightDescription())
                    Text(user.weightDescription())
                    Text("\(user.sessions().reduce(0, {(res: Double,wos: WorkoutSession) in res + wos.caloriesBurned}).twoDecimalPlaces()) total calories burned")
                }
                
                Section(header: Text("Workout Sessions")) {
                    List(user.sessions()) {(session: WorkoutSession) in
                        WorkoutSessionView.createNavigationLink(session: session)
                    }
                }
                
                Section(header: Text("My Workouts")) {
                    List(user.publishedWorkouts()) {(workout: Workout) in
                        WorkoutView.createNavigationLink(workout: workout)
                    }
                }
            }
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
