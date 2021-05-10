//
//  FollowingListView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 5/7/21.
//

import SwiftUI

struct FollowingListView: View {
    
    static func createNavigationLink() -> some View {
        NavigationLink("View Following", destination: Self())
    }
    
    @ObservedObject var user = User.currentUser
    
    init() {
        print("MAYBE UNCOMMENT BELOW MAYBE NOT")
        // user.updateFollowing()
    }
    
    var body: some View {
        List(user.following) {(userPreview: UserPreview) in
            UserPreviewView.createNavigationLink(userPreview: userPreview)
        }
        .navigationBarTitle(Text("Following"))
        .onAppear(perform: user.updateFollowing)
    }
}

struct FollowingListView_Previews: PreviewProvider {
    static var previews: some View {
        FollowingListView()
    }
}
