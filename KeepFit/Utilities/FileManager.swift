//
//  FileManager.swift
//  KeepFit
//
//  Created by Samuel Donovan on 4/27/21.
//

import Foundation

extension FileManager {
    static func bytesForLocalURL(localURL: URL) -> Int? {
        let filePath = localURL.path
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
            if let fileSize = fileAttributes[FileAttributeKey.size] as? NSNumber {
                return fileSize.intValue
            } else {
                print("Failed to get a size attribute from path: \(filePath)")
            }
        } catch {
            print("Failed to get file attributes for local path: \(filePath) with error: \(error)")
        }
        return nil
    }
}
