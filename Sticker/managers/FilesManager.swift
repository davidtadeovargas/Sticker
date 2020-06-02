//
//  FilesManager.swift
//  Sticker
//
//  Created by usuario on 02/06/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation


class FilesManager {
    
    static let shared = FilesManager()
    
    
    private init() {
    }
    
    func removeFileFromdDocumentDirectory(fileName:String) throws {
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                   includingPropertiesForKeys: nil,
                                                                   options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
        for fileURL in fileURLs {
            let fileNameURL = (fileURL.absoluteString as NSString).lastPathComponent
            print("FilesManager: fileNameURL = \(fileNameURL)")
            if fileNameURL == fileName {
                try FileManager.default.removeItem(at: fileURL)
                break
            }
        }
    }
    
    func fileExistsFromdDocumentDirectory(fileName:String) throws -> Bool {
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                   includingPropertiesForKeys: nil,
                                                                   options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
        for fileURL in fileURLs {
            let fileNameURL = (fileURL.absoluteString as NSString).lastPathComponent
            print("FilesManager: fileNameURL = \(fileNameURL)")
            if fileNameURL == fileName {
                return true
            }
        }
        
        return false
    }
    
    func getFileFromDocumentDirectoryPath(fileName:String) throws -> URL? {
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                   includingPropertiesForKeys: nil,
                                                                   options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
        for fileURL in fileURLs {
            let fileNameURL = (fileURL.absoluteString as NSString).lastPathComponent
            print("FilesManager: fileNameURL = \(fileNameURL)")
            if fileNameURL == fileName {
                return fileURL
            }
        }
        
        return nil
    }
    
    func getDocumentDirectoryPath() -> String {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsUrl.absoluteString
    }
}
