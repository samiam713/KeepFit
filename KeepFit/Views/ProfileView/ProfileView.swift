//
//  ProfileView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/21/21.
//

import SwiftUI



struct ProfileView: View {
    
    @ObservedObject var user: User
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
//        NavigationView {
            VStack {
                KeepFitLogoView()
               
                Form {
                    
                    Section(header: Text("Profile Picture"))
                    {
                        Image(uiImage: user.profilePicture)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    
                    Section(header: Text("About Me")) {
                        Text(user.shortBiography)
                    }
                    
                    Section(header: Text("Fitness Data")) {
                        
                        Text(user.heightDescription())
                        Text(user.weightDescription())
                    }
                    
                    Section(header: Text("Liked Videos")) {
                        Text("") //placeholder
                        //Text(user.likedWorkouts())
                    }
                }
            }
            // .navigationBarHidden(true)
            .sheet(item: $user.changingSourceType) {_ in
                ProfilePictureView(user: user)
            }
            .alert(isPresented: $user.validationError, content: {
                Alert(title: Text(user.regUpdErrorString()), message: Text("Edit Form and Resubmit"), dismissButton: .cancel())
            })
        // }
        .navigationBarTitle(user.userRegistered ? "Edit User" : "Register User")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: User())
    }
}
