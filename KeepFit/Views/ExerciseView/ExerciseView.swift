//
//  ExerciseView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/21/21.
//

import SwiftUI
import AVKit

struct LikeButton : View {
    @State var isPressed = false
    var body: some View {
        ZStack {
            Image(systemName: "hand.thumbsup.fill")
                .opacity(isPressed ? 1 : 0)
                .scaleEffect(isPressed ? 1.0 : 0.1)
                .animation(.linear)
            Image(systemName: "hand.thumbsup")
        }.font(.system(size: 20))
            .onTapGesture {
                self.isPressed.toggle()
        }
        .foregroundColor(isPressed ? .blue : .blue)
    }
}

struct ExerciseView: View {
    var body: some View {
        
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
                                    Text("20 min Full Body STRETCH/YOGA for STRESS & ANXIETY Relief [LIVE]")
                                            .foregroundColor(.black)
                                            .background(Color.white.opacity(0.7))
                                }.offset(y: 170)
                            }
                            .frame(height: 400)

                        VStack
                        {
                            //Should link to user's profile
                            Text("YogaUser1")
                            LikeButton().offset(x: 140, y: -30)
                        }
                    
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
                        LikeButton().offset(x: 140, y: -30)
                    }
                }
            }
    }
}

struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseView()
    }
}
