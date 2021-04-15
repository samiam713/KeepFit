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
                    if workoutSession.workoutCompleted() {
                        Text("Ended workout at \(workoutSession.endTime.secondString())")
                    }
                }
                Section {
                    Slider(value: $workoutSession.caloriesBurned, in: 0...500, label: {
                        Text("Calories Burned")
                    })
                    Text("\(workoutSession.caloriesBurned) calories Burned")
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
                    Button("Publish Workout", action: workoutSession.completeWorkoutSession)
                        .disabled(workoutSession.workoutCompleted())
                }
            }
            .alert(item: $workoutSession.caloriesError) {(error: String) in
                Alert(title: Text("Error"), message: Text(error), dismissButton: .cancel())
            }
            .navigationTitle("Workout Session")
            .onAppear() {
                let now = Date()
                workoutSession.startTime = now
                workoutSession.endTime = now
            }
        }
    }
}

//struct WorkoutSessionView_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkoutSessionView()
//    }
//}
