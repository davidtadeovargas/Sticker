//
//  Extension UIImage.swift
//  Sticker
//
//  Created by usuario on 18/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit

extension UIImage {

    static func imageByMergingImages(topImage: UIImage, bottomImage: UIImage, scaleForTop: CGFloat = 3) -> UIImage {
        let size = bottomImage.size
        let container = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 2.0)
        UIGraphicsGetCurrentContext()!.interpolationQuality = .high
        bottomImage.draw(in: container)

        let topWidth = size.width / scaleForTop
        let topHeight = size.height / scaleForTop
        let topX = size.width - topWidth - 20
        let topY = 20

        topImage.draw(in: CGRect(x: topX, y: CGFloat(topY), width: topWidth, height: topHeight), blendMode: .normal, alpha: 1.0)

        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    func getData() -> Data {
        return UIImagePNGRepresentation(self)!
    }
}
