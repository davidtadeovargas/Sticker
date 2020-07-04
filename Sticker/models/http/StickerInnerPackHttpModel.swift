//
//  StickerInnerPackHttpModel.swift
//  Sticker
//
//  Created by usuario on 08/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation

class StickerInnerPackHttpModel: NSObject, NSCoding {
    
    var identifier:String!
    var isWhitelisted:String!
    var licenseAgreementWebsite:String!
    var name:String!
    var privacyPolicyWebsite:String!
    var publisher:String!
    var publisherEmail:String!
    var publisherWebsite:String!
    var stickers:[StickerHttpModel]!
    var stickersAddedIndex:String!
    var totalSize:String!
    var trayImageFile:String!
    var trayImageUri:String!
    var alreadyWhatsapp:Bool!
    
    override init(){
    }
    
    required init(coder aDecoder: NSCoder) {

        if let identifier = aDecoder.decodeObject(forKey: "identifier") as? String {
            self.identifier = identifier
        }
        if let isWhitelisted = aDecoder.decodeObject(forKey: "isWhitelisted") as? String {
            self.isWhitelisted = isWhitelisted
        }
        if let licenseAgreementWebsite = aDecoder.decodeObject(forKey: "licenseAgreementWebsite") as? String {
            self.licenseAgreementWebsite = licenseAgreementWebsite
        }
        if let name = aDecoder.decodeObject(forKey: "name") as? String {
            self.name = name
        }
        if let privacyPolicyWebsite = aDecoder.decodeObject(forKey: "privacyPolicyWebsite") as? String {
            self.privacyPolicyWebsite = privacyPolicyWebsite
        }
        if let publisher = aDecoder.decodeObject(forKey: "publisher") as? String {
            self.publisher = publisher
        }
        if let publisherEmail = aDecoder.decodeObject(forKey: "publisherEmail") as? String {
            self.publisherEmail = publisherEmail
        }
        if let publisherWebsite = aDecoder.decodeObject(forKey: "publisherWebsite") as? String {
            self.publisherWebsite = publisherWebsite
        }
        if let stickers = aDecoder.decodeObject(forKey: "stickers") as? [StickerHttpModel] {
            self.stickers = stickers
        }
        if let stickersAddedIndex = aDecoder.decodeObject(forKey: "stickersAddedIndex") as? String {
            self.stickersAddedIndex = stickersAddedIndex
        }
        if let totalSize = aDecoder.decodeObject(forKey: "totalSize") as? String {
            self.totalSize = totalSize
        }
        if let trayImageFile = aDecoder.decodeObject(forKey: "trayImageFile") as? String {
            self.trayImageFile = trayImageFile
        }
        if let trayImageUri = aDecoder.decodeObject(forKey: "trayImageUri") as? String {
            self.trayImageUri = trayImageUri
        }
        if let alreadyWhatsapp = aDecoder.decodeObject(forKey: "alreadyWhatsapp") as? Bool {
            self.alreadyWhatsapp = alreadyWhatsapp
        }
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(identifier, forKey: "identifier")
        aCoder.encode(isWhitelisted, forKey: "isWhitelisted")
        aCoder.encode(licenseAgreementWebsite, forKey: "licenseAgreementWebsite")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(privacyPolicyWebsite, forKey: "privacyPolicyWebsite")
        aCoder.encode(publisher, forKey: "publisher")
        aCoder.encode(publisherEmail, forKey: "publisherEmail")
        aCoder.encode(publisherWebsite, forKey: "publisherWebsite")
        aCoder.encode(stickers, forKey: "stickers")
        aCoder.encode(stickersAddedIndex, forKey: "stickersAddedIndex")
        aCoder.encode(totalSize, forKey: "totalSize")
        aCoder.encode(trayImageFile, forKey: "trayImageFile")
        aCoder.encode(trayImageUri, forKey: "trayImageUri")
        aCoder.encode(alreadyWhatsapp, forKey: "alreadyWhatsapp")
    }
}
