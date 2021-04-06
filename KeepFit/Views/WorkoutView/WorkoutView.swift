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
                        if workout.creatorID == User.currentUser.id {
                            Button("Delete Workout", action: {User.currentUser.deleteWorkout(id: workout.id)})
                                .foregroundColor(.red)
                        }
                    }
                }
            }
//        }
        .navigationTitle(workout.title)
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(workout: Workout.getWorkout(id: "C0DC7CD7-4F67-4F46-B05A-F80280238F7D"))
    }
}
