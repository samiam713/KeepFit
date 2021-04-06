//
//  CategoriesView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/22/21.
//

import SwiftUI

let rainbow: [Color] = [
    .red, .orange, .yellow, .green, .blue, .purple, .init(red: 78/255, green: 14/255, blue: 120/255)
]

struct CategoriesView: View {
    var body: some View {
        GeometryReader {(proxy: GeometryProxy) in
            VStack {
                Spacer()
                ForEach(WorkoutCategory.allCases.indices) {(i: Int) in
                    NavigationLink(destination: LazyView({CategoryView(category: WorkoutCategory.allCases[i])})) {
                        Text(WorkoutCategory.allCases[i].rawValue)
                            .bold()
                            .foregroundColor(.black)
                            .frame(width: proxy.size.width*0.7, height: proxy.size.height/CGFloat(WorkoutCategory.allCases.count)-25, alignment: .center)
                            .background(RoundedRectangle(cornerRadius: 25).foregroundColor(rainbow[i%rainbow.count]))
                    }
                    .centered()
                    Spacer()
                }
            }
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}
