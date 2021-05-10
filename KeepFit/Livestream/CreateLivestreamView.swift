//
//  CreateLivestream.swift
//  KeepFit
//
//  Created by Samuel Donovan on 4/30/21.
//

import SwiftUI

struct CreateLivestreamView: View {
    
    static func createNavigationLink() -> some View {
        NavigationLink(destination: Self()) {
            Label("Create Livestream", systemImage: "video.badge.plus")
        }
    }
    
    @State var urlString = ""
    @State var description = ""
    @State var date = Date()
    @State var errorMessage: String? = nil
    @State var completedCreation = false
    @State var maximumParticipants = 4
    
    func publishLiveStream() {
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            return
        }
        guard description != "" else {
            errorMessage = "No description"
            return
        }
        
        let livestream = Livestream(url: url, description: description, date: date, maximumParticipants: maximumParticipants)
        
        LivestreamStore.singleton.add(livestream: livestream)
        completedCreation = true
    }
    

    var body: some View {
        Form {
            
            Section(header: Text("Livestream URL")) {
                TextField("", text: $urlString)
            }
            
            Section(header: Text("Description")) {
                TextField("", text: $description)
            }
            
            // Section(header: Text("Livestream Date")) {
            Section(header: Text("Livestream Date")) {
                DatePicker("Choose Date:", selection: $date)
            }
            
            Section(header: Text("Maximum Participants")) {
                Stepper("\(maximumParticipants) Participants", value: $maximumParticipants, in: 2...16)
            }
            
            if completedCreation {
                Section {
                    Button("Create new", action: {completedCreation = false}).centered()
                }
            } else {
                Section {
                    Button("Publish", action: self.publishLiveStream).centered()
                }
            }
        }
        .alert(item: $errorMessage) {(errorMessage: String) in
            Alert(title: Text("Create Livestream Error"), message: Text(errorMessage), dismissButton: .cancel())
        }
        .navigationBarTitle(Text("Join Livestream"))
    }
}

struct CreateLivestream_Previews: PreviewProvider {
    static var previews: some View {
        CreateLivestreamView()
    }
}
