//
//  DetailOfPackageViewController.swift
//  Sticker
//
//  Created by usuario on 13/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit

class DetailOfPackageViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var stickersStack: UIStackView!
    @IBOutlet weak var whatsappButton: UIButton!
    @IBOutlet weak var stickersStackH: NSLayoutConstraint!
    @IBOutlet weak var downloadStickersPackButton: UIButton!
    
    var StickerInnerPackHttpModel_:StickerInnerPackHttpModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.StickerInnerPackHttpModel_ = DetailOfPackageShare.shared.StickerInnerPackHttpModel
        
        //Check if the stickers is already saved or not
        let StickerPackage = StickersManager.shared.getRemotePackage(name: self.StickerInnerPackHttpModel_!.name)
        if((StickerPackage) == nil){
            packageStickersNotAlreadyDownloaded()
        }
        else{
            packageStickersAlreadyDownloaded()
        }
        
        //Set main image
        let imageUri = self.StickerInnerPackHttpModel_?.trayImageUri
        let url = URL(string: imageUri!)
        DispatchQueue.global().async {
            if(url != nil){
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    if(data == nil){
                        
                    }
                    else{
                        let imageIcon = UIImage(data: data!)
                        self.mainImage.image = imageIcon
                    }
                }
            }
        }
        
        //Name and publisher
        self.mainLabel.text = self.StickerInnerPackHttpModel_?.name
        self.secondaryLabel.text = self.StickerInnerPackHttpModel_?.publisher
        
        //Load all the stickers
        let stickers = self.StickerInnerPackHttpModel_?.stickers
        var UIStackView_ = self.getStack()
        var x = 1
        for StickerHttpModel_ in stickers! {
            
            let UIImageView_ = self.getUIImageView(url: StickerHttpModel_.uri)
            
            if(x == 4){
                x = 1
                let count = self.stickersStack.subviews.count
                print("self.stickersStack.subviews.count = \(count)")
                self.stickersStack.addArrangedSubview(UIStackView_)
                UIStackView_ = self.getStack()
            }
            else{
                x += 1
                let count = UIStackView_.subviews.count
                print("UIStackView_.subviews.count = \(count)")
                UIStackView_.addArrangedSubview(UIImageView_)
            }
        }
        
        let count = self.stickersStack.subviews.count
        if(count==1){
            stickersStackH.constant = stickersStackH.constant / 2
        }
    }
    
    func packageStickersAlreadyDownloaded(){
        self.deleteButton.isHidden = false
        self.downloadStickersPackButton.isHidden = true
        self.whatsappButton.isHidden = false
    }
    func packageStickersNotAlreadyDownloaded(){
        self.deleteButton.isHidden = true
        self.downloadStickersPackButton.isHidden = false
        self.whatsappButton.isHidden = true
    }
    func packageStickersAlreadyDownloadedInWhatsapp(){
        
    }
    
    func getStack() -> UIStackView{
        
        let UIStackView_ = UIStackView()
        UIStackView_.axis = .horizontal
        UIStackView_.distribution = .fillEqually
        UIStackView_.alignment = .center
        UIStackView_.spacing = 50
        
        return UIStackView_
    }
    
    func getUIImageView(url:String) -> UIImageView{
        
        let UIImageView_ = UIImageView()
        
        let url = URL(string: url)
        DispatchQueue.global().async {
            if(url != nil){
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    if(data == nil){
                        
                    }
                    else{
                        
                        let imageIcon = UIImage(data: data!)
                        UIImageView_.image = imageIcon
                    }
                }
            }
        }
        
        return UIImageView_
    }
    
    @IBAction func downloadStickersTouch(_ sender: Any) {
    }
    
    @IBAction func whatsappButtonTouch(_ sender: Any) {
    }
    
    @IBAction func deleteButtonTouch(_ sender: Any) {
        
        AlertManager.shared.showQuestion(UIViewController: self, question: "¿Seguro que quieres borrar el paquete de stickers?", onYes: {
            
            //Delete the sticker in the system self.StickerInnerPackHttpModel_
            StickersManager.shared.deleteRemotePackage(name: self.StickerInnerPackHttpModel_!.name)
            
            AlertManager.shared.showOk(UIViewController: self, message: "Paquete de stickers borrado")
            
            DispatchQueue.main.async() {
                self.packageStickersNotAlreadyDownloaded()
            }
            
        }, onNo: {
            
        })
    }
    
    @IBAction func backButtonTouch(_ sender: Any) {
        let returnTo = DetailOfPackageShare.shared.comesFrom
        ViewControllersManager.shared.setRoot(UIViewController: self, id: returnTo!)
    }
    
    @IBAction func downloadStickersPackageButtonTouch(_ sender: Any) {
        
        AlertManager.shared.showQuestion(UIViewController: self, question: "¿Seguro que quieres descargar el paquete de stickers?", onYes: {
            
            //Save the sticker in the system
            StickersManager.shared.addRemotePackage(StickerInnerPackHttpModel_: self.StickerInnerPackHttpModel_!)
            
            AlertManager.shared.showOk(UIViewController: self, message: "Paquete de stickers descargado")
            
            DispatchQueue.main.async() {
                self.packageStickersAlreadyDownloaded()
            }
            
        }, onNo: {
            
        })
    }
}
