//
//  StickersMakerViewController.swift
//  Sticker
//
//  Created by usuario on 03/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit
import SCLAlertView

class StickersMakerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imgNoStickers: UIImageView!
    @IBOutlet weak var btnPackageStickers: UIButton!
    @IBOutlet weak var btnStickersMaker: UIButton!
    @IBOutlet weak var tableStickers: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    
    var searchActive : Bool = false
    
    var customStickers:[StickerPackage]?
    var customStickersTmp = [StickerPackage]()
    
    var packageName:String?
    var creatorPackage:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remove borders
        searchBar.backgroundImage = UIImage()
        
        customStickers = StickersManager.shared.getAllCustomPackages()
        if(customStickers!.count == 0){
            tableStickers.isHidden = true
        }
        else{
            tableStickers.delegate = self
            tableStickers.dataSource = self
        }
        
        //List for search bar for the table of stickers
        customStickersTmp = customStickers!
        
        searchBar.delegate = self
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        customStickersTmp = customStickers!.filter({ (StickerPackage) -> Bool in
            
            let StickerPackageTmp: StickerPackage = StickerPackage
            
            return (StickerPackageTmp.name?.starts(with: searchText))!
        })
        if(customStickersTmp.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableStickers.reloadData()
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? StickersMakerTableViewCell else {
            return UITableViewCell()
        }
        
        let StickerPackage:StickerPackage = self.customStickersTmp[indexPath.row]
        
        cell.image_.image = UIImage(named: "add_icon.png")
        cell.labelPackageName.text = StickerPackage.name
        cell.labelCreator.text = StickerPackage.creator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard (tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? StickersMakerTableViewCell) != nil else {
                return
        }
        
        let StickerPackage_:StickerPackage = self.customStickersTmp[indexPath.row]
        
        //Open the next screen to view the package info
        PackageDetailShare.shared.StickerPackage = StickerPackage_ //Params for the screen
        ViewControllersManager.shared.setRoot(UIViewController: self, id:"PackageDetailViewController")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customStickersTmp.count
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

class StickersMakerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var image_: UIImageView!
    @IBOutlet weak var stackStickers: UIStackView!
    @IBOutlet weak var labelPackageName: UILabel!
    @IBOutlet weak var labelCreator: UILabel!
    @IBOutlet weak var btnView: UIButton!
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
