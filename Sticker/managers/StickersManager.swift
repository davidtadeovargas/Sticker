//
//  StickerManager.swift
//  Sticker
//
//  Created by usuario on 04/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation

class StickersManager {
    
    static let shared = StickersManager()
    
    var dicSticker : NSMutableDictionary = [:]
    
    private init() {
    }
    
    func getAllPackagesForKey(key:String) -> [StickerPackage] {
        
        //Get all the custom packages
        let defaults = UserDefaults.standard
        var packages:[StickerPackage]
        if(defaults.object(forKey: key) != nil){
            let decoded  = defaults.object(forKey: key) as! Data
            packages = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [StickerPackage]
        }
        else{
            packages = []
        }
        
        return packages
    }
    
    func getAllCustomPackages() -> [StickerPackage] {
        let packages:[StickerPackage] = self.getAllPackagesForKey(key:"custom_stickers")
        return packages
    }
    
    func addCustomPackage(name:String, creator:String) -> StickerPackage{
        
        let StickerPackage_ = StickerPackage()
        StickerPackage_.name = name
        StickerPackage_.creator = creator
        
        self.addCustomPackage(StickerPackage: StickerPackage_)
        
        return StickerPackage_
    }
    
    func addCustomPackage(StickerPackage:StickerPackage){
        var packages = self.getAllCustomPackages()
        packages.append(StickerPackage)
        self.updateCustomPackage(customPackages: packages)
    }
    
    func updateCustomPackage(previousName:String, name:String, creator:String){
        let packages:[StickerPackage] = self.getAllCustomPackages()
        var StickerPackageG:StickerPackage?
        for StickerPackage in packages {
            if(StickerPackage.name==previousName){
                StickerPackageG?.name = name
                StickerPackageG?.creator = creator
                break
            }
        }
        self.updateCustomPackage(customPackages: packages)
    }
    
    func getCustomPackageForName(name:String) -> StickerPackage? {
        
        let packages:[StickerPackage] = self.getAllCustomPackages()
        var StickerPackageG:StickerPackage?
        for StickerPackage in packages {
            if(StickerPackage.name==name){
                StickerPackageG = StickerPackage
                break
            }
        }
        return StickerPackageG
    }
    
    func updateCustomPackage(customPackages:[StickerPackage]){
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: customPackages)
        let defaults = UserDefaults.standard
        defaults.set(encodedData, forKey: "custom_stickers")
    }
    
    
    func updateSticker(packageName:String, StickerModel:StickerModel){
        
        let stickers = self.getAllCustomPackages()
        for StickerPackage in stickers {
            if(StickerPackage.name==packageName){
                let innerStickers:[StickerModel]? =  StickerPackage.stickers
                for StickerModel_ in innerStickers! as [StickerModel] {
                    if(StickerModel_.id==StickerModel.id){
                        StickerModel_.image = StickerModel.image
                        StickerModel_.subcate = StickerModel.subcate
                        break
                    }
                }
            }
            break
        }
        self.updateCustomPackage(customPackages: stickers)
    }
    
    func deleteSticker(packageName:String,id:String){
        let stickers = self.getAllCustomPackages()
        for StickerPackage in stickers {
            if(StickerPackage.name==packageName){
                var innerStickers:[StickerModel]? =  StickerPackage.stickers
                var x = 0
                for StickerModel_ in innerStickers! as [StickerModel] {
                    if(StickerModel_.id==id){
                        innerStickers?.remove(at: x)
                        break
                    }
                    x = x + 1
                }
            }
        }
        self.updateCustomPackage(customPackages: stickers)
    }
    
    func deletePackage(name:String){
        var stickers = self.getAllCustomPackages()
        var x = 0
        for StickerPackage in stickers {
            if(StickerPackage.name==name){
                stickers.remove(at: x)
            }
            x += 1
        }
        self.updateCustomPackage(customPackages: stickers)
    }
}
