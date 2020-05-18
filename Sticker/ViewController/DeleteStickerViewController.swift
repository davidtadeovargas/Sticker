//
//  DeleteStickerViewController.swift
//  Sticker
//
//  Created by usuario on 18/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit

class DeleteStickerViewController: UIViewController {
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = DeleteStickerShare.shared.imageData
        self.mainImage.image = UIImage(data: data!)
        
    }
    
    @IBAction func yesButtonTouch(_ sender: Any) {
        
        if(DeleteStickerShare.shared.onOk != nil){
            DeleteStickerShare.shared.onOk!()
        }
    
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func noButtonTouch(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
