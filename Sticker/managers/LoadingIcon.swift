//
//  LoadingIcon.swift
//  Sticker
//
//  Created by usuario on 13/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation

class LoadingIcon {
    
    static let shared = LoadingIcon()
    var spinnerView:UIView?
    
    private init() {
    }
    
    func show(onView : UIView){
        
        self.spinnerView = UIView.init(frame: onView.bounds)
        spinnerView!.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView!.center
        
        DispatchQueue.main.async {
            self.spinnerView!.addSubview(ai)
            onView.addSubview(self.spinnerView!)
        }
    }
    
    func hide(){
        DispatchQueue.main.async {
            self.spinnerView?.removeFromSuperview()
            self.spinnerView = nil
        }
    }
}
