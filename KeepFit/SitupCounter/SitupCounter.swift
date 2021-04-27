//
//  SitupCounter.swift
//  KeepFit
//
//  Created by Samuel Donovan on 4/27/21.
//

import Foundation
import AVFoundation

class SitupCounter: ObservableObject {
    @Published var situpCount = 0
    @Published var doingSitups = false
    
    var player: AVAudioPlayer? = nil
    
    var timer: Timer? = nil
    
    func restart() {
        restartAudio()
        restartTimer()
        doingSitups = true
    }
    
    func stop() {
        stopAudio()
        stopTimer()
        doingSitups = false
    }
    
    func restartAudio() {
        
        if let player = player {
            player.play(atTime: 0)
        }
        print(try! FileManager.default.subpathsOfDirectory(atPath: Bundle.main.bundlePath))
        
        guard let url = Bundle.main.url(forResource: "TurnMySwagOn", withExtension: "mp3") else {
            print("Failure")
            return
        }
        
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopAudio() {
        player?.pause()
    }
    
    func restartTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(Self.timerUpdate), userInfo: nil, repeats: true)
    }
    
    @objc func timerUpdate() {self.situpCount += 1}
    
    func stopTimer() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
    }
    
    deinit {
        stopTimer()
    }
}

