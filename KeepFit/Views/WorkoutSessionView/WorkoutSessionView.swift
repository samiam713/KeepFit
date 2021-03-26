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
            HStack {
                Text(session.workout().title)
                    .italic()
                Spacer()
                Text("completed by \(session.user().username)")
            }
            .foregroundColor(.noncontrast)
            .padding()
            .background(Capsule().foregroundColor(.contrast))
            .padding()
        }
    }
    
    let session: WorkoutSession
    
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
                Text("Took \(session.endTime!.timeIntervalSince(session.startTime).twoDecimalPlaces())s")
            }
            Section {
                KeepFitLogoView()
                Text("\(session.caloriesBurned) calories burned")
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
