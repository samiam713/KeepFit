//
//  KeepFitLogoView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/20/21.
//

import SwiftUI

struct KeepFitLogoView: View {
    var body: some View {
        HStack {
            Text("Keep")
                .font(.largeTitle)
                .foregroundColor(.primary)
            Text("Fit")
                .font(.largeTitle)
                .foregroundColor(.blue)
        }
    }
}

struct KeepFitLogoView_Previews: PreviewProvider {
    static var previews: some View {
        KeepFitLogoView()
    }
}
