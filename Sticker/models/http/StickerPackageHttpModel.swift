//
//  StickerPackageHttpModel.swift
//  Sticker
//
//  Created by usuario on 08/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation

class StickerPackageHttpModel: NSObject, NSCoding {
    
    var categoryName:String!
    var stickerPack:[StickerInnerPackHttpModel]!
    
    override init(){
    }
    
    required init(coder aDecoder: NSCoder) {

        if let categoryName = aDecoder.decodeObject(forKey: "categoryName") as? String {
            self.categoryName = categoryName
        }

        if let stickerPack = aDecoder.decodeObject(forKey: "stickerPack") as? [StickerInnerPackHttpModel]? {
            self.stickerPack = stickerPack
        }
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(categoryName, forKey: "categoryName")
        aCoder.encode(stickerPack, forKey: "stickerPack")
    }
}
