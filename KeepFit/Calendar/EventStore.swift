//
//  EventStorer.swift
//  KeepFit
//
//  Created by Samuel Donovan on 4/12/21.
//

import Foundation

class EventStore: ObservableObject {
    
    @Published var sessions = [DayComponents:[WorkoutSession]]()
    @Published var plans = [DayComponents:[WorkoutPlan]]()
    
    let today = DayComponents.today()
    
    func populate(user: User) {
        for session in user.sessions() {
            addSession(session: session)
        }
        for plan in user.workoutPlans {
            addPlan(plan: plan)
        }
    }
    
    func addSession(session: WorkoutSession) {
        let dc = DayComponents(date: session.endTime)
        
        if sessions[dc] != nil {
            sessions[dc]!.append(session)
        } else {
            sessions[dc] = [session]
        }
    }
    
    func removeSession(session: WorkoutSession) {
        let dc = DayComponents(date: session.endTime)
        guard sessions[dc] != nil else {return}
        
        sessions[dc]!.removeAll(where: {session == $0})
        
        if sessions[dc]!.isEmpty {
            sessions[dc] = nil
        }
    }
    
    func addPlan(plan: WorkoutPlan) {
        let dc = DayComponents(date: plan.date)
        
        if plans[dc] != nil {
            plans[dc]!.append(plan)
        } else {
            plans[dc] = [plan]
        }
    }
    
    func removePlan(plan: WorkoutPlan) {
        let dc = DayComponents(date: plan.date)
        guard plans[dc] != nil else {return}
        
        plans[dc]!.removeAll(where: {plan == $0})
        
        if plans[dc]!.isEmpty {
            plans[dc] = nil
        }
    }
    
    
}
