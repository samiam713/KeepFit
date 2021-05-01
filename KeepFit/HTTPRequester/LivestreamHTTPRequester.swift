//
//  Livestream.swift
//  KeepFit
//
//  Created by Samuel Donovan on 4/30/21.
//

import Foundation

extension HTTPRequester {
    static func publishLivestream(livestream: Livestream) {
        let completionGroup = DispatchGroup()
        completionGroup.enter()
        
        //Create the request
        // TODO: update path
        var request = URLRequest(url: getURL(path: "publishLivestream/"))
        print(request.url!.absoluteString)
        
        // Construct the request
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! encoder.encode(livestream)
        request.timeoutInterval = Self.timeoutDeadline
        
        //Create a URL Session
        
        let dataTask = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            
            //ensure the response status is 200 OK and that there is data
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode), let _ = data else {
                fatalError("Not a valid response")
            }
            
            completionGroup.leave()
        }
        
        dataTask.resume()
        
        completionGroup.wait()
    }
    
    static func getLivestreams() -> [Livestream] {
        let completionGroup = DispatchGroup()
        completionGroup.enter()
        
        //Create the request
        // TODO: update path
        var request = URLRequest(url: getURL(path: "getLivestreams/"))
        print(request.url!.absoluteString)
        
        var livestreams = [Livestream]()
        
        // Construct the request
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.timeoutInterval = Self.timeoutDeadline
        
        //Create a URL Session
        
        let dataTask = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            
            //ensure the response status is 200 OK and that there is data
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode), let data = data else {
                fatalError("Not a valid response")
            }
            
            guard let _livestreams = try? decoder.decode([Livestream].self, from: data) else {
                fatalError("NOT A VALID USER JSON")
            }
            
            livestreams = _livestreams
            completionGroup.leave()
        }
        
        dataTask.resume()
        completionGroup.wait()
        
        return livestreams
    }
}
