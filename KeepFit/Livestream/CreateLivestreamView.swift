//
//  CreateLivestream.swift
//  KeepFit
//
//  Created by Samuel Donovan on 4/30/21.
//

import SwiftUI

struct CreateLivestreamView: View {
    
    @State var urlString = ""
    @State var description = ""
    @State var date = Date()
    @State var errorMessage: String? = nil
    @State var completedCreation = false
    
    func publishLiveStream() {
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            return
        }
        guard description != "" else {
            errorMessage = "No description"
            return
        }
        
        let livestream = Livestream(url: url, description: description, date: date)
        
        Livestream.add(livestream: livestream)
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
        }
        .disabled(completedCreation)
        .alert(item: $errorMessage) {(errorMessage: String) in
            Alert(title: Text("Create Livestream Error"), message: Text(errorMessage), dismissButton: .cancel())
        }
        .navigationBarTitle(Text("Create Livestream"))
    }
}

struct CreateLivestream_Previews: PreviewProvider {
    static var previews: some View {
        CreateLivestreamView()
    }
}