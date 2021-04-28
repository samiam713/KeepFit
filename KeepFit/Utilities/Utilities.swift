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

struct LazyView<T: View>: View {
    @State var view: T?
    
    let closure: () -> T
    
    init(_ closure: @escaping () -> T) {
        self.closure = closure
    }
    
    var body: some View {
        Group {
            if view != nil {
                view
            } else {
                Text("Loading...")
            }
        }
        .onAppear() {
            view = closure()
            print("Lazily Loaded View")
        }
    }
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, content: (Self) -> Content) -> some View {
        if condition {
            content(self)
        }
        else {
            self
        }
    }
}

//#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
//#endif

extension Double {
    func twoDecimalPlaces() -> String {String(format: "%.2f", self)}
}

class KeyboardObserver: NSObject, ObservableObject {
    static let observer = KeyboardObserver()
    
    @Published var keyboardActive = false
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyBoardWillShow(notification: Notification) {
        keyboardActive = true
    }

    @objc func keyBoardDidHide(notification: Notification) {
        keyboardActive = false
    }
}

extension Sequence {
    func findExtremum(useFirst: (Element,Element) -> Bool) -> Element? {
        
        var iterator = self.makeIterator()
        guard var current = iterator.next() else {return nil}
        
        while let potential = iterator.next() {
            if useFirst(potential,current) {
                current = potential
            }
        }
        
        return current
    }
}
