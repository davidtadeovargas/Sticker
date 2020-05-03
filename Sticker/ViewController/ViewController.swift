//
//  ViewController.swift
//  Sticker
//
//  Created by Mehul on 17/12/18.
//  Copyright © 2018 Mehul. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SDWebImage
import GoogleMobileAds

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GADInterstitialDelegate {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var sv_slider: UIScrollView!
    
    var interstitialAd : GADInterstitial!
    
    var arySlider : NSMutableArray = []
    var aryList : NSMutableArray = []
    var arySub : NSMutableArray = []
    var catID : String = ""
    var subCatID : String = ""
    var strTitle : String = ""
    var strTrayUrl : String = ""
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
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Retrive data from server
    func getData() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(API_HOME_LIST, method: .post, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
                MBProgressHUD.hide(for: self.view, animated: true)
                if(response.result.isSuccess) {
                    var dic: NSDictionary = [:]
                    dic = response.result.value as! NSDictionary
                    
                    if(dic["ResponseCode"] as! String == "1") {
                        var dicData : NSDictionary = [:]
                        dicData = dic["data"] as! NSDictionary
                    
                        self.arySlider = (dicData["slider"] as! NSArray).mutableCopy() as! NSMutableArray
                        self.setSlider()
                        
                        self.aryList = (dicData["category_list"] as! NSArray).mutableCopy() as! NSMutableArray
                        
                        self.tblView.reloadData()
                        
                    } else {
                        self.showAlert(strMessage: dic["ResponseMsg"] as! String)
                    }
                    
                } else {
                    let alert = UIAlertController(title: "MESSAGE", message: "Network Problem", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { action in
                        self.getData()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }
    
    // MARK: Slider Setup
    func setSlider() {
        
        let width : Float = Float(self.view.frame.size.width - 60)
        var xPos : Float = 0.0
        for i in 0 ..< arySlider.count {
            var dic : NSMutableDictionary = [:]
            dic = (arySlider[i] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            
            let v = UIView(frame: CGRect(x: Double(xPos), y: 0.0, width: Double(width), height: Double(sv_slider.frame.size.height)))
            v.backgroundColor = UIColor.clear
            
            let imgView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: v.frame.size.width, height: v.frame.size.height))
            imgView.layer.cornerRadius = 5.0
            imgView.layer.borderWidth = 1.0
            imgView.layer.borderColor = UIColor.black.cgColor
            
            
            let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            activityIndicator.center = imgView.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            imgView.addSubview(activityIndicator)
            v.addSubview(imgView)
            
            imgView.sd_setImage(with: URL(string: dic["slider_image"] as! String), completed: { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
                activityIndicator.removeFromSuperview()
            })
            
            
            let btn = UIButton(frame: CGRect(x: 0, y: 0, width: v.frame.size.width, height: v.frame.size.height))
            btn.tag = i
            btn.addTarget(self, action: #selector(btnSliderTapped(button:)), for: .touchUpInside)
            v.addSubview(btn)
            
            xPos = xPos + width + 8
            
            sv_slider.addSubview(v)
            sv_slider.contentSize = CGSize(width: Int(xPos-8), height: 0)
        }
    }
    
    @objc func btnSliderTapped(button: UIButton) {
        var dic : NSMutableDictionary = [:]
        dic = (arySlider[button.tag] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        strTitle = dic["slider_name"] as! String
        catID = dic["category_id"] as! String
        
        strType = "sub"
        if(total == 0) {
            if interstitialAd.isReady {
                total = total + 1
                kUserDefault.set("\(total)", forKey: "total")
                kUserDefault.synchronize()
                interstitialAd.present(fromRootViewController: self)
            } else {
                /// Move to specific screen if ad is not ready to display.
                self.performSegue(withIdentifier: "sub", sender: self)
            }
        } else {
            if(total >= 4 ) {
                total = 0
            } else {
                total = total + 1
            }
            kUserDefault.set("\(total)", forKey: "total")
            kUserDefault.synchronize()
            self.performSegue(withIdentifier: "sub", sender: self)
        }
    }
    
    // MARK: Tableview Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : HomeCell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeCell
        
        if indexPath.row == 0 {
            cell.btnArrow.isHidden = true
        } else {
            cell.btnArrow.isHidden = false
        }
        
        var dic : NSMutableDictionary = [:]
        dic = (aryList[indexPath.row] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        cell.lblTitle.text = dic["category_name"] as? String
        
        if (dic["category_image"] as! String == "") {
            cell.imgTray.image = UIImage.init(named: "ex")
        } else {
            let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            activityIndicator.center = cell.imgTray.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            cell.imgTray.addSubview(activityIndicator)
            
            cell.imgTray.sd_setImage(with: URL(string: dic["category_image"] as! String), completed: { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
                activityIndicator.removeFromSuperview()
            })
        }
        
        cell.viewMainImage.layer.cornerRadius = 25.0
        cell.viewSubImage.layer.cornerRadius = 23.0
        cell.viewMainImage.layer.masksToBounds = true
        cell.viewSubImage.layer.masksToBounds = true
        
        var arySub : NSMutableArray = []
        arySub = (dic["sub_category"] as! NSArray).mutableCopy() as! NSMutableArray
        
        for view in cell.sView.subviews {
            view.removeFromSuperview()
        }
        
        cell.btnMain.tag = indexPath.row
        cell.btnMain.addTarget(self, action: #selector(btnAllTapped(button:)), for: .touchUpInside)

        var xPos : Float = 0.0
        for i in 0 ..< arySub.count {
            var dicSub : NSMutableDictionary = [:]
            dicSub = (arySub[i] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            
            let v = UIView(frame: CGRect(x: Double(xPos), y: 0.0, width: 82, height: 78))
            v.backgroundColor = UIColor.clear
            
            let imgView = UIImageView(frame: CGRect(x: 16, y: 0, width: 50, height: 50))
            
            let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            activityIndicator.center = imgView.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            imgView.addSubview(activityIndicator)
            v.addSubview(imgView)
            
            imgView.sd_setImage(with: URL(string: dicSub["sub_cate_image"] as! String), completed: { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
                activityIndicator.removeFromSuperview()
            })
            
            let lbl = UILabel(frame: CGRect(x: 0, y: imgView.frame.origin.y+imgView.frame.size.height+8, width: 82, height: 20))
            lbl.text = dicSub["sub_cate_name"] as? String
            lbl.textAlignment = .center
            lbl.textColor = UIColor.black
            lbl.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            v.addSubview(lbl)
            
            let btn = UIButton(frame: CGRect(x: 8, y: 8, width: v.frame.size.width, height: v.frame.size.height))
            btn.tag = i
            btn.addTarget(self, action: #selector(btnShowTapped(button:)), for: .touchUpInside)
            v.addSubview(btn)
            
            xPos = xPos + 82 + 8
            
            cell.sView.addSubview(v)
            cell.sView.contentSize = CGSize(width: Int(xPos-8), height: 0)
        }
        
        return cell
    }
    
    // MARK: Button Action
    @objc func btnAllTapped(button: UIButton) {
        if(button.tag == 0) {
            
        } else {
            let touchPoint = button.convert(CGPoint.zero, to:tblView)
            let clickedButtonIndexPath = tblView.indexPathForRow(at: touchPoint)
            
            var dic : NSMutableDictionary = [:]
            dic = (aryList[(clickedButtonIndexPath?.row)!] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            strTitle = dic["category_name"] as! String
            catID = dic["category_id"] as! String
            arySub = (dic["sub_category"] as! NSArray).mutableCopy() as! NSMutableArray
            
            
            strType = "sub"
            if(total == 0) {
                if interstitialAd.isReady {
                    total = total + 1
                    kUserDefault.set("\(total)", forKey: "total")
                    kUserDefault.synchronize()
                    interstitialAd.present(fromRootViewController: self)
                } else {
                    /// Move to specific screen if ad is not ready to display.
                    self.performSegue(withIdentifier: "sub", sender: self)
                }
            } else {
                if(total >= 4 ) {
                    total = 0
                } else {
                    total = total + 1
                }
                kUserDefault.set("\(total)", forKey: "total")
                kUserDefault.synchronize()
                self.performSegue(withIdentifier: "sub", sender: self)
            }
        }
    }
    
    @objc func btnShowTapped(button: UIButton) {
        
        let touchPoint = button.convert(CGPoint.zero, to:tblView)
        let clickedButtonIndexPath = tblView.indexPathForRow(at: touchPoint)
        
        var dic : NSMutableDictionary = [:]
        dic = (aryList[(clickedButtonIndexPath?.row)!] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        var arySub : NSMutableArray = []
        arySub = (dic["sub_category"] as! NSArray).mutableCopy() as! NSMutableArray
        
        var dicSub : NSMutableDictionary = [:]
        dicSub = (arySub[button.tag] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        catID = dicSub["category_id"] as! String
        subCatID = dicSub["sub_cate_id"] as! String
        strTitle = dicSub["sub_cate_name"] as! String
        strTrayUrl = dicSub["sub_cate_tray_image"] as! String
        
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
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pack" {
            let controller = segue.destination as! PackViewController
            controller.strTitle = strTitle
            controller.catID = catID
            controller.subCatID = subCatID
            controller.strTrayUrl = strTrayUrl
        }
        
        if segue.identifier == "sub" {
            let controller = segue.destination as! AllSubViewController
            controller.catID = catID
            controller.strTitle = strTitle
        }
    }
    
    func showAlert(strMessage: String)  {
        let alert = UIAlertController(title: "MESSAGE", message: strMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Admob Ads Method
    func loadFullAd() {
        interstitialAd = GADInterstitial(adUnitID: FullAD)
        let request = GADRequest()
        interstitialAd.delegate = self
        interstitialAd.load(request)
    }
    
    // Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        if strType == "sub" {
            self.performSegue(withIdentifier: "sub", sender: self)
        } else if(strType == "pack") {
            self.performSegue(withIdentifier: "pack", sender: self)
        }
    }
}

//MARK: Extensions
public extension UIDevice {
    public var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
                
            }
        }
        var modelMap : [ String : Model ] = [
            "i386"      : .simulator,
            "x86_64"    : .simulator,
            //iPod
            "iPod1,1"   : .iPod1,
            "iPod2,1"   : .iPod2,
            "iPod3,1"   : .iPod3,
            "iPod4,1"   : .iPod4,
            "iPod5,1"   : .iPod5,
            //iPad
            "iPad2,1"   : .iPad2,
            "iPad2,2"   : .iPad2,
            "iPad2,3"   : .iPad2,
            "iPad2,4"   : .iPad2,
            "iPad3,1"   : .iPad3,
            "iPad3,2"   : .iPad3,
            "iPad3,3"   : .iPad3,
            "iPad3,4"   : .iPad4,
            "iPad3,5"   : .iPad4,
            "iPad3,6"   : .iPad4,
            "iPad4,1"   : .iPadAir,
            "iPad4,2"   : .iPadAir,
            "iPad4,3"   : .iPadAir,
            "iPad5,3"   : .iPadAir2,
            "iPad5,4"   : .iPadAir2,
            "iPad6,11"  : .iPad5, //aka iPad 2017
            "iPad6,12"  : .iPad5,
            "iPad7,5"   : .iPad6, //aka iPad 2018
            "iPad7,6"   : .iPad6,
            //iPad mini
            "iPad2,5"   : .iPadMini,
            "iPad2,6"   : .iPadMini,
            "iPad2,7"   : .iPadMini,
            "iPad4,4"   : .iPadMini2,
            "iPad4,5"   : .iPadMini2,
            "iPad4,6"   : .iPadMini2,
            "iPad4,7"   : .iPadMini3,
            "iPad4,8"   : .iPadMini3,
            "iPad4,9"   : .iPadMini3,
            "iPad5,1"   : .iPadMini4,
            "iPad5,2"   : .iPadMini4,
            //iPad pro
            "iPad6,3"   : .iPadPro9_7,
            "iPad6,4"   : .iPadPro9_7,
            "iPad7,3"   : .iPadPro10_5,
            "iPad7,4"   : .iPadPro10_5,
            "iPad6,7"   : .iPadPro12_9,
            "iPad6,8"   : .iPadPro12_9,
            "iPad7,1"   : .iPadPro2_12_9,
            "iPad7,2"   : .iPadPro2_12_9,
            //iPhone
            "iPhone3,1" : .iPhone4,
            "iPhone3,2" : .iPhone4,
            "iPhone3,3" : .iPhone4,
            "iPhone4,1" : .iPhone4S,
            "iPhone5,1" : .iPhone5,
            "iPhone5,2" : .iPhone5,
            "iPhone5,3" : .iPhone5C,
            "iPhone5,4" : .iPhone5C,
            "iPhone6,1" : .iPhone5S,
            "iPhone6,2" : .iPhone5S,
            "iPhone7,1" : .iPhone6plus,
            "iPhone7,2" : .iPhone6,
            "iPhone8,1" : .iPhone6S,
            "iPhone8,2" : .iPhone6Splus,
            "iPhone8,4" : .iPhoneSE,
            "iPhone9,1" : .iPhone7,
            "iPhone9,3" : .iPhone7,
            "iPhone9,2" : .iPhone7plus,
            "iPhone9,4" : .iPhone7plus,
            "iPhone10,1" : .iPhone8,
            "iPhone10,4" : .iPhone8,
            "iPhone10,2" : .iPhone8plus,
            "iPhone10,5" : .iPhone8plus,
            "iPhone10,3" : .iPhoneX,
            "iPhone10,6" : .iPhoneX,
            "iPhone11,2" : .iPhoneXS,
            "iPhone11,4" : .iPhoneXSMax,
            "iPhone11,6" : .iPhoneXSMax,
            "iPhone11,8" : .iPhoneXR,
            //AppleTV
            "AppleTV5,3" : .AppleTV,
            "AppleTV6,2" : .AppleTV_4K
        ]
        
        if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
            if model == .simulator {
                if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                    if let simModel = modelMap[String.init(validatingUTF8: simModelCode)!] {
                        return simModel
                    }
                }
            }
            return model
        }
        return Model.unrecognized
    }
}

public enum Model : String {
    case simulator     = "simulator/sandbox",
    //iPod
    iPod1              = "iPod 1",
    iPod2              = "iPod 2",
    iPod3              = "iPod 3",
    iPod4              = "iPod 4",
    iPod5              = "iPod 5",
    //iPad
    iPad2              = "iPad 2",
    iPad3              = "iPad 3",
    iPad4              = "iPad 4",
    iPadAir            = "iPad Air ",
    iPadAir2           = "iPad Air 2",
    iPad5              = "iPad 5", //aka iPad 2017
    iPad6              = "iPad 6", //aka iPad 2018
    //iPad mini
    iPadMini           = "iPad Mini",
    iPadMini2          = "iPad Mini 2",
    iPadMini3          = "iPad Mini 3",
    iPadMini4          = "iPad Mini 4",
    //iPad pro
    iPadPro9_7         = "iPad Pro 9.7\"",
    iPadPro10_5        = "iPad Pro 10.5\"",
    iPadPro12_9        = "iPad Pro 12.9\"",
    iPadPro2_12_9      = "iPad Pro 2 12.9\"",
    //iPhone
    iPhone4            = "iPhone 4",
    iPhone4S           = "iPhone 4S",
    iPhone5            = "iPhone 5",
    iPhone5S           = "iPhone 5S",
    iPhone5C           = "iPhone 5C",
    iPhone6            = "iPhone 6",
    iPhone6plus        = "iPhone 6 Plus",
    iPhone6S           = "iPhone 6S",
    iPhone6Splus       = "iPhone 6S Plus",
    iPhoneSE           = "iPhone SE",
    iPhone7            = "iPhone 7",
    iPhone7plus        = "iPhone 7 Plus",
    iPhone8            = "iPhone 8",
    iPhone8plus        = "iPhone 8 Plus",
    iPhoneX            = "iPhone X",
    iPhoneXS           = "iPhone XS",
    iPhoneXSMax        = "iPhone XS Max",
    iPhoneXR           = "iPhone XR",
    //Apple TV
    AppleTV            = "Apple TV",
    AppleTV_4K         = "Apple TV 4K",
    unrecognized       = "?unrecognized?"
}


