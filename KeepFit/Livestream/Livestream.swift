//
//  Livestream.swift
//  KeepFit
//
//  Created by Samuel Donovan on 4/30/21.
//

import Foundation
import UIKit

class Livestream: Encodable {
    
    static var livestreamStore: [Livestream] = {HTTPRequester.getLivestreams()}()
    
    static func add(livestream: Livestream) {
        livestreamStore.append(livestream)
        HTTPRequester.publishLivestream(livestream: livestream)
    }

    let id: String
    let creatorID: String
    let url: URL
    let description: String
    let date: Date
    
    func creator() -> UserPreview {UserPreview.getUserPreview(id: creatorID)}
    
    func open() {UIApplication.shared.open(url)}
    
    init(url: URL, description: String, date: Date) {
        self.id = UUID().uuidString
        self.creatorID = User.currentUser.id
        self.url = url
        self.description = description
        self.date = date
    }
    
}
