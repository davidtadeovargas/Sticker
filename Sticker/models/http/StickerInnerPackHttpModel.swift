//
//  StickerInnerPackHttpModel.swift
//  Sticker
//
//  Created by usuario on 08/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation

class StickerInnerPackHttpModel {
    
    var identifier:String?
    var isWhitelisted:String?
    var licenseAgreementWebsite:String?
    var name:String?
    var privacyPolicyWebsite:String?
    var publisher:String?
    var publisherEmail:String?
    var publisherWebsite:String?
    var stickers:[StickerHttpModel]?
    var stickersAddedIndex:String?
    var totalSize:String?
    var trayImageFile:String?
    var trayImageUri:String?
}
