//
//  PackageDetailTableRow.swift
//  Sticker
//
//  Created by usuario on 06/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation

class PackageDetailTableRow {
    
    var image1:UIImageView = UIImageView()
    var image2:UIImageView = UIImageView()
    var image3:UIImageView = UIImageView()
    var index:Int?
    
    init() {
        
        let catImage = UIImage(named: "add_icon.png")
        image1.image = catImage
        image2.image = catImage
        image3.image = catImage
    }
}