//
//  AlertManager.swift
//  Sticker
//
//  Created by usuario on 03/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation
import SCLAlertView

class AlertManager {
    
    static let shared = AlertManager()
    
    private init() {
    }
    
    func showOk(UIViewController:UIViewController, message:String){
        
        let alert = UIAlertController(title: "Stickers", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        UIViewController.present(alert, animated: true)
    }
    
    func showTwoEdits(title:String, subtitle:String, placeholderOne:String, placeholderSecond:String, onOk: @escaping () -> Void,onCancel: @escaping () -> Void){
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false,
            showCircularIcon:false
        )
        
        // Add a text field
        let alert = SCLAlertView(appearance: appearance)
        let txtPackageCreator = alert.addTextField(placeholderOne)
        txtPackageCreator.layer.borderWidth = 0
        let txtCreator = alert.addTextField(placeholderSecond)
        txtCreator.layer.borderWidth = 0
        alert.addButton("CANCELAR", backgroundColor: UIColor.init(hexString: "#375394"), textColor: UIColor.white) {
            onOk()
        }
        alert.addButton("OK", backgroundColor: UIColor.init(hexString: "#375394"), textColor: UIColor.white) {
            onCancel()
        }
        let dialog:SCLAlertViewResponder = alert.showEdit("Edit View", subTitle: "")
        dialog.setTitle(title)
        dialog.setSubTitle(subtitle)
    }
}
