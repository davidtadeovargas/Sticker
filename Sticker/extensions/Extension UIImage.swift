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
    
     func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
    
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
    
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
    
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        return newImage!
    }
}
