//
//  ExploreView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/21/21.
//

import SwiftUI

struct ExploreView: View {
    @ObservedObject var currentUser = User.currentUser
    
    var body: some View
    {
        VStack {
            if currentUser.following.isEmpty {
                Text("No friends!🤷🏼‍♂️")
                    .centered()
            } else {
                List(currentUser.following) {(userPreview: UserPreview) in
                    UserPreviewView.createNavigationLink(userPreview: userPreview)
                }
            }
        }
        .onAppear(perform: currentUser.updateFollowing)
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
