//
//  CreateWorkoutVideo.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/21/21.
//

import SwiftUI

struct CreateWorkoutView: View {
    
    @ObservedObject var workout = Workout()
    
    var body: some View {
        NavigationView {
            VStack {
                KeepFitLogoView()
                Text("Create New Workout")
                    .font(.title2)
                    .italic()
                    .foregroundColor(.gray)
                Form {
                    
                    Section(header: Text("Title")) {
                        TextField("Title", text: $workout.title)
                    }
                    
                    Section(header: Text("Caption")) {
                        TextEditor(text: $workout.caption)
                        Button("Complete Caption", action: hideKeyboard)
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
                        Button(workout.creatingVideoURL == nil ? "Record Video" : "Re-Record Video") {
                            workout.recordingVideo = true
                        }
                    }
                    
                    Section {
                        Button("Publish Workout", action: workout.attemptToPublishWorkout)
                        Button("Cancel", action: {keepFitAppController.currentView = .mainView})
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .sheet(isPresented: $workout.recordingVideo, content: {
            CreateWorkoutVideoView(workout: workout)
        })
        .alert(item: $workout.errorMessage) {(errorMessage: String) in
            Alert(title: Text("Error Publishing Workout"), message: Text(errorMessage), dismissButton: .cancel())
        }
    }
}

struct CreateWorkoutVideo_Previews: PreviewProvider {
    static var previews: some View {
        
        CreateWorkoutView(workout: Workout())
        
    }
}
