//
//  WorkoutSessionViews.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/21/21.
//

import SwiftUI
import AVKit

struct WorkoutSessionView: View {
    
    @ObservedObject var workout: Workout
    
    var body: some View {
        
            Form
            {
                VStack
                {
                    //Section(header: Text(workout.title) .fontWeight(.bold) .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/) .multilineTextAlignment(.center))
                    Section(header: Text("20 min Full Body STRETCH/YOGA for STRESS & ANXIETY Relief [LIVE]")  .multilineTextAlignment(.center))
                    {
                        VideoPlayer(player: AVPlayer(url:  URL(string: "https://bit.ly/swswift")!))
                            
                            {
                            }
                            .frame(height: 400)

                        VStack
                        {
                            //Should link to user's profile
                            Text("YogaUser1")
                                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                            LikeButton().offset(x: 140, y: -30)
                        }
                    
                    }
                }
                Section {
                    Button(action: workout.attemptToPublishWorkout)
                    {
                        HStack{
                            Spacer()
                            Text("Completed Workout!")
                            Spacer()
                        }
                    }
                }
            }
    }
}

struct WorkoutSessionView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutSessionView(workout: Workout())
    }
}
