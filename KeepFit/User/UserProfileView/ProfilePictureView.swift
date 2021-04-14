//
//  ProfilePictureView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/19/21.
//

import Foundation
import UIKit
import SwiftUI
import MobileCoreServices

struct ProfilePictureView: UIViewControllerRepresentable {
    
    @ObservedObject var user: User
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = user.changingSourceType!
        imagePicker.delegate = user
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

extension User: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.originalImage] as? UIImage {
            self.profilePicture = selectedImage
        } else {
            assertionFailure()
        }
        
        self.changingSourceType = nil
    }
}

struct ProfilePictureView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePictureView(user: User())
    }
}
