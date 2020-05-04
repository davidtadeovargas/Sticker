//
//  AddsManager.swift
//  Sticker
//
//  Created by usuario on 03/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation
import GoogleMobileAds

class AddsManager: NSObject, GADInterstitialDelegate {
    
    var interstitialAd : GADInterstitial!
    var total : Int = 0
    
    static let shared = AddsManager()
    
    private override init() {
        super.init()
       
        interstitialAd = GADInterstitial(adUnitID: FullAD)
        let request = GADRequest()
        interstitialAd.delegate = self
        interstitialAd.load(request)
    }
    
    func showAddIfApply(UIViewController:UIViewController){
        
        if(total == 0) {
            if interstitialAd.isReady {
                total = total + 1
                interstitialAd.present(fromRootViewController: UIViewController)
            } else {
                /// Move to specific screen if ad is not ready to display.
                
            }
        } else {
            if(total >= 4 ) {
                total = 0
            } else {
                total = total + 1
            }
        }
    }
}
