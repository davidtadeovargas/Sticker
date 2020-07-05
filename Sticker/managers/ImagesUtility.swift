//
//  FilesManager.swift
//  Sticker
//
//  Created by usuario on 02/06/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation


class ImagesUtility {
    
    static let shared = ImagesUtility()
    
    
    private init() {
    }
    
    func saveDataUIImageToFile(data:Data, fileName:String) throws -> String{
        
        let fileURL = try! FileManager.default
        .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent((fileName))
        .appendingPathExtension("png")
        
        //Save in disk
        try data.write(to: fileURL)
        
        //Return the full path
        return fileURL.path
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
