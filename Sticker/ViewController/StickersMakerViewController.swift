//
//  StickersMakerViewController.swift
//  Sticker
//
//  Created by usuario on 03/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit

class StickersMakerViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imgNoStickers: UIImageView!
    @IBOutlet weak var btnPackageStickers: UIButton!
    @IBOutlet weak var btnStickersMaker: UIButton!
    @IBOutlet weak var tableStickers: UITableView!
    
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
}
