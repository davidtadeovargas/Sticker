//
//  PackageDetailUIShare.swift
//  Sticker
//
//  Created by usuario on 13/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation

class PackageDetailUIShare {
    
    static let shared = PackageDetailUIShare()
    
    var StickerPackageHttpModel_:StickerPackageHttpModel?
    var data:[AnyObject]? = nil
    var comesFrom:String? = nil
    
    private init() {
    }
}
