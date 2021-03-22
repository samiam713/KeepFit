//
//  CreateWorkoutVideo.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/21/21.
//

import SwiftUI

struct CreateWorkoutView: View {
    
    @ObservedObject var workout: Workout
    
    var body: some View {
        Form {
            Section {
                TextField("Title", text: $workout.title)
            }
                
            Section(header: Text("Caption")) {
                TextEditor(text: $workout.caption)
            }
            
            Section(header: Text("Category")) {
                Picker("Choose Category", selection: $workout.category) {
                    ForEach(WorkoutCategory.allCases.indices) {
                        Text(WorkoutCategory.allCases[$0].rawValue)
                            .tag(WorkoutCategory.allCases[$0])
                    }
                }
            }
            
            Section {
                Button(workout.creatingVideoURL == nil ? "Upload Video" : "Re-Upload Video") {
                    workout.recordingVideo = true
                }
            }
            
            Section {
                Button("Publish Workout", action: workout.attemptToPublishWorkout)
            }
        }
        .sheet(isPresented: $workout.recordingVideo, content: {
            CreateWorkoutVideoView(workout: workout)
        })
        .navigationTitle("Create Workout")
    }
}

struct CreateWorkoutVideo_Previews: PreviewProvider {
    static var previews: some View {
        
            CreateWorkoutView(workout: Workout())
        
    }
}
