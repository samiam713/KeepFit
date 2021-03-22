//
//  SearchView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/21/21.
//

import SwiftUI




struct SearchView: View
{
    @State var currentSearch = ""
    
    @State var userResults = [UserPreview]()
    @State var workoutResults = [Workout]()
    
    func search()
    {
        userResults = HTTPRequester.get10Users(prefix: currentSearch)
    }
 
    var body: some View
    {
        SearchBar(text: $currentSearch)
            .padding(.top, -30)
    }
}

struct SearchView_Previews: PreviewProvider
{
    static var previews: some View
    {
        SearchView()
    }
}
