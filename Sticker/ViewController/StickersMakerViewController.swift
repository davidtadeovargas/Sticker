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
    @IBOutlet weak var tableStickers: StickersMakerUITableView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var packageName:String?
    var creatorPackage:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remove borders
        searchBar.backgroundImage = UIImage()
        
        let customStickers = StickersManager.shared.getAllCustomPackages()
        if(customStickers.count == 0){
            self.tableStickers.isHidden = true
        }
        else{
            
            self.tableStickers.initTable(TableType_: TableType.TABLE_CUSTOMER_STICKERS_CACHE)
            self.tableStickers.initSearchBar(searchBar: searchBar, searchButton: searchButton)
            self.tableStickers.parentViewController = self
            self.tableStickers.loadData(data: customStickers)
            self.tableStickers.onShowSearchBar = {
                self.titleLabel.isHidden = true
            }
            self.tableStickers.onHideSearchBar = {
                self.titleLabel.isHidden = false
            }
            self.tableStickers.didSelectRowAt = {index,cell,model in
                
                //Cast the row model
                let StickerPackage_ = model as! StickerPackage
                
                //Open the next screen to view the package info
                PackageDetailShare.shared.StickerPackage = StickerPackage_ //Params for the screen
                ViewControllersManager.shared.setRoot(UIViewController: self, id:"PackageDetailViewController")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
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
        showPackageDialog()
    }
    
    private func showPackageDialog(){
        
        //Show dialog to create sticker package
        TwoDialogManager.shared.showTwoEdits(title: "Crear nuevo paquete", subtitle: "Por favor, especifique el titulo y el creador del paquete", placeholderOne: "Nombre del paquete", placeholderSecond: "Creador", initValueOne: packageName, initValueTwo: creatorPackage, onOk:{txtPackageName,txtCreator in
        
            self.packageName = txtPackageName.text
            self.creatorPackage = txtCreator.text
            
            //Validate that has a package and creator
            if(self.packageName!.isEmpty){
                AlertManager.shared.showOk(UIViewController: self, message: "Ingresa un nombre de paquete")
                self.showPackageDialog()
                return
            }
            if(self.creatorPackage!.isEmpty){
                AlertManager.shared.showOk(UIViewController: self, message: "Ingresa un creador")
                self.showPackageDialog()
                return
            }
            
            //Check that the packa name does not exists
            let StickerPackage = StickersManager.shared.getCustomPackageForName(name: self.packageName!)
            if(StickerPackage != nil){
                AlertManager.shared.showOk(UIViewController: self, message: "Este paquete ya existe")
                self.showPackageDialog()
                return
            }
            
            //Save the new sticker package
            let StickerPackage_ = StickersManager.shared.addCustomPackage(name: self.packageName!,creator: self.creatorPackage!)
            
            //Open the next screen
            PackageDetailShare.shared.StickerPackage = StickerPackage_ //Params for the screen
            ViewControllersManager.shared.setRoot(UIViewController: self, id:"PackageDetailViewController")
            
        }, onCancel: {})
    }
}
