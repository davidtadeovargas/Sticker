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
       
        self.load()
    }
    
    func load(){
        
        print("Google adds: Loading add")
        
        interstitialAd = GADInterstitial(adUnitID: FullAD)
        let request = GADRequest()
        interstitialAd.delegate = self
        interstitialAd.load(request)
    }
    
    func showAddIfApply(UIViewController:UIViewController){
        
        if(total == 0) {
            if interstitialAd.isReady {
                total = total + 1
                print("Google adds: Presenting google ad")
                interstitialAd.present(fromRootViewController: UIViewController)
                
                //Reload add
                self.load()
                
            } else {
                /// Move to specific screen if ad is not ready to display.
                print("Google adds: Google add is not ready")
            }
        } else {
            if(total >= 4 ) {
                print("Google adds: Reseting google ad counter to 0")
                total = 0
            } else {
                total = total + 1
                print("Google adds: Google add counter is in \(total)")
            }
        }
    }
    
    func showNow(UIViewController:UIViewController){
        
        if interstitialAd.isReady {
            print("Google adds: Presenting google ad")
            interstitialAd.present(fromRootViewController: UIViewController)
            
            //Reload add
            self.load()
            
        } else {
            /// Move to specific screen if ad is not ready to display.
            print("Google adds: Google add is not ready")
        }
    }
}
