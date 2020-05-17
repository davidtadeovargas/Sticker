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

        self.tableStickers.initTable(TableType_:TableType.TABLE_PACKAGE_DETAIL_CACHE)
        self.tableStickers.initSearchBar(searchBar: self.searchBar, searchButton: self.searchButton)
        self.tableStickers.parentViewController = self
        self.tableStickers.onShowSearchBar = {
            self.titleLabel.isHidden = true
        }
        self.tableStickers.onHideSearchBar = {
            self.titleLabel.isHidden = false
        }
        self.tableStickers.didSelectRowAt = { index,cell,model in
            
            //Cast model
            let StickerInnerPackHttpModel = model as! StickerInnerPackHttpModel
            
            //Open the detail package view
            DetailOfPackageShare.shared.StickerInnerPackHttpModel = StickerInnerPackHttpModel
            DetailOfPackageShare.shared.comesFrom = "PackageDetailUIViewController"
            ViewControllersManager.shared.setRoot(UIViewController: self, id: "DetailOfPackageViewController")
            
        }
        
        var stickerPack:[StickerInnerPackHttpModel]
        if(PackageDetailUIShare.shared.data != nil){
            stickerPack = PackageDetailUIShare.shared.data as! [StickerInnerPackHttpModel]
            self.titleLabel.text = "Salvados"
            
            //Reset previus data
            PackageDetailUIShare.shared.data = nil
        }
        else{
            //Get the sticker package to preview
            let StickerPackageHttpModel_ = PackageDetailUIShare.shared.StickerPackageHttpModel_
            stickerPack = StickerPackageHttpModel_!.stickerPack
            
            self.titleLabel.text = "Stickers Suavecitos"
        }
        
        //Load data in table
        self.tableStickers.loadData(data: stickerPack)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Show publicity if applies
        AddsManager.shared.showNow(UIViewController: self)
    }
    
    @IBAction func backButtonTouch(_ sender: Any) {
        let returnTo = PackageDetailUIShare.shared.comesFrom
        ViewControllersManager.shared.setRoot(UIViewController: self, id: returnTo!)
    }
}
