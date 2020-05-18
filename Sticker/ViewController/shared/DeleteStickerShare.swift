//
//  DeleteStickerShare.swift
//  Sticker
//
//  Created by usuario on 18/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation

class DeleteStickerShare {
 
    static let shared = DeleteStickerShare()
    
    var imageData:Data?
    var name:String?
    var stickerId:Int?
    var UIImageView:UIImageView?
    
    private init() {
    }
}
