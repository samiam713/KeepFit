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
            HStack {
                Text(workout.title)
                    .italic()
                Spacer()
                Text("by \(workout.creator().username)")
            }
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
                        Text("Creator: \(workout.creator().username)")
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
