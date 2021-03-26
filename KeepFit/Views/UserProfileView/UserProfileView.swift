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
        
            VStack {
                
                
                Form {
                    
                    Section(header: Text("Login Info")) {
                        TextField("Username", text: $user.username)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        if user.usernameError != "" {
                            Text(user.usernameError)
                                .foregroundColor(.red)
                                .italic()
                        }
                        if !user.userRegistered {
                            SecureField("Password", text: $user.password)
                            if user.passwordError != "" {
                                Text(user.passwordError)
                                    .foregroundColor(.red)
                                    .italic()
                            }
                        } else {
                            NavigationLink("Change Password", destination: ChangePasswordView())
                        }
                    }
                    
                    Section(header: Text("About Me")) {
                        TextEditor(text: $user.shortBiography)
                        Button("Complete Biography", action: hideKeyboard)
                    }
                    
                    Section(header: Text("Fitness Data")) {
                        
                        Picker("Choose Sex", selection: $user.sex) {
                            ForEach(Sex.allCases.indices) {
                                Text(Sex.allCases[$0].rawValue)
                                    .tag(Sex.allCases[$0])
                            }
                        }
                        
//                        DatePicker(selection: $user.birthdate, in: ...Date(), displayedComponents: .date) {
//                            Text("Birthdate")
//                        }
                        
                        Stepper(user.heightDescription(), value: $user.inches, in: 48...84)
                        Stepper(user.weightDescription(), value: $user.pounds, in: 50...300, step: 5)
                    }
                    
                    Section(header: Text("Profile Picture")) {
                        Image(uiImage: user.profilePicture)
                            .resizable()
                            .scaledToFit()
                        Button("Select Picture From Photos", action: {
                            user.changingSourceType = .photoLibrary
                        })
                        Button("Take Picture Using Camera", action: {
                            user.changingSourceType = .camera
                        })
                    }
                    
                    Section {
                        if !user.userRegistered {
                            KeepFitLogoView()
                            Text("Register User")
                                .font(.title2)
                                .italic()
                                .foregroundColor(.gray)
                            Button("Complete User Registration", action: user.attemptToRegister)
                        } else {
                            Button("Complete User Update", action: user.attemptToUpdate)
                        }
                        if !user.userRegistered {
                            Button("Cancel User Registration", action: {keepFitAppController.currentView = .entry})
                                .foregroundColor(.red)
                        }
                    }
                }
            .sheet(item: $user.changingSourceType) {_ in
                ProfilePictureView(user: user)
            }
            .alert(isPresented: $user.validationError, content: {
                Alert(title: Text(user.regUpdErrorString()), message: Text("Edit Form and Resubmit"), dismissButton: .cancel())
            })
        }
            //.navigationBarHidden(!user.userRegistered)
        .navigationBarTitle(user.userRegistered ? "Edit User" : "Register User")
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(user: User())
    }
}
