//
//  StickerManager.swift
//  Sticker
//
//  Created by usuario on 04/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation

class StickerManager {
    
    static let shared = StickerManager()
    
    var dicSticker : NSMutableDictionary = [:]
    
    private init() {
    }
    
    func getAllStickers(packageName:String) -> [StickerPackage] {
        
        //Get all the custom packages
        let defaults = UserDefaults.standard
        let packages:[StickerPackage] = defaults.object(forKey: "custom_stickers") as! [StickerPackage]
        return packages
    }
    
    func addPackageToCustomStickers(StickerPackage:StickerPackage){
        let defaults = UserDefaults.standard
        var packages:[StickerPackage] = defaults.object(forKey: "custom_stickers") as! [StickerPackage]
        packages.append(StickerPackage)
        defaults.set(packages, forKey: "custom_stickers")
    }
    
    func getPackageFromCustomStickers(name:String) -> StickerPackage? {
        
        //Get all the custom packages
        let defaults = UserDefaults.standard
        let packages:[StickerPackage] = defaults.object(forKey: "custom_stickers") as! [StickerPackage]
        
        //Search for the package name
        var StickerPackageG:StickerPackage?
        for StickerPackage in packages {
            if(StickerPackage.name==name){
                StickerPackageG = StickerPackage
                break
            }
        }
        
        return StickerPackageG
    }
    
    
    func updateSticker(packageName:String, StickerModel:StickerModel){
        
        let StickerPackage:StickerPackage? = self.getPackageFromCustomStickers(name: packageName)
        if(StickerPackage != nil){
            var StickerModel:StickerModel? = self.findStickerById(id: StickerModel.id!, StickerPackage: StickerPackage!)
            if(StickerModel!=nil){
                StickerModel
            }
        }
    }
    
    func findStickerById(id:String, StickerPackage:StickerPackage) -> StickerModel? {
        
        let stickers:[StickerModel] = StickerPackage.stickers!
        var StickerModelG:StickerModel?
        for StickerModel in stickers {
            if(StickerModel.id==id){
                StickerModelG = StickerModel
            }
        }
        return StickerModelG
    }
    
    func deleteSticker(id:String){
        
    }
    
    func deletePackage(name:String){
        
    }
}
