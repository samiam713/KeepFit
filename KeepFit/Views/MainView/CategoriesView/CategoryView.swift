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
    
    init(category: WorkoutCategory) {
        self.category = category
        self.workouts = HTTPRequester.getWorkoutsOfCategory(category: category)
    }
    
    var body: some View {
        List(workouts) {(workout: Workout) in
            
        }
        .navigationTitle(category.rawValue)
    }
}

//struct CategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryView(category: .Aerobics)
//    }
//}
