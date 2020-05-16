//
//  StickerHttpModel.swift
//  Sticker
//
//  Created by usuario on 08/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation

class StickerHttpModel: NSObject, NSCoding {
    
    var imageFileName:String!
    var size:String!
    var uri:String!
    
    
    
    override init(){
    }
    
    required init(coder aDecoder: NSCoder) {

        if let imageFileName = aDecoder.decodeObject(forKey: "imageFileName") as? String {
            self.imageFileName = imageFileName
        }
        if let size = aDecoder.decodeObject(forKey: "size") as? String {
            self.size = size
        }
        if let uri = aDecoder.decodeObject(forKey: "uri") as? String {
            self.uri = uri
        }
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(imageFileName, forKey: "imageFileName")
        aCoder.encode(size, forKey: "size")
        aCoder.encode(uri, forKey: "uri")
    }
}
