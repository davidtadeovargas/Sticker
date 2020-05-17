//
//  DetailOfPackageShare.swift
//  Sticker
//
//  Created by usuario on 15/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation

class DetailOfPackageShare {
    
    static let shared = DetailOfPackageShare()
    
    var StickerInnerPackHttpModel:StickerInnerPackHttpModel? = nil
    var comesFrom:String? = nil
    
    private init() {
    }
}
