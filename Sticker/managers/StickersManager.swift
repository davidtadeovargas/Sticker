//
//  StickerManager.swift
//  Sticker
//
//  Created by usuario on 04/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation

class StickersManager {
    
    let REMOTE_STICKERS_KEY = "remote_stickers"
    
    var packages:[StickerInnerPackHttpModel]? = nil
    
    static let shared = StickersManager()
    
    var dicSticker : NSMutableDictionary = [:]
    
    
    
    
    private init() {
    }
    
    func getAllRemotePackages() -> [StickerInnerPackHttpModel] {
        
        if(packages == nil){
                
            let defaults = UserDefaults.standard
            packages = [StickerInnerPackHttpModel]()
            if(defaults.object(forKey: self.REMOTE_STICKERS_KEY) != nil){
                let decoded  = defaults.object(forKey: self.REMOTE_STICKERS_KEY) as! Data
                packages = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [StickerInnerPackHttpModel]
            }
        }
        
        return packages!
    }
    func addRemotePackage(StickerInnerPackHttpModel_:StickerInnerPackHttpModel) {
        
        var stickers = self.getAllRemotePackages()
        stickers.append(StickerInnerPackHttpModel_)
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: stickers)
        let defaults = UserDefaults.standard
        defaults.set(encodedData, forKey: self.REMOTE_STICKERS_KEY)
        defaults.synchronize()
    }
    func deleteRemotePackage(name:String) {
        
        var stickers = self.getAllRemotePackages()
        var x = 0
        for StickerInnerPackHttpModel in stickers {
            if(StickerInnerPackHttpModel.name == name){
                stickers.remove(at: x)
                break
            }
            x += 1
        }
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: stickers)
        let defaults = UserDefaults.standard
        defaults.set(encodedData, forKey: self.REMOTE_STICKERS_KEY)
        defaults.synchronize()
    }
    func getRemotePackage(name:String) -> StickerInnerPackHttpModel? {
        
        let packages:[StickerInnerPackHttpModel] = self.getAllRemotePackages()
        var StickerInnerPackHttpModel_:StickerInnerPackHttpModel? = nil
        for StickerInnerPackHttpModel in packages {
            if(StickerInnerPackHttpModel.name==name){
                StickerInnerPackHttpModel_ = StickerInnerPackHttpModel
                break
            }
        }
        return StickerInnerPackHttpModel_
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
        var stickers = [StickerModel]()
        
        for x in 1 ... 30 {
            let StickerModel_ = StickerModel()
            StickerModel_.id = x
            StickerModel_.image = UIImagePNGRepresentation(UIImage(named: "add_icon")!)
            StickerModel_.alreadyImageSet = false
            stickers.append(StickerModel_)
        }
        
        StickerPackage_.stickers = stickers
        
        self.addCustomPackage(StickerPackage: StickerPackage_)
        
        return StickerPackage_
    }
    
    
    func addCustomPackage(StickerPackage:StickerPackage){
        var packages = self.getAllCustomPackages()
        packages.append(StickerPackage)
        self.updateCustomPackage(customPackages: packages)
    }
    
    func updateCustomPackageTrayImage(name:String,data:Data){
        let stickers = self.getAllCustomPackages()
        for StickerPackage in stickers {
            if(StickerPackage.name == name){
                StickerPackage.trayImage = data
                break
            }
        }
        self.updateCustomPackage(customPackages: stickers)
    }
    
    func updateCustomPackageStickerImage(name:String,stickerId:Int, data:Data) {
        let stickers = self.getAllCustomPackages()
        for StickerPackage in stickers {
            if(StickerPackage.name == name){
                let stickersModel = StickerPackage.stickers
                for StickerModel in stickersModel! {
                    if(StickerModel.id == stickerId){
                        StickerModel.image = data
                        StickerModel.alreadyImageSet = true
                        break
                    }
                }
                break
            }
        }
        self.updateCustomPackage(customPackages: stickers)
    }
    
    func updateCustomPackage(previousName:String, name:String, creator:String){
        let packages:[StickerPackage] = self.getAllCustomPackages()
        for StickerPackage in packages {
            if(StickerPackage.name==previousName){
                StickerPackage.name = name
                StickerPackage.creator = creator
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
        defaults.synchronize()
    }
    func updateCustomSticker(packageName:String, StickerModel:StickerModel){
        
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
    func deleteCustomSticker(packageName:String,id:Int){
        let stickers = self.getAllCustomPackages()
        for StickerPackage in stickers {
            if(StickerPackage.name==packageName){
                let innerStickers:[StickerModel]? =  StickerPackage.stickers
                var x = 0
                for StickerModel_ in innerStickers! as [StickerModel] {
                    if(StickerModel_.id == id){
                        StickerModel_.alreadyImageSet = false
                        StickerModel_.image = UIImagePNGRepresentation(UIImage(named: "add_icon")!)
                        break
                    }
                    x = x + 1
                }
            }
        }
        self.updateCustomPackage(customPackages: stickers)
    }
    func deleteCustomPackage(name:String){
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
