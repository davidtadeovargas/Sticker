//
//  Edit1ViewController.swift
//  Sticker
//
//  Created by Mehul on 19/06/19.
//  Copyright © 2019 Mehul. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SDWebImage
import GoogleMobileAds

class EditViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GADInterstitialDelegate,UITextFieldDelegate {

    var interstitialAd : GADInterstitial!
    var total : Int = 0
    var kUserDefault = UserDefaults.standard
    var strType : String = ""
    var dicSticker : NSMutableDictionary = [:]
    var aryList : NSMutableArray = []
    var aryMain : NSMutableArray = []
    var dicCategory : NSMutableDictionary = [:]
    var strIcon : String = ""
    var arySticker : NSMutableArray = []
    var aryMySticker : NSMutableArray = []
    var dicSend : NSMutableDictionary = [:]
    
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var sMain: UIScrollView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var sView: UIScrollView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var mySview: UIScrollView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var viewSuccess: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sMain.contentSize = CGSize(width: 0, height: 565)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadFullAd()
        
        if((kUserDefault.string(forKey: "total")) != nil) {
            total = Int(kUserDefault.string(forKey: "total")!)!
        } else {
            total = 0
            kUserDefault.set("\(total)", forKey: "total")
            kUserDefault.synchronize()
        }
        
        viewCategory.isHidden = true
        viewSuccess.isHidden = true
        txtName.text = dicSticker["pack_name"] as? String
        aryMySticker = (dicSticker["sticker"] as!  NSArray).mutableCopy() as! NSMutableArray
        mySticker()
        getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Retrive data from server
    func getData() {
        
        lblCategory.text = "Select Category"
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(API_HOME_LIST, method: .post, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            MBProgressHUD.hide(for: self.view, animated: true)
            if(response.result.isSuccess) {
            
                var dic: NSDictionary = [:]
                dic = response.result.value as! NSDictionary
                
                if(dic["ResponseCode"] as! String == "1") {
                    var dicData : NSDictionary = [:]
                    dicData = dic["data"] as! NSDictionary
                    
                    self.aryMain = []
                    self.aryList = (dicData["category_list"] as! NSArray).mutableCopy() as! NSMutableArray
                    
                    for i in self.aryList {
                        var dic : NSMutableDictionary = [:]
                        dic = (i as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        
                        var ary : NSMutableArray = []
                        ary = (dic["sub_category"] as! NSArray).mutableCopy() as! NSMutableArray
                        
                        for j in ary {
                            var dic : NSMutableDictionary = [:]
                            dic = (j as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            self.aryMain.add(dic)
                        }
                    }
                    self.dicCategory = self.aryMain.object(at: 0) as! NSMutableDictionary
                    self.lblCategory.text = self.dicCategory.value(forKey: "sub_cate_name") as? String
                    self.strIcon = self.dicCategory["sub_cate_tray_image"] as! String
                    self.getSticker()
                    if(self.aryMain.count > 0) {
                        self.tblView.reloadData()
                    } else {
                        self.lblCategory.text = "Select Category"
                        self.dicCategory = [:]
                    }
                    
                } else {
                    self.showAlert(strMessage: dic["ResponseMsg"] as! String)
                    self.lblCategory.text = "Select Category"
                    self.dicCategory = [:]
                }
                
            } else {
                self.lblCategory.text = "Select Category"
                self.dicCategory = [:]
                let alert = UIAlertController(title: "MESSAGE", message: "Network Problem", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { action in
                    self.getData()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func getSticker() {
        
        var strID : String = ""
        strID = dicCategory.object(forKey: "sub_cate_id") as! String
        
        let parameters: Parameters = ["sub_cate_id": strID]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Alamofire.request(API_STICKER_LIST, method: .post, parameters: parameters).responseJSON { response in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if(response.result.isSuccess) {
                var dic: NSDictionary = [:]
                dic = response.result.value as! NSDictionary
                if(dic["ResponseCode"] as! String == "1") {
                    self.arySticker = []
                    self.arySticker = (dic["data"] as! NSArray).mutableCopy() as! NSMutableArray
                    self.setSticker()
                } else {
                    self.lblCategory.text = "Select Category"
                    self.dicCategory = [:]
                    for view in self.sView.subviews {
                        view.removeFromSuperview()
                    }
                    self.showAlert(strMessage: dic["ResponseMsg"] as! String)
                }
            } else {
                self.lblCategory.text = "Select Category"
                self.dicCategory = [:]
                for view in self.sView.subviews {
                    view.removeFromSuperview()
                }
                let alert = UIAlertController(title: "MESSAGE", message: "Network Problem", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { action in
                    self.getSticker()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: Tableview Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryMain.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        var dic : NSMutableDictionary = [:]
        dic = self.aryMain.object(at: indexPath.row) as! NSMutableDictionary
        
        cell.lblName.text = dic.object(forKey: "sub_cate_name") as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dicCategory = self.aryMain.object(at: indexPath.row) as! NSMutableDictionary
        strIcon = self.dicCategory["sub_cate_tray_image"] as! String
        self.lblCategory.text = self.dicCategory.value(forKey: "sub_cate_name") as? String
        viewCategory.isHidden = true
        getSticker()
    }
    
    // MARK: Button Action
    @objc func btnAddTapped(button: UIButton) {
        
        if self.aryMySticker.count >= 30 {
            showAlert(strMessage: "You can add max 20 Stickers to Sticker Pack")
        } else {
            var dicSub : NSMutableDictionary = [:]
            dicSub = (self.arySticker[button.tag] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            var strID : String = ""
            strID = dicSub["sticker_id"] as! String
            
            var isAvail : Bool = false
            for i in 0 ..< self.aryMySticker.count {
                var dic : NSMutableDictionary = [:]
                dic = (self.aryMySticker[i] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                if(dic["sticker_id"] as! String == strID) {
                    isAvail = true
                    break
                }
            }
            
            if isAvail {
                showAlert(strMessage: "Sticker Already Added")
            } else {
                
                let dic : NSMutableDictionary = [:]
                dic.setValue(dicSub["sticker_id"] as! String, forKey: "sticker_id")
                dic.setValue(dicSub["sticker_image"] as! String, forKey: "sticker_image")
                dic.setValue(dicSub["sub_cate_id"] as! String, forKey: "sub_cate_id")
                dic.setValue(strIcon, forKey: "tray_img")
                
                aryMySticker.add(dic)
                mySticker()
            }
        }
    }
    
    @objc func btnRemoveTapped(button: UIButton) {
        aryMySticker.removeObject(at: button.tag)
        mySticker()
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSelectCategoryClick(_ sender: Any) {
        if(self.aryMain.count > 0) {
            viewCategory.isHidden = false
        }
    }
    
    @IBAction func btnUpdateClick(_ sender: Any) {
        if (self.aryMySticker.count >= 3) {
            //save edited data
            var ary : NSMutableArray = []
            let defaults = UserDefaults.standard
            ary = (defaults.object(forKey: "custom_sticker") as! NSArray).mutableCopy() as! NSMutableArray
            
            var inNumber : Int = 0
            for i in 0 ..< ary.count {
                var dicSub : NSMutableDictionary = [:]
                dicSub = (ary[i] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                if(dicSub["pack_name"] as? String == dicSticker["pack_name"] as? String) {
                    inNumber = i
                    break
                }
            }
            ary.removeObject(at: inNumber)
            
            let dic : NSMutableDictionary = [:]
            dic.setValue(txtName.text, forKey: "pack_name")
            dic.setValue(dicSticker["tray_image"] as? String, forKey: "tray_image")
            dic.setValue(aryMySticker, forKey: "sticker")
            ary.add(dic)
            defaults.set(ary, forKey: "custom_sticker")
            
            dicSend = dic
            
            viewSuccess.isHidden = false
            
        } else {
            showAlert(strMessage: "Atleast 3 Sticker Required In Sticker Pack")
        }
    }
    
    @IBAction func btnCancelClick(_ sender: Any) {
        let alert = UIAlertController(title: "WARNING", message: "Changes you made will be Lost", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnOkClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSendToWhatsClick(_ sender: Any) {
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
    func setSticker() {
        
        for view in sView.subviews {
            view.removeFromSuperview()
        }
        
        var xPos : Float = 0.0
        for i in 0 ..< self.arySticker.count {
            var dicSub : NSMutableDictionary = [:]
            dicSub = (self.arySticker[i] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            
            let v = UIView(frame: CGRect(x: Double(xPos), y: 0.0, width: 100, height: 148))
            v.backgroundColor = UIColor.clear
            //v.layer.cornerRadius = 3.0
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
            imgView.sd_setImage(with: URL(string: dicSub["sticker_image"] as! String), completed: { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
                activityIndicator.removeFromSuperview()
            })
            
            
            
            let btn = UIButton(frame: CGRect(x: 8, y: 108, width: 84, height: 30))
            btn.tag = i
            btn.backgroundColor = UIColor(red: 48/255, green: 166/255, blue: 75/255, alpha: 1)
            btn.setTitle("ADD", for: UIControlState.normal)
            btn.addTarget(self, action: #selector(btnAddTapped(button:)), for: .touchUpInside)
            v.addSubview(btn)
            
            xPos = xPos + 100 + 8
            
            sView.addSubview(v)
            sView.contentSize = CGSize(width: Int(xPos-8), height: 0)
        }
    }
    
    func mySticker() {
        
        for view in mySview.subviews {
            view.removeFromSuperview()
        }
        
        var xPos : Float = 0.0
        for i in 0 ..< 30 {
            
            let v = UIView(frame: CGRect(x: Double(xPos), y: 0.0, width: 100, height: 148))
            v.backgroundColor = UIColor.clear
            v.layer.borderWidth = 0.5
            v.layer.borderColor = UIColor(red: 48/255, green: 166/255, blue: 75/255, alpha: 1).cgColor
            
            if(self.aryMySticker.count > i) {
                var dicSub : NSMutableDictionary = [:]
                dicSub = (self.aryMySticker[i] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                
                let imgView = UIImageView(frame: CGRect(x: 10, y: 10, width: 80, height: 80))
                imgView.backgroundColor = UIColor.clear
                
                let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
                activityIndicator.center = imgView.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.startAnimating()
                imgView.addSubview(activityIndicator)
                v.addSubview(imgView)
                imgView.sd_setImage(with: URL(string: dicSub["sticker_image"] as! String), completed: { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
                    activityIndicator.removeFromSuperview()
                })
                
                let btn = UIButton(frame: CGRect(x: 8, y: 108, width: 84, height: 30))
                btn.tag = i
                btn.backgroundColor = UIColor(red: 48/255, green: 166/255, blue: 75/255, alpha: 1)
                btn.setTitle("REMOVE", for: UIControlState.normal)
                btn.addTarget(self, action: #selector(btnRemoveTapped(button:)), for: .touchUpInside)
                v.addSubview(btn)
            } else {
                
                let lbl = UILabel(frame: CGRect(x: 10, y: 108, width: 80, height: 32))
                lbl.backgroundColor = UIColor.clear
                lbl.textAlignment = NSTextAlignment.center
                lbl.textColor = UIColor.black
                lbl.text = "\(i+1)"
                v.addSubview(lbl)
                
                let imgView = UIImageView(frame: CGRect(x: 10, y: 10, width: 80, height: 80))
                imgView.image = UIImage(named: "add")
                imgView.backgroundColor = UIColor.clear
                v.addSubview(imgView)
            }
            
            xPos = xPos + 100 + 8
            
            mySview.addSubview(v)
            mySview.contentSize = CGSize(width: Int(xPos-8), height: 0)
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
