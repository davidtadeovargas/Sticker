//
//  StickersMakerViewController.swift
//  Sticker
//
//  Created by usuario on 03/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit
import SCLAlertView

class StickersMakerViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imgNoStickers: UIImageView!
    @IBOutlet weak var btnPackageStickers: UIButton!
    @IBOutlet weak var btnStickersMaker: UIButton!
    @IBOutlet weak var tableStickers: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableStickers.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnPackageStickersClicked(_ sender: Any) {
        ViewControllersManager.shared.setRoot(UIViewController: self, id: "PrincipalViewController")
    }
    
    @IBAction func btnStickersMakerClicked(_ sender: Any) {
    }
    
    @IBAction func btnAddStickerClicked(_ sender: Any) {
        
        //Show google add if apply
        AddsManager.shared.showAddIfApply(UIViewController: self)
        
        //Show dialog to create sticker package
        AlertManager.shared.showTwoEdits(title: "Crear nuevo paquete", subtitle: "Por favor, especifique el titulo y el creador del paquete", placeholderOne: "Nombre del paquete", placeholderSecond: "Creador", onOk: {
            
            //Save the new sticker package
            
        }, onCancel: {})
    }
}
