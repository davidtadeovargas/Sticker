//
//  Sticker.swift
//  Sticker
//
//  Created by usuario on 04/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation


class StickerModel: NSObject, NSCoding {
    
    var id:String?
    var image:String?
    var subcate:String?
    
    override init() {
        super.init()
    }

    required init(coder aDecoder: NSCoder) {

        if let id = aDecoder.decodeObject(forKey: "id") as? String {
            self.id = id
        }

        if let image = aDecoder.decodeObject(forKey: "len") as? String {
            self.image = image
        }
        
        if let subcate = aDecoder.decodeObject(forKey: "len") as? String {
            self.subcate = subcate
        }

    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(subcate, forKey: "subcate")
    }
}