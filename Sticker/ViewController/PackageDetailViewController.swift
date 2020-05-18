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
    
    var details:[PackageDetailTableRow] = []
    
    var packageName:String?
    var creatorPackage:String?
    
    var StickerPackage:StickerPackage?
    @IBOutlet weak var imgPackage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        //Get needed params
        if(PackageDetailShare.shared.StickerPackage == nil){
            AlertManager.shared.showOk(UIViewController: self, message: "Error interno, porfavor contacta a soporte")
        }
        else{
            
            self.StickerPackage = PackageDetailShare.shared.StickerPackage
            self.labelPackageName.text = self.StickerPackage?.name
            self.labelCreator.text = self.StickerPackage?.creator
            
            let trayImage = StickerPackage?.trayImage
            if(trayImage != nil){
                let UIImage_ = UIImage(data: trayImage!, scale: 1.0)
                self.imgPackage.image = UIImage_
            }
            
            self.packageName = self.StickerPackage?.name
            self.creatorPackage = self.StickerPackage?.creator
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? DetailPackageTableViewCell else {
            return UITableViewCell()
        }
        
        let stringValue = "\(indexPath.row)"
        print("index = " + stringValue)
        
        let stickers = self.StickerPackage?.stickers
        
        let StickerModel1 = stickers![indexPath.row]
        let StickerModel2 = stickers![indexPath.row + 1]
        let StickerModel3 = stickers![indexPath.row + 2]
        
        let image1 = UIImage(data: StickerModel1.image!)
        cell.img1.image = image1
        let image2 = UIImage(data: StickerModel2.image!)
        cell.img2.image = image2
        let image3 = UIImage(data: StickerModel3.image!)
        cell.img3.image = image3
        
        if(cell.img1.name == nil){
            
            cell.img1.name = self.StickerPackage?.name
            cell.img1.StickerModel = StickerModel1
            cell.img2.name = self.StickerPackage?.name
            cell.img2.StickerModel = StickerModel2
            cell.img3.name = self.StickerPackage?.name
            cell.img3.StickerModel = StickerModel3
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            cell.img1.isUserInteractionEnabled = true
            cell.img1.addGestureRecognizer(tapGestureRecognizer)
            
            let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            cell.img2.isUserInteractionEnabled = true
            cell.img2.addGestureRecognizer(tapGestureRecognizer2)
            
            let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            cell.img3.isUserInteractionEnabled = true
            cell.img3.addGestureRecognizer(tapGestureRecognizer3)
            
            let stringValue = "\(indexPath.row)"
            print("cell.img1.index = nil index = " + stringValue)
            
        }
        else{
            let stringValue = "\(indexPath.row)"
            print("cell.img1.index != nil index " + stringValue)
        }
        
        return cell
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! DetailsPackageUIImageView
        let name = tappedImage.name
        let StickerModel = tappedImage.StickerModel
        
        let indexS = "\(tappedImage.index)"
        print("tappedImage  index = " + indexS)
        
        //Open window to select image from gallery and edit it
        EditPackageImageShare.shared.stickerId = StickerModel?.id
        EditPackageImageShare.shared.stickerImage = true
        EditPackageImageShare.shared.name = name
        EditPackageImageShare.shared.UIImageView = tappedImage
        EditPackageImageShare.shared.UIViewController = self
        ViewControllersManager.shared.setRoot(UIViewController: self, id: "EditPackageImageViewController")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
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
            StickersManager.shared.deleteCustomPackage(name: self.StickerPackage!.name!)
            
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
        
        //Open window to select image from gallery and edit it
        EditPackageImageShare.shared.UIImageView = imgPackage
        EditPackageImageShare.shared.UIViewController = self
        EditPackageImageShare.shared.trayImage = true
        EditPackageImageShare.shared.name = self.packageName
        ViewControllersManager.shared.setRoot(UIViewController: self, id: "EditPackageImageViewController")
    }
    
    @IBAction func btnEditPackageInfoPressed(_ sender: Any) {
        
        showPackageDialog()
    }
        
    private func showPackageDialog(){
        
        //Show dialog to edit sticker package
        TwoDialogManager.shared.showTwoEdits(title: "Editar paquete", subtitle: "Por favor, especifique el titulo y el creador del paquete", placeholderOne: "Nombre del paquete", placeholderSecond: "Creador", initValueOne: packageName, initValueTwo: creatorPackage, onOk:{txtPackageName,txtCreator in
        
            let packageName_ = txtPackageName.text
            let creatorPackage_ = txtCreator.text
            
            //Validate that has a package and creator
            if(packageName_!.isEmpty){
                AlertManager.shared.showOk(UIViewController: self, message: "Ingresa un nombre de paquete")
                self.showPackageDialog()
                return
            }
            if(creatorPackage_!.isEmpty){
                AlertManager.shared.showOk(UIViewController: self, message: "Ingresa un creador")
                self.showPackageDialog()
                return
            }
            
            //Check that the package name does not exists
            let StickerPackage = StickersManager.shared.getCustomPackageForName(name: packageName_!)
            if(StickerPackage != nil){
                AlertManager.shared.showOk(UIViewController: self, message: "Este paquete ya existe")
                self.showPackageDialog()
                return
            }
            
            //Update the new sticker package
            StickersManager.shared.updateCustomPackage(previousName: self.packageName!, name: packageName_!,creator: creatorPackage_!)
            self.StickerPackage?.name = packageName_!
            self.StickerPackage?.creator = creatorPackage_!
            
            self.packageName = txtPackageName.text
            self.creatorPackage = txtCreator.text
            
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
    
    @IBOutlet weak var img1: DetailsPackageUIImageView!
    @IBOutlet weak var img2: DetailsPackageUIImageView!
    @IBOutlet weak var img3: DetailsPackageUIImageView!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
