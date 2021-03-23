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
        userResults = HTTPRequester.searchUsers(prefix: currentSearch)
        workoutResults = HTTPRequester.searchWorkouts(prefix: currentSearch)
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("Keyword", text: $currentSearch)
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
            CategoriesView()
//            ScrollView {
//                VStack {
//                    Text("Users")
//                        .font(.headline)
//                    ForEach(userResults) {(userPreview: UserPreview) in
//                        // I should be a nav link
//                        Text(userPreview.username)
//                    }
//                    Divider()
//                    Text("Workouts")
//                        .font(.headline)
//                    ForEach(workoutResults) {(workout: Workout) in
//                        // I should also be a nav link
//                        Text(workout.title)
//                    }
//                }
//            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
