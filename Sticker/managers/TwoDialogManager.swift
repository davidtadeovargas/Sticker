//
//  TwoDialogManager.swift
//  Sticker
//
//  Created by usuario on 05/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation
import SCLAlertView

class TwoDialogManager: NSObject, UITextFieldDelegate {
    
    static let shared = TwoDialogManager()
    
    var txtLen:Int?
    
    
    private override init() {
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
               replacementString string: String) -> Bool {

        guard let preText = textField.text as NSString?,
            preText.replacingCharacters(in: range, with: string).count <= 10 else {
            return false
        }

        return true
    }
    
    func showTwoEdits(title:String, subtitle:String, placeholderOne:String, placeholderSecond:String, initValueOne:String?, initValueTwo:String?, txtLen:Int = 30, onOk: @escaping ( _ UITextField1:UITextField, _ UITextField2:UITextField) -> Void,onCancel: @escaping () -> Void){
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false,
            showCircularIcon:false
        )
        
        self.txtLen = txtLen
        
        // Add a text field
        let alert = SCLAlertView(appearance: appearance)
        let txtOne = alert.addTextField(placeholderOne)
        txtOne.delegate = self
        if(initValueOne != nil){
            txtOne.text = initValueOne
        }
        txtOne.layer.borderWidth = 0
        let txtTwo = alert.addTextField(placeholderSecond)
        txtTwo.delegate = self
        if(initValueTwo != nil){
            txtTwo.text = initValueTwo
        }
        txtTwo.layer.borderWidth = 0
        alert.addButton("OK", backgroundColor: UIColor.init(hexString: "#375394"), textColor: UIColor.white) {
            onOk(txtOne,txtTwo)
        }
        alert.addButton("CANCELAR", backgroundColor: UIColor.init(hexString: "#375394"), textColor: UIColor.white) {
            onCancel()
        }
        let dialog:SCLAlertViewResponder = alert.showEdit("Edit View", subTitle: "")
        dialog.setTitle(title)
        dialog.setSubTitle(subtitle)
    }
}
