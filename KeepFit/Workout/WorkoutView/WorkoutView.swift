//
//  WorkoutView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/21/21.
//

import SwiftUI
import AVKit

struct WorkoutView: View {
    
    static func createNavigationLink(workout: Workout) -> some View {
        return NavigationLink(destination: LazyView({WorkoutView(workout: workout)})) {
            VStack {
                Text(workout.title)
                    .italic()
                Text("by \(workout.creator().username)")
            }
            .centered()
            .foregroundColor(.noncontrast)
            .padding()
            .background(Capsule().foregroundColor(.contrast))
            .padding()
        }
    }
    
    @ObservedObject var workout: Workout
    
    @State var selectedDate = Date()
    @State var workoutPlanError: String? = nil
    
    var body: some View {
        //         ScrollView {
        VStack {
            VideoPlayer(player: AVPlayer(url: workout.videoURL()))
            Form {
                
                Section(header: Text("Workout Info")) {
                    HStack{
                        Text(workout.title)
                        Text("(\(workout.category.rawValue))")
                            .italic()
                    }
                    .centered()
                    Text(workout.caption)
                }
                
                Section(header: Text("Creation Info")) {
                    NavigationLink("Creator: \(workout.creator().username)", destination:
                                    LazyView({UserPreviewView(userPreview: workout.creator())})
                    )
                    Text("Created: \(workout.createdDate.dateString())")
                }
                
                Section {
                    CreateWorkoutSessionView.createNavigationLink(workout: workout)
                    if workout.videoLiked {
                        Button(action: workout.unlikeVideo) {
                            Label("Unlike Video", systemImage: "hand.thumbsup.fill")
                        }
                    } else {
                        Button(action: workout.likeVideo) {
                            Label("Like Video", systemImage: "hand.thumbsup")
                        }
                    }
                }
                Section(header: Text("Comments")) {
                    List(workout.comments) {(comment: Workout.Comment) in
                        WorkoutCommentView.createNavigationLink(comment: comment)
                    }
                }
                
                Section {
                    CreateWorkoutCommentView.createNavigationLink(workout: workout)
                }
                
                
                Section(header: Text("Plan Workout")) {
                    DatePicker("Date and Time", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                    Button("Plan Workout!", action: {
                        if !User.currentUser.addPlan(workout: workout, date: selectedDate) {
                            workoutPlanError = "Can't plan a workout in the past!"
                        }
                    })
                    .alert(item: $workoutPlanError) {(errorMessage: String) in
                        Alert(title: Text("Workout Plan Error"), message: Text(errorMessage), dismissButton: .cancel())
                    }
                }
                Section {
                    if workout.creatorID == User.currentUser.id {
                        Button("Delete Workout", action: {
                                User.currentUser.deleteWorkout(id: workout.id)
                            workout.beenDeleted = true
                        })
                            .foregroundColor(.red)
                    }
                }
                
            }
        }
        .disabled(workout.beenDeleted)
        //        }
        .navigationTitle(workout.title)
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(workout: Workout.getWorkout(id: "C0DC7CD7-4F67-4F46-B05A-F80280238F7D"))
    }
}
