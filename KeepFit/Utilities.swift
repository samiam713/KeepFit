//
//  Utilities.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/19/21.
//

import Foundation
import UIKit
import SwiftUI

extension UIImagePickerController.SourceType: Identifiable {
    public var id: Int {self.rawValue}
}

extension Date {
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy"
        return formatter
    }()
    
    private static var hourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        // "HH:mm:ss z"
        return formatter
    }()
    
    func dateString() -> String {
        return Self.dateFormatter.string(from: self)
    }
    
    func secondString() -> String {
        return Self.hourFormatter.string(from: self)
    }
}

extension View {
    func centered() -> some View {
        return HStack {
            Spacer()
            self
            Spacer()
        }
    }
}

extension Color {
    static let contrast = Color("Contrast")
    static let noncontrast = Color("NonContrast")
}
