//
//  ExtensionUIImageView.swift
//  Sticker
//
//  Created by usuario on 18/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SDWebImageWebPCoder

extension UIImageView {

    func loadImageFromUrl(urlString:String){
        
        let newUrlString = urlString.replacingOccurrences(of: " ", with: "%20")
        
        if(newUrlString.hasSuffix("webp")){
            let webPCoder = SDImageWebPCoder.shared
            SDImageCodersManager.shared.addCoder(webPCoder)
            guard let webpURL = URL(string: newUrlString)  else {return}
            DispatchQueue.main.async {
                self.sd_setImage(with: webpURL)
            }
        }
        else{
            AF.request(newUrlString, method: .get)
            .validate()
            .responseData(completionHandler: { (responseData) in
                self.image = UIImage(data: responseData.data!)
                DispatchQueue.main.async {
                    // Refresh you views
                }
            })
        }
    }
    
    func getData() -> Data {
        return UIImagePNGRepresentation(self.image!)!
    }
}
