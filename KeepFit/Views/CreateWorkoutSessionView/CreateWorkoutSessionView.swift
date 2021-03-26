//
//  WorkoutSessionViews.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/21/21.
//

import SwiftUI
import AVKit

struct CreateWorkoutSessionView: View {
    
    static func createNavigationLink(workout: Workout) -> some View {
        return NavigationLink(destination: CreateWorkoutSessionView(workout: workout)) {
            Text("#keepfit")
                .centered()
                .foregroundColor(.white)
                .padding()
                .background(Capsule().foregroundColor(.blue))
                .padding()
        }
    }
    
    @ObservedObject var workout: Workout
    @ObservedObject var workoutSession: WorkoutSession
    
    init(workout: Workout) {
        self.workout = workout
        self.workoutSession = WorkoutSession(workoutID: workout.id)
    }
    
    var body: some View {
        VStack {
            VideoPlayer(player: AVPlayer(url: workout.videoURL()))
            Form {
                Section() {
                    Text("Started workout at \(workoutSession.startTime.secondString())")
                    if workoutSession.endTime != nil {
                        Text("Ended workout at \(workoutSession.endTime!.secondString())")
                    }
                }
                Section {
                    HStack {
                        Text(workout.title)
                        Text("(\(workout.category.rawValue))")
                            .italic()
                    }
                    Text(workout.caption)
                        .centered()
                }
                // one day... make this "sexy"
                Section {
                    Button("Publish Workout", action: workoutSession.completeWorkout)
                        .disabled(workoutSession.workoutCompleted())
                }
            }
            .navigationTitle("Workout Session")
            .onAppear() {
                workoutSession.startTime = Date()
            }
        }
    }
}

//struct WorkoutSessionView_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkoutSessionView()
//    }
//}
