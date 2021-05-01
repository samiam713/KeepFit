//
//  ExploreView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/21/21.
//

import SwiftUI

struct FriendExploreView: View {
    
    @ObservedObject var currentUser = User.currentUser
    
    var body: some View {
        Group {
            if !currentUser.following.isEmpty {
                Text("No friends!🤷🏼‍♂️")
                    .centered()
            } else {
                List(currentUser.following) {(userPreview: UserPreview) in
                    UserPreviewView.createNavigationLink(userPreview: userPreview)
                }
            }
        }
        .navigationTitle("Friend Activity")
        .onAppear(perform: currentUser.updateFollowing)
    }
}

struct ExploreView: View {
    
    let tenMostLikedWorkouts: [Workout]
    
    init() {
        // self.tenMostLikedWorkouts = .init(repeating: .init(), count: 5)
        let tenMostLikedWorkoutIDs = HTTPRequester.get10MostLikedWorkouts()
        self.tenMostLikedWorkouts = tenMostLikedWorkoutIDs.map({HTTPRequester.getWorkout(id: $0)})
    }
    
    var body: some View
    {
        VStack {
            HStack {
                Text("Explore")
                    .font(.largeTitle)
                    .foregroundColor(.primary)
                Text("Fit")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
            }
            Divider()
            Text("Most Popular Videos")
                .underline()
                .font(.title2)
                .padding()
            List(0..<10) {(i: Int) in
                HStack {
                    Image(systemName: "\(i+1).circle\(i.isMultiple(of: 2) ? ".fill" : "")")
                        .font(Font.system(size: 36))
                    if i < tenMostLikedWorkouts.count {
                        Spacer()
                        WorkoutView.createNavigationLink(workout: tenMostLikedWorkouts[i])
                        Spacer()
                    } else {
                        Spacer()
                    }
                }
            }
            Divider()
            VStack {
            NavigationLink(
                destination: FriendExploreView(), label: {
                    Label("Friend Activity", systemImage: "person.2.square.stack")
                })
                Divider()
                LivestreamStoreView.createNavigationLink()
                Divider()
                CreateLivestreamView.createNavigationLink()
                
            }
            .font(.system(size: 24))
        }
        .padding([.top,.bottom])
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExploreView()
        }
    }
}
