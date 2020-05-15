//
//  PackageDetailTableViewController.swift
//  Sticker
//
//  Created by usuario on 13/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit

class PackageDetailUIViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableStickers: PackageDetailBaseUITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var searchActive : Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableStickers.initTable()
        self.tableStickers.initSearchBar(searchBar: self.searchBar, searchButton: self.searchButton)
        self.tableStickers.parentViewController = self
        self.tableStickers.onShowSearchBar = {
            self.titleLabel.isHidden = true
        }
        tableStickers.onHideSearchBar = {
            self.titleLabel.isHidden = false
        }
        
        //Get the sticker package to preview
        let StickerPackageHttpModel_ = PackageDetailUIShare.shared.StickerPackageHttpModel_
        let stickerPack = StickerPackageHttpModel_!.stickerPack
        
        //Load data in table
        self.tableStickers.loadData(data: stickerPack!)
        
        //Show publicity if applies
        AddsManager.shared.showAddIfApply(UIViewController: self)
    }
    
    @IBAction func backButtonTouch(_ sender: Any) {
        ViewControllersManager.shared.setRoot(UIViewController: self, id: "PrincipalViewController")
    }
}
