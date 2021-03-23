//
//  WorkoutSessionViews.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/21/21.
//

import SwiftUI
import AVKit

struct WorkoutSessionView: View {
    
    @ObservedObject var workout: Workout
    @ObservedObject var workoutSession: WorkoutSession
    
    init(workoutID: String) {
        let workout = Workout.getWorkout(id: workoutID)
        self.workout = workout
        self.workoutSession = WorkoutSession(workoutID: workout.id)
    }
    
    var body: some View {
        VStack {
            Text("Started workout at \(workoutSession.startTime.secondString())")
            VideoPlayer(player: AVPlayer(url: workout.videoURL()))
            Text(workout.title)
                .font(.title2)
            Text(workout.category.rawValue)
                .italic()
            Text(workout.caption)
            Divider()
            
            // one day... make this "sexy"
            Button("Publish Workout", action: workoutSession.completeWorkout)
                .disabled(workoutSession.workoutCompleted())
        }
        .navigationTitle("Workout Session")
    }
}

//struct WorkoutSessionView_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkoutSessionView()
//    }
//}
