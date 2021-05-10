//
//  Livestream.swift
//  KeepFit
//
//  Created by Samuel Donovan on 4/30/21.
//

import Foundation
import UIKit
import SwiftUI

class LivestreamStore: ObservableObject {
    static let singleton = LivestreamStore()
    
    private init() {
        livestreams = HTTPRequester.getLivestreams()
    }
    
    @Published var livestreams: [Livestream]
    
    func refresh() {
        livestreams = HTTPRequester.getLivestreams()
    }
    
    func add(livestream: Livestream) {
        HTTPRequester.publishLivestream(livestream: livestream)
        livestreams.append(livestream)
    }
    
    func delete(livestream: Livestream) {
        HTTPRequester.deleteLivestream(livestream: livestream)
        livestreams.removeAll(where: {$0 == livestream})
    }
}

class Livestream: Codable, Identifiable, ObservableObject, Equatable {
    
    static func ==(lhs: Livestream, rhs: Livestream) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: String
    let creatorID: String
    let url: URL
    let description: String
    let date: Date
    let maximumParticipants: Int
    @Published var joined: Bool
    @Published var errorMessage: String? = nil
    @Published var isDeleted = false
    
    func creator() -> UserPreview {UserPreview.getUserPreview(id: creatorID)}
    
    init(url: URL, description: String, date: Date, maximumParticipants: Int) {
        self.id = UUID().uuidString
        self.creatorID = User.currentUser.id
        self.url = url
        self.description = description
        self.date = date
        self.maximumParticipants = maximumParticipants
        self.joined = false
    }
    
    func attemptToEnter() {
        let entered = HTTPRequester.attemptToEnterLivestream(livestreamID: id)
        if entered {
            joined = true
            open()
        } else {
            errorMessage = "Livestream full"
        }
    }
    
    func delete() {
        LivestreamStore.singleton.delete(livestream: self)
        isDeleted = true
    }
    
    func leave() {
        HTTPRequester.leaveLivestream(livestreamID: id)
        joined = false
    }
    
    func open() {UIApplication.shared.open(url)}
    
    enum Key: String, CodingKey {
        case id, creatorID, url, description, date
        case maximumParticipants, joined
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        id = try container.decode(String.self,forKey: .id)
        creatorID = try container.decode(String.self,forKey: .creatorID)
        let urlString = try container.decode(String.self,forKey: .url)
        url = URL(string: urlString)!
        description = try container.decode(String.self,forKey: .description)
        
        let secondsSince1970 = try container.decode(TimeInterval.self,forKey: .date)
        date = Date(timeIntervalSince1970: secondsSince1970)
        
        self.maximumParticipants = try container.decode(Int.self,forKey: .maximumParticipants)
        self.joined = try container.decode(Bool.self,forKey: .joined)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(creatorID, forKey: .creatorID)
        try container.encode(url.absoluteString, forKey: .url)
        try container.encode(description, forKey: .description)
        try container.encode(date.timeIntervalSince1970, forKey: .date)
        
        try container.encode(maximumParticipants,forKey: .maximumParticipants)
    }
    
}
