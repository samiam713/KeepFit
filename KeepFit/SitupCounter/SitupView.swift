//
//  SitupView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 4/27/21.
//

import SwiftUI

struct SitupView: View {
    
    @ObservedObject var situpCounter = SitupCounter()
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 15.0)
                    .stroke(lineWidth: 5)
                    .foregroundColor(.blue)
                RoundedRectangle(cornerRadius: 5.0)
                    .foregroundColor(.blue.opacity(0.5))
                VStack {
                Text("Situps")
                Text(situpCounter.situpCount.description)
                }
                .font(.title)
            }
            .padding()
            Divider()
            ZStack {
                if !situpCounter.doingSitups {
            Button("Start Situps", action:
                    situpCounter.restart)
                } else {
            Button("Stop Situps", action: situpCounter.stop)
                }
            }
            .padding()
            .background(Capsule())
            Text("Making this view was 20 minutes of my life I will never get back")
                .italic()
                .padding()
        }
    }
}

