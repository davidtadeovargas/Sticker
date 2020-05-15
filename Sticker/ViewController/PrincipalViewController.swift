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
        self.tableStickers.initTable()
        tableStickers.initSearchBar(searchBar: searchBar, searchButton: searchButton)
        tableStickers.parentViewController = self
        tableStickers.onShowSearchBar = {
            self.titleLabel.isHidden = true
        }
        tableStickers.onHideSearchBar = {
            self.titleLabel.isHidden = false
        }
        
        if(PrincipalShare.shared.StickerPackageHttpModelArray == nil){
            
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
                        
                        //Save in cache
                        PrincipalShare.shared.StickerPackageHttpModelArray = DataHttpModel_.data!
                    }
                }
            }
            StickerPackageRequest_.request()
        }
        else{
            
            //Load cache data
            let stickersArray = PrincipalShare.shared.StickerPackageHttpModelArray
            self.tableStickers.loadData(data: stickersArray!)
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
        ViewControllersManager.shared.setRoot(UIViewController: self, id: "SalvadoViewController")
    }
    
    @IBAction func btnHamburguesaClicked(_ sender: Any) {
        
    }
}
