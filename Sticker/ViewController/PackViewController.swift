//
//  PackViewController.swift
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

class PackViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,GADInterstitialDelegate  {

    var strTitle : String = ""
    var catID : String = ""
    var subCatID : String = ""
    var strTrayUrl : String = ""
    var aryList : NSMutableArray = []
    private var stickerPacks: [StickerPack] = []
    var stickerPack: StickerPack!
    var dicMain : NSMutableDictionary = [:]
    var dicFinal : Dictionary<String,Any> = [:]
    
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet private weak var stickersCollectionView: UICollectionView!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var imgTray: UIImageView!
    @IBOutlet weak var lblEx: UILabel!
    
    var iApp : String = ""
    var aApp : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        verifyURL(urlPath: I_App, completion: { (isOK) in
            if isOK {
                self.iApp = I_App
            } else {
                self.iApp = ""
            }
        })
        verifyURL(urlPath: A_App, completion: { (isOK) in
            if isOK {
                self.aApp = A_App
            } else {
                self.aApp = ""
            }
        })
        getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Retrive data from server
    func getData() {
    
        lblTitle.text = strTitle
        
        /// Register StickerCell
        stickersCollectionView.register(StickerCell.self, forCellWithReuseIdentifier: "StickerCell")
        btnDownload.layer.cornerRadius = 3.0
        btnDownload.layer.masksToBounds = true
        
        let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.center = imgTray.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        imgTray.addSubview(activityIndicator)
        imgTray.sd_setImage(with: URL(string: strTrayUrl), completed: { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
            activityIndicator.removeFromSuperview()
        })
        
        let parameters: Parameters = ["sub_cate_id": subCatID]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Alamofire.request(API_STICKER_LIST, method: .post, parameters: parameters).responseJSON { response in
    
            MBProgressHUD.hide(for: self.view, animated: true)
            if(response.result.isSuccess) {
                var dic: NSDictionary = [:]
                dic = response.result.value as! NSDictionary
                
                if(dic["ResponseCode"] as! String == "1") {
                    self.aryList = (dic["data"] as! NSArray).mutableCopy() as! NSMutableArray
                    if self.aryList.count > 0 {
                        self.imgTray.isHidden = false
                        self.lblTitle.isHidden = false
                        self.lblTotal.isHidden = false
                        self.btnDownload.isHidden = false
                        self.lblEx.isHidden = false
                        self.lblTotal.text = "\(self.aryList.count) Stickers"
                        self.stickersCollectionView.reloadData()
                    } else {
                        self.imgTray.isHidden = true
                        self.lblTitle.isHidden = true
                        self.lblTotal.isHidden = true
                        self.btnDownload.isHidden = true
                        self.lblEx.isHidden = true
                        self.showAction(strMessage: "No Sticker Available")
                    }
                } else {
                    self.imgTray.isHidden = true
                    self.lblTitle.isHidden = true
                    self.lblTotal.isHidden = true
                    self.btnDownload.isHidden = true
                    self.lblEx.isHidden = true
                    self.showAction(strMessage: dic["ResponseMsg"] as! String)
                }
            } else {
                self.imgTray.isHidden = true
                self.lblTitle.isHidden = true
                self.lblTotal.isHidden = true
                self.btnDownload.isHidden = true
                self.lblEx.isHidden = true
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
        let width = collectionView.bounds.width
        let cellWidth = (width - 30) / 4
        return CGSize(width: cellWidth, height: cellWidth)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (stickerPack != nil) {
            return stickerPack.stickers.count
        } else {
            return aryList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerCell", for: indexPath) as! StickerCell
        
        cell.layer.borderWidth = 0.3
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        var dic : NSMutableDictionary = [:]
        dic = (aryList.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        for view in cell.subviews {
            view.removeFromSuperview()
        }
        
        let imgSticker = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
        
        let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.center = imgSticker.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        imgSticker.addSubview(activityIndicator)
        cell.addSubview(imgSticker)
        
        imgSticker.sd_setImage(with: URL(string: dic["sticker_image"] as! String), completed: { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
            activityIndicator.removeFromSuperview()
        })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        var dic : NSMutableDictionary = [:]
        dic = (aryList.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        showActionSheet(overCell: cell!, strUrl: dic["sticker_image"] as! String)
    }
    
    // MARK: Button Action
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDownloadClick(_ sender: Any) {
        let urlWhats = "whatsapp://"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL) {
                    self.makePack()
                } else {
                    showAlert(strMessage: "Whatsapp is not installed in your device.")
                }
            }
        }
    }
    
    // MARK: Method
    func showActionSheet(overCell cell: UICollectionViewCell,strUrl: String) {
        let actionSheet: UIAlertController = UIAlertController(title: "\n\n\n\n\n\n", message: "", preferredStyle: .actionSheet)
        
        actionSheet.popoverPresentationController?.sourceView = cell.contentView
        actionSheet.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: cell.contentView.bounds.midX, y: cell.contentView.bounds.midY, width: 0, height: 0)
        
        
        actionSheet.addAction(UIAlertAction(title: "COPY TO CLIPBOARD", style: .default, handler: { action in
            let url = URL(string:strUrl)
            if let data = try? Data(contentsOf: url!)
            {
                let image: UIImage = UIImage(data: data)!
                Interoperability.copyImageToPasteboard(image: image)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "SHARE", style: .default, handler: { action in
            self.showShareSheet(imgUrl: strUrl)
        }))
        actionSheet.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
        
        let url = URL(string:strUrl)
        if let data = try? Data(contentsOf: url!)
        {
            let image: UIImage = UIImage(data: data)!
            actionSheet.addImageView(withImage: image)
        }
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func showShareSheet(imgUrl: String) {
        
        var img : UIImage!
        let url = URL(string:imgUrl)
        if let data = try? Data(contentsOf: url!)
        {
            img = UIImage(data: data)!
        }
        
        guard let image = img else {
            return
        }
        
        let shareViewController: UIActivityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        shareViewController.popoverPresentationController?.sourceView = self.view
    shareViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        shareViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        present(shareViewController, animated: true, completion: nil)
    }
    
    func sendSticker() {
        let loadingAlert: UIAlertController = UIAlertController(title: "Sending to WhatsApp", message: "\n\n", preferredStyle: .alert)
        loadingAlert.addSpinner()
        present(loadingAlert, animated: true, completion: nil)
        
        stickerPack.sendToWhatsApp { completed in
            loadingAlert.dismiss(animated: true, completion: nil)
        }
    }
    
    func showAction(strMessage: String)  {
        let alertController = UIAlertController(title: "ALERT", message: strMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(strMessage: String)  {
        let alert = UIAlertController(title: "MESSAGE", message: strMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func makePack()  {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let aryStickerPack : NSMutableArray = []
        
        let aryBlank : NSMutableArray = []
        aryBlank.add("")
        aryBlank.add("")
        
        dicMain.setValue(iApp, forKey: "ios_app_store_link")
        dicMain.setValue(aApp, forKey: "android_play_store_link")
        
        let dicStickerPack : NSMutableDictionary = [:]
        dicStickerPack.setValue(subCatID, forKey: "identifier")
        dicStickerPack.setValue(strTitle, forKey: "name")
        dicStickerPack.setValue("Loop Infosol", forKey: "publisher")
        dicStickerPack.setValue(strTrayUrl, forKey: "tray_image_file")
        dicStickerPack.setValue("", forKey: "publisher_website")
        dicStickerPack.setValue("", forKey: "privacy_policy_website")
        dicStickerPack.setValue("", forKey: "license_agreement_website")
        
        let arySticker : NSMutableArray = []
        
        for i in 0..<aryList.count
        {
            var dic : NSMutableDictionary = [:]
            dic = (aryList.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            let dicSticker : NSMutableDictionary = [:]
            dicSticker.setValue(dic["sticker_image"] as! String, forKey: "image_file")
            dicSticker.setValue(aryBlank, forKey: "emojis")
            arySticker.add(dicSticker)
        }
        
        dicStickerPack.setValue(arySticker, forKey: "stickers")
        
        aryStickerPack.add(dicStickerPack)
        
        dicMain.setValue(aryStickerPack, forKey: "sticker_packs")
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: dicMain,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .utf8)
            let data = theJSONText?.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data!, options : .allowFragments) as? Dictionary<String,Any>
                {
                    dicFinal = jsonArray
                    fetchStickerPacks()
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    private func fetchStickerPacks() {
        StickerPackManager.fetchStickerPacks(fromJSON: dicFinal) { stickerPacks in
            self.stickerPacks = stickerPacks
            self.stickerPack = stickerPacks[0]
            
            if(self.stickerPack.stickers.count > 0) {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.sendSticker()
            }
        }
    }
    
    func verifyURL(urlPath: String, completion: @escaping (_ isOK: Bool)->()) {
        if let url = URL(string: urlPath) {
            var request = URLRequest(url: url)
            request.httpMethod = "HEAD"
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let httpResponse = response as? HTTPURLResponse, error == nil {
                    completion(httpResponse.statusCode == 200)
                } else {
                    completion(false)
                }
            })
            task.resume()
        } else {
            completion(false)
        }
    }
    
}
