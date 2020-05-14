//
//  AlertManager.swift
//  Sticker
//
//  Created by usuario on 03/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation

class AlertManager {
    
    static let shared = AlertManager()
    
    private init() {
    }
    
    func showOk(UIViewController:UIViewController, message:String){
        
        let alert = UIAlertController(title: "Stickers", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        UIViewController.present(alert, animated: true)
    }
    
    func showError(UIViewController:UIViewController, message:String){
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        UIViewController.present(alert, animated: true)
    }
    
    func showOkAction(UIViewController:UIViewController, message:String, onYes: @escaping () -> Void){
        
        let alert = UIAlertController(title: "Stickers", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            onYes()
        }))
        UIViewController.present(alert, animated: true)
    }
    
    func showQuestion(UIViewController:UIViewController, question:String, onYes: @escaping () -> Void, onNo: @escaping () -> Void){
        
        let refreshAlert = UIAlertController(title: "Stickers", message: question, preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Si", style: .default, handler: { (action: UIAlertAction!) in
            onYes()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            onNo()
        }))
        UIViewController.present(refreshAlert, animated: true, completion: nil)
    }
}
