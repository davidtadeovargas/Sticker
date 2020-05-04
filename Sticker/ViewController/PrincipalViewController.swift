//
//  PrincipalViewController.swift
//  Sticker
//
//  Created by usuario on 03/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit

class PrincipalViewController: UIViewController {
    
    @IBOutlet weak var btnStickersPackage: UIButton!
    @IBOutlet weak var btnStickersMaker: UIButton!
    @IBOutlet weak var imgNoStickers: UIImageView!
    @IBOutlet weak var tableStickers: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableStickers.isHidden = true
    }
    

    @IBAction func btnPackageStickersClicked(_ sender: Any) {
        
    }
    
    @IBAction func btnStickersMakerClicked(_ sender: Any) {
        ViewControllersManager.shared.setRoot(UIViewController: self, id: "StickersMakerViewController")
    }
    
    @IBAction func btnExplorarClicked(_ sender: Any) {
    }
    
    @IBAction func btnSalvadoClicked(_ sender: Any) {
        ViewControllersManager.shared.setRoot(UIViewController: self, id: "SalvadoViewController")
    }
    
    @IBAction func btnHamburguesaClicked(_ sender: Any) {
        
    }
}
