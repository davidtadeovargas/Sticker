//
//  ExtensionUIImageView.swift
//  Sticker
//
//  Created by usuario on 18/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit

extension UIImageView {

    func loadImageFromUrl(urlString:String){
        
        let url = URL(string: urlString)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                if(data == nil){
                    
                }
                else{
                    let imageIcon = UIImage(data: data!)
                    self.image = imageIcon
                }
            }
        }
    }
    
    func getData() -> Data {
        return UIImagePNGRepresentation(self.image!)!
    }
}
