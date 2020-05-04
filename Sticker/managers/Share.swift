//
//  Share.swift
//  Sticker
//
//  Created by usuario on 03/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation

class Share {
    
    static let shared = Share()
    
    private init() {
    }
    
    func share(UIViewController:UIViewController, message: String, link: String) {
        if let link = NSURL(string: link) {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            UIViewController.present(activityVC, animated: true, completion: nil)
        }
    }
}
