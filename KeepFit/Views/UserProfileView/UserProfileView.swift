//
//  UserProfileView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/19/21.
//

import SwiftUI

struct UserProfileView: View {
    
    @ObservedObject var user: User
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
//        NavigationView {
            VStack {
                KeepFitLogoView()
               
                Form {
                    
                    Section(header: Text(user.username))
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
                    
                    Section(header: Text("Published Workouts")) {
                        Text("") //placeholder
                        //Text(user.publishedWorkouts())
                    }
                    
                    Section(header: Text("Completed Workouts")) {
                        Text("") //placeholder
                        //Text(user.completedWorkouts())
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
struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(user: User())
    }
}
