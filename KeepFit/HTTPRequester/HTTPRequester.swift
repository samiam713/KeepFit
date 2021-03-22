//
//  HTTPRequester.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/19/21.
//

import Foundation
import UIKit

enum HTTPRequester {
    static let serverIP = "localhost"
    static let serverPort = 8000
    
    static let encoder = JSONEncoder()
    static let decoder = JSONDecoder()
    
    static func getURL(path: String) -> URLComponents {
        var components = URLComponents()
        
        components.scheme = "http"
        components.host = serverIP
        components.port = serverPort
        components.path = path
        
        return components
    }
}
