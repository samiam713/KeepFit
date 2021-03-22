//
//  ExploreView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/21/21.
//

import SwiftUI
import AVKit

struct ExploreView: View
{
    
    var body: some View
    {
        Form
        {
            VStack
            {
                Section(header: Text("Latest Videos and Livestreams") .fontWeight(.bold) .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/) .multilineTextAlignment(.center))
                {
                    VideoPlayer(player: AVPlayer(url:  URL(string: "https://bit.ly/swswift")!))
                        
                        {
                            //Text(video.title)
                            VStack
                            {
                                Text("20 min Full Body STRETCH/YOGA for STRESS & ANXIETY Relief")
                                        .foregroundColor(.black)
                                        .background(Color.white.opacity(0.7))
                            }.offset(y: 170)
                        }
                    .frame(height: 400)
                    
                    //Should link to user's profile
                    Text("YogaUser1")
                    
                
                
                    VideoPlayer(player: AVPlayer(url:  URL(string: "https://bit.ly/swswift")!))
                        
                        {
                            //Text(video.title)
                            VStack
                            {
                                Text("The PERFECT Home Workout (Sets and Reps included)")
                                        .foregroundColor(.black)
                                        .background(Color.white.opacity(0.7))
                            }.offset(y: 170)
                        }
                    .frame(height: 400)
                    
                    //Should link to user's profile
                    Text("StrengthUser1")
                    
                }
            }
        }
    }
}

struct ExploreView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ExploreView()
    }
}
