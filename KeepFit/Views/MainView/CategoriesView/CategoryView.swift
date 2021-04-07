//
//  CategoryView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/22/21.
//

import SwiftUI

struct CategoryView: View {
    
    let category: WorkoutCategory
    
    let workouts: [Workout]
    
    @State var currentWorkouts = [Workout]()
    @State var currentSearch = ""
    
    init(category: WorkoutCategory) {
        self.category = category
        let workouts = HTTPRequester.getWorkoutsOfCategory(category: category)
        self.workouts = workouts
        self.currentWorkouts = workouts
    }
    
    func search() {
        currentWorkouts = workouts.filter({$0.matches(keyword: currentSearch)})
        hideKeyboard()
        currentSearch = ""
    }
    
    func reset() {
        if currentWorkouts.count != workouts.count {
            currentWorkouts = workouts
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
                
                if currentSearch != "" {
                    Button(action: search) {
                        Label("Search", systemImage: "magnifyingglass")
                            .transition(.move(edge: .trailing))
                            .animation(.default)
                    }
                } else {
                    Button(action: reset) {
                        Label("Reset", systemImage: "clear")
                            .transition(.move(edge: .trailing))
                            .animation(.default)
                    }
                }
            }
            .padding()
            List(workouts) {(workout: Workout) in
                WorkoutView.createNavigationLink(workout: workout)
            }
        }
        .navigationTitle(category.rawValue)
    }
}


//struct CategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryView(category: .Aerobics)
//    }
//}
