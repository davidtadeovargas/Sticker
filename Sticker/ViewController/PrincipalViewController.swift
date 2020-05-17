//
//  PrincipalViewController.swift
//  Sticker
//
//  Created by usuario on 03/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit

class PrincipalViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var btnStickersPackage: UIButton!
    @IBOutlet weak var btnStickersMaker: UIButton!
    @IBOutlet weak var imgNoStickers: UIImageView!
    @IBOutlet weak var tableStickers: PrincipalBaseUITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        //Init table
        self.tableStickers.initTable(TableType_: TableType.TABLE_PRINCIPAL_CACHE)
        self.tableStickers.initSearchBar(searchBar: searchBar, searchButton: searchButton)
        self.tableStickers.parentViewController = self
        self.tableStickers.onShowSearchBar = {
            self.titleLabel.isHidden = true
        }
        self.tableStickers.onHideSearchBar = {
            self.titleLabel.isHidden = false
        }
        self.tableStickers.didSelectRowAt = {index,cell,model in
            
            //Cast the row model
            let StickerPackageHttpModel_ = model as! StickerPackageHttpModel
            
        }
        self.tableStickers.stickerPackageTouch = { StickerInnerPackHttpModel in
            
            //Open the package detal
            DetailOfPackageShare.shared.StickerInnerPackHttpModel = StickerInnerPackHttpModel
            DetailOfPackageShare.shared.comesFrom = "PrincipalViewController"
            ViewControllersManager.shared.setRoot(UIViewController: self,id: "DetailOfPackageViewController")
        }
        
        if(!self.tableStickers.dataInCache()){
            
            let StickerPackageRequest_ = RequestsFactor.shared.getStickerPackageRequest()
            StickerPackageRequest_.UIViewController_ = self
            StickerPackageRequest_.onError = { Error in
                AlertManager.shared.showError(UIViewController: self, message: Error.localizedDescription)
                DispatchQueue.main.async {
                    self.tableStickers.isHidden = true
                }
            }
            StickerPackageRequest_.onFinish = { DataHttpModel_ in
             
                DispatchQueue.main.async {
                    
                    //No items hide the table
                    if(DataHttpModel_.data?.count == 0){
                        self.tableStickers.isHidden = true
                    }
                    else{ //Yes there are items
                        
                        //Load items in the table
                        self.tableStickers.loadData(data: DataHttpModel_.data!)
                    }
                }
            }
            StickerPackageRequest_.request()
        }
        else{
            
            //Load cache data
            self.tableStickers.loadDataFromCache()
        }
    }
    
    @IBAction func btnPackageStickersClicked(_ sender: Any) {
        
    }
    
    @IBAction func btnStickersMakerClicked(_ sender: Any) {
        ViewControllersManager.shared.setRoot(UIViewController: self, id: "StickersMakerViewController")
    }
    
    @IBAction func btnExplorarClicked(_ sender: Any) {
    }
    
    @IBAction func btnSalvadoClicked(_ sender: Any) {
        
        //Open the detail package view
        let stickers = StickersManager.shared.getAllRemotePackages()
        PackageDetailUIShare.shared.data = stickers
        PackageDetailUIShare.shared.comesFrom = "PrincipalViewController"
        ViewControllersManager.shared.setRoot(UIViewController: self, id: "PackageDetailUIViewController")
    }
    
    @IBAction func btnHamburguesaClicked(_ sender: Any) {
        
    }
}
