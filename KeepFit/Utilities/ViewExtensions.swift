//
//  ViewExtensions.swift
//  KeepFit
//
//  Created by Samuel Donovan on 4/30/21.
//

import Foundation
import SwiftUI

// THIS WAS A FAILURE
extension Section where Parent == Text, Content: View, Footer == EmptyView {
    init(headerS: String, content: () -> Content) {
        self.init(header: Text(headerS), content: content)
    }
}
