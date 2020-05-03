//
//  AllSubViewController.swift
//  Sticker
//
//  Created by Mehul on 04/03/19.
//  Copyright © 2019 Mehul. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SDWebImage
import GoogleMobileAds

class AllSubViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,GADInterstitialDelegate  {

    var aryList : NSMutableArray = []
    var catID : String = ""
    var subCatID : String = ""
    var strTitle : String = ""
    var strTrayUrl : String = ""
    var total : Int = 0
    var kUserDefault = UserDefaults.standard
    var strType : String = ""
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var cView: UICollectionView!
    var interstitialAd : GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = strTitle
        getData()
        cView.reloadData()
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
    
    // MARK: Retrive data from server
    func getData() {
    
        let parameters: Parameters = ["category_id": catID]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Alamofire.request(API_SUB_CATEGORY_LIST, method: .post, parameters: parameters).responseJSON { response in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if(response.result.isSuccess) {
                var dic: NSDictionary = [:]
                dic = response.result.value as! NSDictionary
                
                if(dic["ResponseCode"] as! String == "1") {
                    var di : NSMutableDictionary = [:]
                    di = (dic["data"] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    self.aryList = (di["sub_cate_list"] as! NSArray).mutableCopy() as! NSMutableArray
                    self.cView.reloadData()
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
    
    // MARK: Collection view method
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (UIDevice().type.rawValue == "iPhone 5S" || UIDevice().type.rawValue == "iPhone 5C" || UIDevice().type.rawValue == "iPhone 5" || UIDevice().type.rawValue == "iPhone 4S" || UIDevice().type.rawValue == "iPhone 4" || UIDevice().type.rawValue == "iPhone SE") {
            let padding: CGFloat =  12
            let collectionViewSize = collectionView.frame.size.width - padding
            
            return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)

        } else {
            let width = collectionView.bounds.width
            let cellWidth = (width - 30) / 3
            return CGSize(width: cellWidth, height: cellWidth)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCell", for: indexPath) as! SubCell
        
        var di : NSMutableDictionary = [:]
        di = (aryList.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.center = cell.imgView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        cell.imgView.addSubview(activityIndicator)
        cell.imgView.sd_setImage(with: URL(string: di["sub_cate_image"] as! String), completed: { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
            activityIndicator.removeFromSuperview()
        })
        
        cell.lblTitle.text = di["sub_cate_name"] as? String
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var dic : NSMutableDictionary = [:]
        dic = (aryList[indexPath.row] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        subCatID = dic["sub_cate_id"] as! String
        strTitle = dic["sub_cate_name"] as! String
        strTrayUrl = dic["sub_cate_tray_image"] as! String
        
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pack" {
            let controller = segue.destination as! PackViewController
            controller.strTitle = strTitle
            controller.catID = catID
            controller.subCatID = subCatID
            controller.strTrayUrl = strTrayUrl
        }
    }
    
    func showAlert(strMessage: String)  {
        let alert = UIAlertController(title: "MESSAGE", message: strMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Button Action
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Admob Ads Method
    func loadFullAd() {
        interstitialAd = GADInterstitial(adUnitID: FullAD)
        let request = GADRequest()
        interstitialAd.delegate = self
        interstitialAd.load(request)
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
        if strType == "pack" {
            self.performSegue(withIdentifier: "pack", sender: self)
        }
    }
}
