//
//  EditPackageImageShare.swift
//  Sticker
//
//  Created by usuario on 06/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation

class EditPackageImageShare {
    
    static let shared = EditPackageImageShare()
    
    var EditAction_:EditAction?
    var model:AnyObject?
    var returnToUIViewController:UIViewController!
    
    private init() {
    }
}
