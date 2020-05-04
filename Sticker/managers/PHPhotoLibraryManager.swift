//
//  PHPhotoLibraryManager.swift
//  Sticker
//
//  Created by usuario on 03/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation
import Photos

class PHPhotoLibraryManager {
    
    static let shared = PHPhotoLibraryManager()

    private init() {
    }
    
    func askPermission(onGranted: @escaping () -> Void,onNotGranted: @escaping () -> Void, onDenied: @escaping () -> Void){
        
        // Get the current authorization state.
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == PHAuthorizationStatus.authorized) {
            
        }
        else if (status == PHAuthorizationStatus.denied) {
            onDenied()
            return
        }
        else if (status == PHAuthorizationStatus.notDetermined) {
           
        }
        else if (status == PHAuthorizationStatus.restricted) {
           
        }
        else{
            
        }
        
        PHPhotoLibrary.requestAuthorization({ (newStatus) in

            if (newStatus == PHAuthorizationStatus.authorized) {
                onGranted()
            }
            else {
                onNotGranted()
            }
        })
    }
    
    func photoLibraryPermissionGranted() -> Bool{
        
        // Get the current authorization state.
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == PHAuthorizationStatus.authorized) {
            return true
        }
        else if (status == PHAuthorizationStatus.denied) {
            return false
        }
        else if (status == PHAuthorizationStatus.notDetermined) {
            return false
        }
        else if (status == PHAuthorizationStatus.restricted) {
            return false
        }
        else{
            return false
        }
    }
}
