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
                Section(header: Text("Latest Videos and Livestreams"))
                {
                    VideoPlayer(player: AVPlayer(url:  URL(string: "https://bit.ly/swswift")!))
                        .frame(height: 400)
                    Text("20 min Full Body STRETCH/YOGA for STRESS & ANXIETY Relief")
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
