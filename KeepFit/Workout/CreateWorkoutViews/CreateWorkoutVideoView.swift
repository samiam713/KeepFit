//
//  CreateWorkoutVideoView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/21/21.
//

import SwiftUI
import MobileCoreServices

struct CreateWorkoutVideoView: UIViewControllerRepresentable {
    
    let workout: Workout
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        imagePicker.sourceType = .camera
        imagePicker.cameraCaptureMode = .video
        imagePicker.delegate = workout
        imagePicker.videoMaximumDuration = 60
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

// delegate for the ImagePickerControllerDelegate
extension Workout: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // delegate function
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            if FileManager.bytesForLocalURL(localURL: videoURL)! <= Workout.maxWorkoutVideoBytes {
                print(videoURL.absoluteURL)
                self.creatingVideoURL = videoURL
            } else {
                // Video exceeds \(Workout.maxWorkoutVideoBytes) bytes
                creationErrorMessage = "Video Too Large (exceeds \(Workout.maxWorkoutVideoBytes) bytes)"
            }
        } else {
            // Video Recording Error
            creationErrorMessage = "Video Recording Error"
        }
        
        self.recordingVideo = false
    }
    
}

