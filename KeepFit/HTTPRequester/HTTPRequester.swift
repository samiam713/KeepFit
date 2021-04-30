//
//  HTTPRequester.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/19/21.
//

import Foundation
import UIKit

enum HTTPRequester {
    static let serverIP = "169.254.224.48"
    // static let serverIP = "ec2-18-225-9-181.us-east-2.compute.amazonaws.com"
    static let serverPort = 8000
    
    static let encoder = JSONEncoder()
    static let decoder = JSONDecoder()
    
    static let timeoutDeadline: TimeInterval = 30
    
    static func getURL(path: String, queries: [URLQueryItem] = []) -> URL {
        var components = URLComponents()
        
        components.scheme = "http"
        components.host = serverIP
        components.port = serverPort
        components.path = "/api/" + path
        
        if !queries.isEmpty {components.queryItems = queries}
        
        return components.url!
    }
}
