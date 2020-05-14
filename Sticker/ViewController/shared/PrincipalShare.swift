//
//  PrincipalShare.swift
//  Sticker
//
//  Created by usuario on 13/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation

class PrincipalShare {
    
    static let shared = PrincipalShare()
    
    var StickerPackageHttpModelArray:[StickerPackageHttpModel]? = nil
    
    private init() {
    }
}
