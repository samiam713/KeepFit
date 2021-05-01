//
//  LivestreamView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 4/30/21.
//

import SwiftUI

struct LivestreamStoreView: View {
    
    @ObservedObject var livestreamStore = LivestreamStore.singleton
    
    static func createNavigationLink() -> some View {
        NavigationLink(destination: Self()) {
            Label("Livestreams", systemImage: "video")
        }
    }
    
    var body: some View {
        VStack {
            Button("Refresh", action: livestreamStore.refresh)
        List(livestreamStore.livestreams) {(livestream: Livestream) in
            LivestreamView.createNavigationLink(livestream: livestream)
        }
        }
        .navigationBarTitle("Livestreams")
    }
}

struct LivestreamView: View {
    
    let livestream: Livestream
    
    static func createNavigationLink(livestream: Livestream) -> some View {
        NavigationLink(destination: Self(livestream: livestream)) {
            Text("\(livestream.creator().username)'s stream")
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Creator")) {
                UserPreviewView.createNavigationLink(userPreview: livestream.creator())
            }
            Section(header: Text("Description")) {
                Text(livestream.description)
            }
            Section(header: Text("Date")) {
                Text(livestream.date.dateString())
                Text(livestream.date.secondString())
            }
            Section {
                Button("Start Livestream!", action: livestream.open)
            }
        }
        .navigationBarTitle("\(livestream.creator().username)'s stream")
    }
}

//struct LivestreamView_Previews: PreviewProvider {
//    static var previews: some View {
//        LivestreamView()
//    }
//}
