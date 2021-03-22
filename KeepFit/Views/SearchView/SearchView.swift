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
    
    //From Sam
    /*func search()
    {
        userResults = HTTPRequester.get10Users(prefix: currentSearch)
    }*/
 
    var body: some View
    {
        ZStack
        {
            VStack
            {
                SearchBar(text: $currentSearch)
                    .padding(.top, 30)
                
                HStack
                {
                    Text("Results:")
                        .font(.system(size: 20))
                        
                }.padding()
                Spacer()
                
                
                
                //From the searchbox template
                /*
                List(todoItems.filter({ searchText.isEmpty ? true : $0.name.contains(searchText) })) { item in
                    Text(item.name)
                }*/
                
                //Replacing items in the template with our variables WIP
                /*
                List(userResults.filter({ currentSearch.isEmpty ? true : $0.username.contains(currentSearch) })) { item in
                    Text(item.name)
                */
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider
{
    static var previews: some View
    {
        SearchView()
    }
}
