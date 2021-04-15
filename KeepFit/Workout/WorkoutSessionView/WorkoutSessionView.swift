//
//  WorkoutSessionView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/23/21.
//

import SwiftUI

struct WorkoutSessionView: View {
    
    static func createNavigationLink(session: WorkoutSession) -> some View {
        return NavigationLink(destination: LazyView({WorkoutSessionView(session: session)})) {
            VStack {
                Text(session.workout().title)
                    .italic()
                Text("completed by \(session.user().username)")
            }
            .foregroundColor(.noncontrast)
            .padding()
            .centered()
            .background(Capsule().foregroundColor(.contrast))
            .padding()
        }
    }
    
    @ObservedObject var session: WorkoutSession
    
    var body: some View {
        Form {
            Section {
                Image(uiImage: session.user().profilePicture)
                    .resizable()
                    .scaledToFit()
                Text("\(session.user().username) is on fire!")
            }
            Section {
                Text("Completed on \(session.startTime.dateString())")
                Text("Took \(session.endTime.timeIntervalSince(session.startTime).twoDecimalPlaces()) seconds")
            }
            Section {
                KeepFitLogoView()
                Text("\(session.caloriesBurned.twoDecimalPlaces()) calories burned")
            }
            Section {
                if !session.isDeleted && session.userID == User.currentUser.id {
                    Button("Delete Workout Session", action: {User.currentUser.clearWorkoutSession(session: session)})
                        .foregroundColor(.red)
                }
                
            }
        }
        .navigationTitle("\(session.user().username)'s Workout")
    }
}

//struct WorkoutSessionView_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkoutSessionView()
//    }
//}
