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
    var name:String?
    var StickerModel:StickerModel?
    
    override var image: UIImage? {
        didSet {
            super.image = image
            replyImage?.image = image
        }
    }
}
