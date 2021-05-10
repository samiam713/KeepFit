//
//  FollowingPublishedExercisesView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 5/8/21.
//

import SwiftUI

struct FollowingPublishedWorkoutsView: View {
    
    let user = User.currentUser
    
    var body: some View {
        List(user.getFollowingPublishedWorkouts()) {(workout: Workout) in
            WorkoutView.createNavigationLink(workout: workout)
        }
        .navigationBarTitle("Followings' Workouts")
    }
}

struct FollowingPublishedExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        FollowingPublishedWorkoutsView()
    }
}
