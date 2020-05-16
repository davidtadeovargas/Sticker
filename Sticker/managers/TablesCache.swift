//
//  TablesCache.swift
//  Sticker
//
//  Created by usuario on 15/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation

class TablesCache {
    
    static let shared = TablesCache()
    
    private init() {
    }
    
    
    func saveDataInCache(data_:[AnyObject], TableType_:TableType){
        
        //Encode the data
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: data_)
        
        //Define the key
        var key:String? = nil
        switch TableType_ {
            case .TABLE_PRINCIPAL_CACHE:
                key = "TABLE_PRINCIPAL_CACHE"
                break
            case .TABLE_PACKAGE_DETAIL_CACHE:
                key = "TABLE_PACKAGE_DETAIL_CACHE"
                break
        }
        
        //Save in the system
        let defaults = UserDefaults.standard
        defaults.set(encodedData, forKey: key!)
    }
    
    func getDataFromCache(TableType_:TableType) -> [AnyObject]? {
        
        //Get the defaults user from system
        let defaults = UserDefaults.standard
        
        //Define the key
        var key:String? = nil
        switch TableType_ {
            case .TABLE_PRINCIPAL_CACHE:
                key = "TABLE_PRINCIPAL_CACHE"
                break
            case .TABLE_PACKAGE_DETAIL_CACHE:
                key = "TABLE_PACKAGE_DETAIL_CACHE"
                break
        }
        
        //Get the array
        var data_:[AnyObject]? = nil
        if(defaults.object(forKey: key!) != nil){
            let decoded  = defaults.object(forKey: key!) as! Data
            data_ = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [AnyObject]
        }
        
        //Return the result
        return data_
    }
    
    func clearAllTableCaches(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "TABLE_PRINCIPAL_CACHE")
        defaults.removeObject(forKey: "TABLE_PACKAGE_DETAIL_CACHE")
    }
}

enum TableType {
    case TABLE_PRINCIPAL_CACHE
    case TABLE_PACKAGE_DETAIL_CACHE
}
