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
        livestreams.append(livestream)
        HTTPRequester.publishLivestream(livestream: livestream)
    }
}

class Livestream: Codable, Identifiable {
    
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
    
    enum Key: String, CodingKey {
        case id, creatorID, url, description, date
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
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(creatorID, forKey: .creatorID)
        try container.encode(url.absoluteString, forKey: .url)
        try container.encode(description, forKey: .description)
        try container.encode(date.timeIntervalSince1970, forKey: .date)
    }
    
}
