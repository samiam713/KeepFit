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
        return NavigationLink(destination: WorkoutView(workout: workout)) {
            HStack {
                Text(workout.title)
                    .italic()
                Spacer()
                Text("Creator: \(workout.creator().username)")
            }
            .foregroundColor(.noncontrast)
            .padding()
            .background(RoundedRectangle(cornerRadius: 5.0).foregroundColor(.contrast))
        }
    }
    
    let workout: Workout
    
    var body: some View {
        VStack {
            VideoPlayer(player: AVPlayer(url: workout.videoURL()))
            
            // some sort of button to like/unlike
        }
        .navigationTitle(workout.title)
    }
}

//struct WorkoutView_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkoutView()
//    }
//}
