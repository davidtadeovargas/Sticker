//
//  RequestsFactor.swift
//  Sticker
//
//  Created by usuario on 12/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation

class RequestsFactor {
    
    static let shared = RequestsFactor()
    
    private var StickerPackageRequest_:StickerPackageRequest? = nil
    
    private init() {
    }
    
    
    func getStickerPackageRequest() -> StickerPackageRequest{
        if(StickerPackageRequest_ == nil){
            StickerPackageRequest_ = StickerPackageRequest()
        }
        return StickerPackageRequest_!
    }
}
