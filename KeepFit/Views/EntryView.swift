//
//  ContentView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/19/21.
//

import SwiftUI

extension String: Identifiable {
    public var id: String {return self}
}

class EntryViewController: ObservableObject {
    
    @Published var username = ""
    @Published var password = ""
    
    @Published var attemptLoginError: String? = nil
    
    func attemptLogin() {
        let result = HTTPRequester.attemptLogin(username: username, password: password)
        switch result {
        case .success(let user):
            User.currentUser = user
            keepFitAppController.currentView = .mainView
        case .badPassword:
            attemptLoginError = "Incorrect Password for User \(username)"
        case .badUsername:
            attemptLoginError = "Couldn't Find User with Username \(username)"
        }
    }
    
    func startRegisteringNewUser() {
        keepFitAppController.currentView = .registering
        print(keepFitAppController.currentView)
    }
}

struct EntryView: View {
    
    @ObservedObject var entryViewController = EntryViewController()
    
    var body: some View {
        GeometryReader {(proxy: GeometryProxy) in
            NavigationView {
                VStack {
                    Spacer()
                    KeepFitLogoView()
                    Spacer()
                    VStack {
                        TextField("Username", text: $entryViewController.username)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        SecureField("Password", text: $entryViewController.password)
                        Button(action:
                                self.entryViewController.attemptLogin
                        ) {
                            Text("Login")
                        }
                    }
                    .frame(width: proxy.size.width*0.6, alignment: .center)
                    Spacer()
                    Button(action: entryViewController.startRegisteringNewUser) {
                        Label("Register New User", systemImage: "person.fill.badge.plus")
                    }
                    Spacer()
                }
                .frame(width: proxy.size.width)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .alert(item: $entryViewController.attemptLoginError) {(loginErrorString: String) in
                    return Alert(title: Text("Login Error"), message: Text(loginErrorString), dismissButton: .cancel())
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView()
    }
}
