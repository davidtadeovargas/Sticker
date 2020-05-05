//
//  PackageDetailViewController.swift
//  Sticker
//
//  Created by usuario on 04/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit

class PackageDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelPackageName: UILabel!
    @IBOutlet weak var labelCreator: UILabel!
    
    var packageName:String?
    var creatorPackage:String?
    
    var StickerPackage:StickerPackage?
    @IBOutlet weak var imgPackage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //Get needed params
        if(PackageDetailShare.shared.StickerPackage == nil){
            AlertManager.shared.showOk(UIViewController: self, message: "Error interno, porfavor contacta a soporte")
        }
        else{
            self.StickerPackage = PackageDetailShare.shared.StickerPackage
            labelPackageName.text = self.StickerPackage?.name
            labelCreator.text = self.StickerPackage?.creator
            
            self.packageName = self.StickerPackage?.name
            self.creatorPackage = self.StickerPackage?.creator
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? DetailPackageTableViewCell else {
            return UITableViewCell()
        }
        
        cell.img1.image = UIImage(named: "add_icon.png")
        cell.img2.image = UIImage(named: "add_icon.png")
        cell.img3.image = UIImage(named: "add_icon.png")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        ViewControllersManager.shared.setRoot(UIViewController: self, id: "StickersMakerViewController")
    }
    
    @IBAction func btnDeletePressed(_ sender: Any) {
        
        AlertManager.shared.showQuestion(UIViewController: self, question: "¿Seguro que quieres borrar el paquete?", onYes: {
            
            //Delete the package
            StickersManager.shared.deletePackage(name: self.StickerPackage!.name!)
            
            //Notice the user about the package deletion
            AlertManager.shared.showOkAction(UIViewController: self, message: "Paquete removido correctamente", onYes: {
              
                DispatchQueue.main.async() {
                    //Route the user
                    ViewControllersManager.shared.setRoot(UIViewController: self, id: "StickersMakerViewController")
                }
            })
            
        }, onNo: {})
    }
    
    @IBAction func btnEditPackageImagePressed(_ sender: Any) {
    }
    
    @IBAction func btnEditPackageInfoPressed(_ sender: Any) {
        
        showPackageDialog()
    }
        
    private func showPackageDialog(){
        
        //Show dialog to edit sticker package
        TwoDialogManager.shared.showTwoEdits(title: "Editar paquete", subtitle: "Por favor, especifique el titulo y el creador del paquete", placeholderOne: "Nombre del paquete", placeholderSecond: "Creador", initValueOne: packageName, initValueTwo: creatorPackage, onOk:{txtPackageName,txtCreator in
        
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
            
            //Update the new sticker package
            StickersManager.shared.updateCustomPackage(previousName: (self.StickerPackage?.name!)!, name: self.packageName!,creator: self.creatorPackage!)
            self.StickerPackage?.name = self.packageName!
            self.StickerPackage?.creator = self.creatorPackage!
            
            //Notice to the user
            AlertManager.shared.showOk(UIViewController: self, message: "Paquete actualizado")
            
            //Update controls
            DispatchQueue.main.async() {
                
                self.labelPackageName.text = self.packageName
                self.labelCreator.text = self.creatorPackage
            }
            
        }, onCancel: {})
    }
}

class DetailPackageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
