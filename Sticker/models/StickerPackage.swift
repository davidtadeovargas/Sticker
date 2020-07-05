//
//  StickerPackage.swift
//  Sticker
//
//  Created by usuario on 04/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation

class StickerPackage: NSObject, NSCoding  {
    
    var name:String?
    var trayImage:Data = UIImagePNGRepresentation(UIImage(named: "image")!)!
    var creator:String?
    var stickers:[StickerModel]?
    var alreadyWhatsapp:Bool!
    
    override init() {
        super.init()
    }

    required init(coder aDecoder: NSCoder) {

        if let name = aDecoder.decodeObject(forKey: "name") as? String {
            self.name = name
        }
        if let trayImage = aDecoder.decodeObject(forKey: "trayImage") as? Data {
            self.trayImage = trayImage
        }
        if let creator = aDecoder.decodeObject(forKey: "creator") as? String {
            self.creator = creator
        }
        if let stickers = aDecoder.decodeObject(forKey: "stickers") as? [StickerModel] {
            self.stickers = stickers
        }
        if let alreadyWhatsapp = aDecoder.decodeObject(forKey: "alreadyWhatsapp") as? Bool {
            self.alreadyWhatsapp = alreadyWhatsapp
        }
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(trayImage, forKey: "trayImage")
        aCoder.encode(creator, forKey: "creator")
        aCoder.encode(stickers, forKey: "stickers")
        aCoder.encode(alreadyWhatsapp, forKey: "alreadyWhatsapp")
    }
}
