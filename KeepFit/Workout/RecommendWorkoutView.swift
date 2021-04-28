//
//  RecommendWorkoutView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 4/27/21.
//

import SwiftUI

struct RecommendWorkoutView: View {
    
    let workout: Workout
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text("You might like this workout!")
                        .font(.title2)
                    Button("Dismiss") {
                        keepFitAppController.currentView = .mainView
                    }
                }
                .padding()
                .centered()
                Divider()
                WorkoutView.createNavigationLink(workout: workout)
            }
            .navigationBarTitle(Text("Recommended Workout"))
        }
    }
}

//struct RecommendWorkoutView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecommendWorkoutView()
//    }
//}
