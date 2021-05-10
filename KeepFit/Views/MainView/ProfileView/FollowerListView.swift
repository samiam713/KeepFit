//
//  FollowerListView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 5/7/21.
//

import SwiftUI

struct FollowerListView: View {
    
    static func createNavigationLink() -> some View {
        NavigationLink("View Followers", destination: Self())
    }
    
    let followers: [UserPreview]
    
    init() {
        self.followers = HTTPRequester.getFollowers()
            .map({UserPreview.getUserPreview(id: $0)})
    }
    
    var body: some View {
        List(followers) {(userPreview: UserPreview) in
            UserPreviewView.createNavigationLink(userPreview: userPreview)
        }
        .navigationBarTitle(Text("Followers"))
    }
}

struct FollowerListView_Previews: PreviewProvider {
    static var previews: some View {
        FollowerListView()
    }
}
