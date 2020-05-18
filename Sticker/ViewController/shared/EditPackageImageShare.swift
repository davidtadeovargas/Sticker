//
//  EditPackageImageShare.swift
//  Sticker
//
//  Created by usuario on 06/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation

class EditPackageImageShare {
    
    static let shared = EditPackageImageShare()
    
    var UIImageView:UIImageView?
    var UIViewController:UIViewController?
    var UIImageView2:UIImageView?
    var trayImage:Bool = false
    var name:String?
    var stickerImage = false
    var StickerPackage:StickerPackage?
    var stickerId:Int?
    var data:Data?
    var StickerModel:StickerModel?
    
    private init() {
    }
}
