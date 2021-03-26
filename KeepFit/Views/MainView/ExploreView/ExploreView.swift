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
            List(currentUser.following()) {(userPreview: UserPreview) in
                UserPreviewView.createNavigationLink(userPreview: userPreview)
            }
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
