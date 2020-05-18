//
//  Sticker.swift
//  Sticker
//
//  Created by usuario on 04/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation


class StickerModel: NSObject, NSCoding {
    
    var id:Int?
    var image:Data?
    var alreadyImageSet:Bool?
    var subcate:String?
    
    override init() {
        super.init()
    }

    required init(coder aDecoder: NSCoder) {

        if let id = aDecoder.decodeObject(forKey: "id") as? Int {
            self.id = id
        }

        if let image = aDecoder.decodeObject(forKey: "image") as? Data {
            self.image = image
        }
        
        if let subcate = aDecoder.decodeObject(forKey: "len") as? String {
            self.subcate = subcate
        }
        if let alreadyImageSet = aDecoder.decodeObject(forKey: "alreadyImageSet") as? Bool {
            self.alreadyImageSet = alreadyImageSet
        }
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(subcate, forKey: "subcate")
        aCoder.encode(alreadyImageSet, forKey: "alreadyImageSet")
    }
}
