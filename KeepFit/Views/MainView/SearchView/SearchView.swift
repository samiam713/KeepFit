//
//  SearchView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/21/21.
//

import SwiftUI

struct SearchView: View {
    
    @State var currentSearch = ""
    
    @State var userResults = [UserPreview]()
    @State var workoutResults = [Workout]()
    
    func search() {
        hideKeyboard()
        userResults = HTTPRequester.searchUsers(prefix: currentSearch)
        workoutResults = HTTPRequester.searchWorkouts(prefix: currentSearch)
        
        for userPreview in userResults {
            UserPreview.userPreviewCache[userPreview.id] = userPreview
        }
        for workout in workoutResults {
            Workout.workoutCache[workout.id] = workout
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("Keyword", text: $currentSearch)
                    .disableAutocorrection(true)
                    .foregroundColor(.gray)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 5).stroke())
                
                Button(action: search) {
                    Label("Search", systemImage: "magnifyingglass")
                    // Text("Search")
                        
                        .transition(.move(edge: .trailing))
                         .animation(.default)
                        .disabled(currentSearch == "")
                
                }
            }
            .padding()
            Text("Results")
                .italic()
            Divider()
            ScrollView {
                VStack {
                    Text("Users")
                        .font(.headline)
                    ForEach(userResults) {(userPreview: UserPreview) in
                        UserPreviewView.createNavigationLink(userPreview: userPreview)
                    }
                    Divider()
                    Text("Workouts")
                        .font(.headline)
                    ForEach(workoutResults) {(workout: Workout) in
                        WorkoutView.createNavigationLink(workout: workout)
                    }
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
