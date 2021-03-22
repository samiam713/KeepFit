//
//  SearchView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/21/21.
//

import SwiftUI

struct SearchView: View {
    
    @State var currentSearch = ""
    
    @State var userResults = [UserPreview].init(repeating: .init(), count: 5)
    @State var workoutResults = [Workout].init(repeating: .init(), count: 5)
    
    func search() {
        userResults = HTTPRequester.get10Users(prefix: currentSearch)
        workoutResults = HTTPRequester.get10Workouts(prefix: currentSearch)
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("Keyword", text: $currentSearch)
                    .foregroundColor(.gray)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 5).stroke())
                    .padding()
                
                Button(action: search) {
                    Text("Search")
                        .padding()
                }
            }
            Text("Search Results:")
            Divider()
            ScrollView {
                VStack {
                    Text("Users")
                        .font(.headline)
                    ForEach(userResults) {(userPreview: UserPreview) in
                        // I should be a nav link
                        Text(userPreview.username)
                    }
                    Divider()
                    Text("Workouts")
                        .font(.headline)
                    ForEach(workoutResults) {(workout: Workout) in
                        // I should also be a nav link
                        Text(workout.title)
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
