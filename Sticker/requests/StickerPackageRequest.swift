//
//  StickerPackageRequest.swift
//  Sticker
//
//  Created by usuario on 08/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation
import SwiftyJSON

class StickerPackageRequest: BaseRequest {
    
    var onFinish:((DataHttpModel)->Void)? = nil
    
    
    init() {
        
        super.init(url: Constants.shared.STICKERS_URL)
        
        self.onReceive =  {json in
            
            let DataHttpModel_ = DataHttpModel()
            DataHttpModel_.data = [StickerPackageHttpModel]()
            
            let data = json["data"]
            for (_,subJson):(String, JSON) in data {
                
                print("Proccessing categoryName \(subJson["categoryName"].stringValue)")
                
                let StickerPackageHttpModel_ = StickerPackageHttpModel()
                StickerPackageHttpModel_.categoryName = subJson["categoryName"].stringValue
                StickerPackageHttpModel_.stickerPack = [StickerInnerPackHttpModel]()
                
                let stickerPack = subJson["stickerPack"]
                for (_,subJson2):(String, JSON) in stickerPack {
                    
                    let StickerInnerPackHttpModel_ = StickerInnerPackHttpModel()
                    StickerInnerPackHttpModel_.identifier = subJson2["identifier"].stringValue
                    StickerInnerPackHttpModel_.isWhitelisted = subJson2["isWhitelisted"].stringValue
                    StickerInnerPackHttpModel_.licenseAgreementWebsite = subJson2["licenseAgreementWebsite"].stringValue
                    StickerInnerPackHttpModel_.name = subJson2["name"].stringValue
                    StickerInnerPackHttpModel_.privacyPolicyWebsite = subJson2["privacyPolicyWebsite"].stringValue
                    StickerInnerPackHttpModel_.publisher = subJson2["publisher"].stringValue
                    StickerInnerPackHttpModel_.publisherEmail = subJson2["publisherEmail"].stringValue
                    StickerInnerPackHttpModel_.publisherWebsite = subJson2["publisherWebsite"].stringValue
                    StickerInnerPackHttpModel_.stickersAddedIndex = subJson2["stickersAddedIndex"].stringValue
                    StickerInnerPackHttpModel_.totalSize = subJson2["totalSize"].stringValue
                    StickerInnerPackHttpModel_.trayImageFile = subJson2["trayImageFile"].stringValue
                    StickerInnerPackHttpModel_.trayImageUri = subJson2["trayImageUri"].stringValue
                    StickerInnerPackHttpModel_.stickers = [StickerHttpModel]()
                    StickerPackageHttpModel_.stickerPack!.append(StickerInnerPackHttpModel_)
                    
                    let stickers = subJson2["stickers"]
                    for (_,subJson3):(String, JSON) in stickers {
                        
                        let StickerHttpModel_ = StickerHttpModel()
                        StickerHttpModel_.imageFileName = subJson3["imageFileName"].stringValue
                        StickerHttpModel_.size = subJson3["size"].stringValue
                        StickerHttpModel_.uri = subJson3["uri"].stringValue
                        StickerInnerPackHttpModel_.stickers!.append(StickerHttpModel_)
                    }
                }
                
                DataHttpModel_.data?.append(StickerPackageHttpModel_)
            }
            
            if(self.onFinish != nil){
                self.onFinish!(DataHttpModel_)
            }
        }
    }
}
