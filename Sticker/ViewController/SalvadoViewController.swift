//
//  SalvadoViewController.swift
//  Sticker
//
//  Created by usuario on 03/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit

class SalvadoViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnSalvado: UIButton!
    @IBOutlet weak var btnExplorar: UIButton!
    @IBOutlet weak var btnPackageStickers: UIButton!
    @IBOutlet weak var btnStickersMaker: UIButton!
    @IBOutlet weak var imgNoStickers: UIImageView!
    @IBOutlet weak var tableStickers: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableStickers.isHidden = true
        
        //Remove borders
        searchBar.backgroundImage = UIImage()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func btnPackageStickersClicked(_ sender: Any) {
    }
    
    @IBAction func btnStickersMakers(_ sender: Any) {
        ViewControllersManager.shared.setRoot(UIViewController: self, id: "StickersMakerViewController")
    }
    
    @IBAction func btnExplorarClicked(_ sender: Any) {
        ViewControllersManager.shared.setRoot(UIViewController: self, id: "PrincipalViewController")
    }
    
    @IBAction func btnSalvadoClicked(_ sender: Any) {
    }
}
