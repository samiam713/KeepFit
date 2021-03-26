//
//  ChangePasswordView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/26/21.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @State var oldPassword = ""
    @State var newPassword = ""
    
    @State var errorMessage: String? = nil
    
    func attemptChange() {
        
        guard (4...16).contains(newPassword.count) else {
            errorMessage = "Password must be 4-16 characters long"
            return
        }
        
        let succeeded = HTTPRequester.resetPassword(oldPassword: oldPassword, newPassword: newPassword)
        
        if !succeeded {
            errorMessage = "Old password incorrect"
        } else {
            errorMessage = "Successful change"
        }
        oldPassword = ""
        newPassword = ""
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Old Password", text: $oldPassword)
                TextField("New Password", text: $newPassword)
            }
            Section {
                Button("Update", action: attemptChange)
            }
        }
        .alert(item: $errorMessage) {(em: String) in
            Alert(title: Text("Update Password Result"), message: Text(em), dismissButton: .cancel())
        }
        .navigationTitle(Text("Update Password"))
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
