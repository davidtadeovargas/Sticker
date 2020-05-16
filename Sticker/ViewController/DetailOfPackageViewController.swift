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
    
    var StickerInnerPackHttpModel_:StickerInnerPackHttpModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.StickerInnerPackHttpModel_ = DetailOfPackageShare.shared.StickerInnerPackHttpModel
        
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
                self.stickersStack.addArrangedSubview(UIStackView_)
                UIStackView_ = self.getStack()
            }
            else{
                x += 1
                let count = UIStackView_.subviews.count
                UIStackView_.addArrangedSubview(UIImageView_)
            }
        }
        
        let count = self.stickersStack.subviews.count
        if(count==1){
            stickersStackH.constant = stickersStackH.constant / 2
        }
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
    }
    
    @IBAction func backButtonTouch(_ sender: Any) {
        
        ViewControllersManager.shared.setRoot(UIViewController: self, id: "PackageDetailUIViewController")
    }
}
