//
//  CreateSticker2ViewController.swift
//  Sticker
//
//  Created by Mehul on 14/06/19.
//  Copyright © 2019 Mehul. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SDWebImage

class CreateSticker2ViewController: UIViewController,GADInterstitialDelegate,UITextFieldDelegate {

    var interstitialAd : GADInterstitial!
    var total : Int = 0
    var kUserDefault = UserDefaults.standard
    var strType : String = ""
    var arySticker : NSMutableArray = []
    var aryIcon : NSMutableArray = []
    var dicSend : NSMutableDictionary = [:]
    var strIcon : String = ""
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var sView: UIScrollView!
    @IBOutlet weak var viewSuccess: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aryIcon = []
        for i in 0 ..< arySticker.count {
            var dicSub : NSMutableDictionary = [:]
            dicSub = (self.arySticker[i] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            if(aryIcon.contains(dicSub["tray_img"] as! String)) {
                
            } else {
                aryIcon.add(dicSub["tray_img"] as! String)
            }
        }
        setIcon()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewSuccess.isHidden = true
        
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
    @objc func btnAddTapped(button: UIButton) {
        strIcon = aryIcon.object(at: button.tag) as! String
        setIcon()
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCreateClick(_ sender: Any) {
        if txtName.text == "" {
            showAlert(strMessage: "Enter Pack Name")
        } else if strIcon == "" {
            showAlert(strMessage: "Choose Pack Icon")
        } else {
            
            let defaults = UserDefaults.standard
            
            
            if(defaults.object(forKey: "custom_sticker") == nil) {
                let dic : NSMutableDictionary = [:]
                dic.setValue(txtName.text, forKey: "pack_name")
                dic.setValue(strIcon, forKey: "tray_image")
                dic.setValue(arySticker, forKey: "sticker")
                let ary : NSMutableArray = []
                ary.add(dic)
                defaults.set(ary, forKey: "custom_sticker")
                
                dicSend = dic
                
                viewSuccess.isHidden = false
                
            } else {
                var ary : NSMutableArray = []
                ary = (defaults.object(forKey: "custom_sticker") as! NSArray).mutableCopy() as! NSMutableArray
                
                var isExist : Bool = false
                for i in 0 ..< ary.count {
                    var dicSub : NSMutableDictionary = [:]
                    dicSub = (ary[i] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    if(dicSub["pack_name"] as? String == txtName.text) {
                        isExist = true
                    }
                }
                
                if(isExist == true) {
                    showAlert(strMessage: "Pack Name  Already Exist")
                } else {
                    let dic : NSMutableDictionary = [:]
                    dic.setValue(txtName.text, forKey: "pack_name")
                    dic.setValue(strIcon, forKey: "tray_image")
                    dic.setValue(arySticker, forKey: "sticker")
                    ary.add(dic)
                    defaults.set(ary, forKey: "custom_sticker")
                    
                    dicSend = dic
                    
                    viewSuccess.isHidden = false
                }
            }
        }
    }
    
    @IBAction func btnCancelClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOkClick(_ sender: Any) {
        let rootVC:MainViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        let nvc:UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: "main") as! UINavigationController
        nvc.viewControllers = [rootVC]
        UIApplication.shared.keyWindow?.rootViewController = nvc
    }
    
    @IBAction func btnSendToWhatsappClick(_ sender: Any) {
        strType = "pack"
        if(total == 0) {
            if interstitialAd.isReady {
                total = total + 1
                kUserDefault.set("\(total)", forKey: "total")
                kUserDefault.synchronize()
                interstitialAd.present(fromRootViewController: self)
            } else {
                /// Move to specific screen if ad is not ready to display.
                self.performSegue(withIdentifier: "pack", sender: self)
            }
        } else {
            if(total >= 4 ) {
                total = 0
            } else {
                total = total + 1
            }
            kUserDefault.set("\(total)", forKey: "total")
            kUserDefault.synchronize()
            self.performSegue(withIdentifier: "pack", sender: self)
        }
    }
    
    // MARK: Method
    func setIcon() {
        for view in sView.subviews {
            view.removeFromSuperview()
        }
        var xPos : Float = 0.0
        for i in 0 ..< self.aryIcon.count {
            
            let v = UIView(frame: CGRect(x: Double(xPos), y: 0.0, width: 100, height: 100))
            v.backgroundColor = UIColor.clear
            v.layer.borderWidth = 0.5
            v.layer.borderColor = UIColor(red: 48/255, green: 166/255, blue: 75/255, alpha: 1).cgColor
            
            let imgView = UIImageView(frame: CGRect(x: 10, y: 10, width: 80, height: 80))
            imgView.backgroundColor = UIColor.clear
            
            let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            activityIndicator.center = imgView.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            imgView.addSubview(activityIndicator)
            v.addSubview(imgView)
            imgView.sd_setImage(with: URL(string: aryIcon.object(at: i) as! String), completed: { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
                activityIndicator.removeFromSuperview()
            })
            
            if strIcon == aryIcon.object(at: i) as! String {
                let imgTick = UIImageView(frame: CGRect(x: (100 / 2) - 16, y: 108, width: 32, height: 32))
                imgTick.image = UIImage(named: "tick")
                v.addSubview(imgTick)
            }
            
            let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            btn.tag = i
            btn.addTarget(self, action: #selector(btnAddTapped(button:)), for: .touchUpInside)
            v.addSubview(btn)
            
            xPos = xPos + 100 + 8
            
            sView.addSubview(v)
            sView.contentSize = CGSize(width: Int(xPos-8), height: 0)
        }
    }

    func showAlert(strMessage: String)  {
        let alert = UIAlertController(title: "MESSAGE", message: strMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pack" {
            let controller = segue.destination as! CustomPackViewController
            controller.dicSticker = dicSend
            controller.strFrom = "create"
        }
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // MARK: Admob Ads Method
    func loadFullAd() {
        interstitialAd = GADInterstitial(adUnitID: FullAD)
        let request = GADRequest()
        interstitialAd.delegate = self
        interstitialAd.load(request)
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        if strType == "pack" {
            self.performSegue(withIdentifier: "pack", sender: self)
        }
    }
    
}
