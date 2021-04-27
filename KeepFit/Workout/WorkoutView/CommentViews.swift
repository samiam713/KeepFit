//
//  WorkoutCommentView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 4/27/21.
//

import SwiftUI

struct CreateWorkoutCommentView: View {
    
    static func createNavigationLink(workout: Workout) -> some View {
        return NavigationLink(destination: LazyView({CreateWorkoutCommentView(workout: workout)})) {
            Label("Add Comment", systemImage: "plus.bubble.fill")
            .centered()
            .foregroundColor(.contrast)
            .padding()
                .background(RoundedRectangle(cornerRadius: 5.0).stroke().foregroundColor(.contrast))
            .padding()
        }
    }
    
    let workout: Workout
    
    @State var published = false
    @State var comment = ""
    
    @State var errorMessage: String? = nil
    
    func attemptPublish() {
        guard comment != "" else {errorMessage = "Nice try you bastard...write some stuff"; return}
        
        published = true
        workout.add(commentString: comment)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Comment")) {
                TextEditor(text: $comment)
                Button("Hide Keyboard", action: self.hideKeyboard)
            }
            Section() {
                Button("Publish Comment", action: attemptPublish)
                    .disabled(published)
            }
        }
        .alert(item: $errorMessage, content: {(errorMessage: String) in
            Alert(title: Text("Comment Error"), message: Text(errorMessage), dismissButton: .cancel())
        })
        .navigationTitle("New Comment on \(workout.title)")
    }
}

struct WorkoutCommentView: View {
    
    let comment: Workout.Comment
    
    static func createNavigationLink(comment: Workout.Comment) -> some View {
        return NavigationLink(destination: LazyView({WorkoutCommentView(comment: comment)})) {
            Label("View Comment by \(comment.userPreview().username)", systemImage: "text.bubble.fill")
            .centered()
            .foregroundColor(.contrast)
            .padding()
            .background(RoundedRectangle(cornerRadius: 5.0).stroke().foregroundColor(.contrast))
            .padding()
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Comment")) {
                Text(comment.comment)
                    .multilineTextAlignment(.center)
            }
            Section(header: Text("Commentor")) {
                UserPreviewView.createNavigationLink(userPreview: comment.userPreview())
            }
        }
        .navigationTitle("\(comment.userPreview().username)'s Comment")
    }
}
