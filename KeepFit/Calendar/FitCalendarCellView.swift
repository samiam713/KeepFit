//
//  FitCalendaryCellView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 4/12/21.
//

import SwiftUI

struct FitCalendarCellView: View {
    
    @ObservedObject var eventStore = User.currentUser.eventStore
    
    let dayComponents: DayComponents
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3.0)
                .foregroundColor(dayComponents.getColor(opaque: false))
            RoundedRectangle(cornerRadius: 3.0).stroke(lineWidth: 2.0)
                .foregroundColor(dayComponents.getColor(opaque: true))
            VStack {
                HStack {
                    Image(systemName: "\(dayComponents.day.description).square")
                    Spacer()
                }
                Spacer()
                // nav link if there are events
                if eventStore.sessions[dayComponents] != nil || eventStore.plans[dayComponents] != nil {
                    VStack {
                        if eventStore.sessions[dayComponents] != nil {
                            // text
                            Text("\(eventStore.sessions[dayComponents]!.count) S")
                        }
                        if eventStore.plans[dayComponents] != nil {
                            // text
                            Text("\(eventStore.plans[dayComponents]!.count) P")
                            
                        }
                    }
                    
                    .foregroundColor(Color.noncontrast)
                    .background(RoundedRectangle(cornerRadius: 2.0).foregroundColor(.contrast))
                }
            }
            .padding()
        }
        .padding([.leading,.trailing], 2)
        .padding([.top,.bottom],5)
    }
}

struct FitCalendarDayView: View {
    @ObservedObject var eventStore = User.currentUser.eventStore
    
    let dayComponents: DayComponents
    
    var body: some View {
        Form {
            if eventStore.sessions[dayComponents] != nil {
                Section(header: Text("Sessions")) {
                    List(eventStore.sessions[dayComponents]!) {(session: WorkoutSession) in
                        WorkoutSessionView.createNavigationLink(session: session)
                    }
                }
            }
            if eventStore.plans[dayComponents] != nil {
                Section(header: Text("Plans")) {
                    List(eventStore.plans[dayComponents]!.sorted(by: {$0.date < $1.date})) {(plan: WorkoutPlan) in
                        VStack {
                            Text("Workout \"\(plan.workout().title)\" Planned")
                            Text(plan.date.secondString())
                                .italic()
                            NavigationLink(destination: WorkoutPlanView(plan: plan)) {
                                Text("#keepfit")
                                    .centered()
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Capsule().foregroundColor(.blue))
                                    .padding()
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitle(Text(dayComponents.prettyPrint()))
    }
}

struct WorkoutPlanView: View {
    @ObservedObject var user = User.currentUser
    
    let plan: WorkoutPlan
    
    var body: some View {
        VStack {
            if user.workoutPlans.contains(plan) {
                Button(action: {
                    User.currentUser.deletePlan(plan: plan)
                }) {
                    Text("Complete Plan")
                        .font(.title2)
                        .padding()
                        .foregroundColor(.noncontrast)
                        .background(Capsule().foregroundColor(.contrast))
                }
                Divider()
            }
            CreateWorkoutSessionView(workout: plan.workout())
        }
    }
}
