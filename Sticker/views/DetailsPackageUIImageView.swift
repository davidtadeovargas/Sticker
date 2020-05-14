//
//  DetailsPackageUIImageView.swift
//  Sticker
//
//  Created by usuario on 06/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit

class DetailsPackageUIImageView: UIImageView {

    var replyImage:UIImageView?
    var index:Int?
    var position:Int?
    
    
    override var image: UIImage? {
        didSet {
            super.image = image
            replyImage?.image = image
        }
    }
}
