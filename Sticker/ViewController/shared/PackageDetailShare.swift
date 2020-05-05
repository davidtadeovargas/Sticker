//
//  PackageDetailShare.swift
//  Sticker
//
//  Created by usuario on 05/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation

class PackageDetailShare {
    
    static let shared = PackageDetailShare()
    
    var StickerPackage:StickerPackage?
    
    private init() {
    }
}
