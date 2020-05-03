//
//  MainViewController.swift
//  Sticker
//
//  Created by Mehul on 07/06/19.
//  Copyright © 2019 Mehul. All rights reserved.


import UIKit
import GoogleMobileAds
import Alamofire
import MBProgressHUD

class MainViewController: UIViewController,GADInterstitialDelegate {
    
    var interstitialAd : GADInterstitial!
    var total : Int = 0
    var kUserDefault = UserDefaults.standard
    var strType : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if((kUserDefault.string(forKey: "total")) != nil) {
            total = Int(kUserDefault.string(forKey: "total")!)!
        } else {
            total = 0
            kUserDefault.set("\(total)", forKey: "total")
            kUserDefault.synchronize()
        }
        loadFullAd()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Button Action
    @IBAction func btnStickerStoreClick(_ sender: Any) {
        strType = "store"
        if(total == 0) {
            if interstitialAd.isReady {
                total = total + 1
                kUserDefault.set("\(total)", forKey: "total")
                kUserDefault.synchronize()
                interstitialAd.present(fromRootViewController: self)
            } else {
                /// Move to specific screen if ad is not ready to display.
                self.performSegue(withIdentifier: "store", sender: self)
            }
        } else {
            if(total >= 4 ) {
                total = 0
            } else {
                total = total + 1
            }
            kUserDefault.set("\(total)", forKey: "total")
            kUserDefault.synchronize()
            self.performSegue(withIdentifier: "store", sender: self)
        }
    }
    
    @IBAction func btnCustomStickerClick(_ sender: Any) {
        strType = "create"
        if(total == 0) {
            if interstitialAd.isReady {
                total = total + 1
                kUserDefault.set("\(total)", forKey: "total")
                kUserDefault.synchronize()
                interstitialAd.present(fromRootViewController: self)
            } else {
                /// Move to specific screen if ad is not ready to display.
                self.performSegue(withIdentifier: "create", sender: self)
            }
        } else {
            if(total >= 4 ) {
                total = 0
            } else {
                total = total + 1
            }
            kUserDefault.set("\(total)", forKey: "total")
            kUserDefault.synchronize()
            self.performSegue(withIdentifier: "create", sender: self)
        }
    }
    
    @IBAction func btnMyStickerClick(_ sender: Any) {
        strType = "my"
        if(total == 0) {
            if interstitialAd.isReady {
                total = total + 1
                kUserDefault.set("\(total)", forKey: "total")
                kUserDefault.synchronize()
                interstitialAd.present(fromRootViewController: self)
            } else {
                /// Move to specific screen if ad is not ready to display.
                self.performSegue(withIdentifier: "my", sender: self)
            }
        } else {
            if(total >= 4 ) {
                total = 0
            } else {
                total = total + 1
            }
            kUserDefault.set("\(total)", forKey: "total")
            kUserDefault.synchronize()
            self.performSegue(withIdentifier: "my", sender: self)
        }
    }
    
    @IBAction func btnRateUsClick(_ sender: Any) {
        let url = URL(string: I_App)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func btnShareUsClick(_ sender: Any) {
        let textToShare = "Sticker Store for WhatsApp"
        if let myWebsite = NSURL(string: I_App) {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = sender as? UIView
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    // MARK: Admob Ads Method
    func loadFullAd() {
        interstitialAd = GADInterstitial(adUnitID: FullAD)
        let request = GADRequest()
        interstitialAd.delegate = self
        interstitialAd.load(request)
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
        if strType == "store" {
            self.performSegue(withIdentifier: "store", sender: self)
        } else if(strType == "create") {
            self.performSegue(withIdentifier: "create", sender: self)
        } else if(strType == "my") {
            self.performSegue(withIdentifier: "my", sender: self)
        }
    }
}
