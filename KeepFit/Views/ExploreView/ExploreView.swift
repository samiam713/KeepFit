//
//  ExploreView.swift
//  KeepFit
//
//  Created by Samuel Donovan on 3/21/21.
//

import SwiftUI
import AVKit

struct ExploreView: View
{
    func createThumbnailOfVideoFromRemoteUrl(url: String) -> UIImage? {
        let asset = AVAsset(url: URL(string: "https://bit.ly/swswift")!)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        //Can set this to improve performance if target size is known before hand
        //assetImgGenerate.maximumSize = CGSize(width,height)
        let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
          print(error.localizedDescription)
          return nil
        }
    }
    
    var body: some View
    {
        Form
        {
            VStack
            {
                Section(header: Text("Latest Videos and Livestreams"))
                {
                    
                }
                
                VideoPlayer(player: AVPlayer(url:  URL(string: "https://bit.ly/swswift")!))
                    .frame(height: 400)
            }
        }
    }
}

struct ExploreView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ExploreView()
    }
}
