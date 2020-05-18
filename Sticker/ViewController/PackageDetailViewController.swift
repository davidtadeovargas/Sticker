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
        
        let index = indexPath.row
        
        let indexModel1:Int
        let indexModel2:Int
        let indexModel3:Int
        
        switch index {
            
            case 0:
                indexModel1 = 0
                indexModel2 = 1
                indexModel3 = 2
                break
            
            case 1:
                indexModel1 = 3
                indexModel2 = 4
                indexModel3 = 5
                break
            
            case 2:
                indexModel1 = 6
                indexModel2 = 7
                indexModel3 = 8
                break
            
            case 3:
                indexModel1 = 9
                indexModel2 = 10
                indexModel3 = 11
                break
            
            case 4:
                indexModel1 = 12
                indexModel2 = 13
                indexModel3 = 14
                break
            
            case 5:
                indexModel1 = 15
                indexModel2 = 16
                indexModel3 = 17
                break
            
            case 6:
                indexModel1 = 18
                indexModel2 = 19
                indexModel3 = 20
                break
            
            case 7:
                indexModel1 = 21
                indexModel2 = 22
                indexModel3 = 23
                break
            
            case 8:
                indexModel1 = 24
                indexModel2 = 25
                indexModel3 = 26
                break
            
            case 9:
                indexModel1 = 27
                indexModel2 = 28
                indexModel3 = 29
                break
            
            default:
                indexModel1 = 0
                indexModel2 = 0
                indexModel3 = 0
            
        }
        
        let stickers = self.StickerPackage?.stickers
        
        let StickerModel1 = stickers![indexModel1]
        let StickerModel2 = stickers![indexModel2]
        let StickerModel3 = stickers![indexModel3]
        
        let stringValue = "\(indexPath.row)"
        print("In index = " + stringValue + " we have ids: \(StickerModel1.id), \(StickerModel2.id) ,\(StickerModel3.id)")
        
        let image1 = UIImage(data: StickerModel1.image!)
        cell.img1.image = image1
        let image2 = UIImage(data: StickerModel2.image!)
        cell.img2.image = image2
        let image3 = UIImage(data: StickerModel3.image!)
        cell.img3.image = image3
        
        cell.img1.name = self.StickerPackage?.name
        cell.img1.StickerModel = StickerModel1
        cell.img2.name = self.StickerPackage?.name
        cell.img2.StickerModel = StickerModel2
        cell.img3.name = self.StickerPackage?.name
        cell.img3.StickerModel = StickerModel3
        
        //Add event for image 1
        let tapGestureRecognizer1:UITapGestureRecognizer
        if StickerModel1.alreadyImageSet! {
            tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(deleteStickerImageTapped(tapGestureRecognizer:)))
        }
        else{
            tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(setStickerImageTapped(tapGestureRecognizer:)))
        }
        cell.img1.isUserInteractionEnabled = true
        cell.img1.addGestureRecognizer(tapGestureRecognizer1)
        
        //Add event for image 2
        let tapGestureRecognizer2:UITapGestureRecognizer
        if StickerModel2.alreadyImageSet! {
            tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(deleteStickerImageTapped(tapGestureRecognizer:)))
        }
        else{
            tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(setStickerImageTapped(tapGestureRecognizer:)))
        }
        cell.img2.isUserInteractionEnabled = true
        cell.img2.addGestureRecognizer(tapGestureRecognizer2)
        
        //Add event for image 3
        let tapGestureRecognizer3:UITapGestureRecognizer
        if StickerModel3.alreadyImageSet! {
            tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(deleteStickerImageTapped(tapGestureRecognizer:)))
        }
        else{
            tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(setStickerImageTapped(tapGestureRecognizer:)))
        }
        cell.img3.isUserInteractionEnabled = true
        cell.img3.addGestureRecognizer(tapGestureRecognizer3)
        
        return cell
    }
    
    @objc func setStickerImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! DetailsPackageUIImageView
        let name = tappedImage.name
        let StickerModel = tappedImage.StickerModel
        
        let indexS = "\(tappedImage.index)"
        print("tappedImage  index = " + indexS)
        
        //Open window to select image from gallery and edit it
        EditPackageImageShare.shared.onImageSetted = {uiimage, data in
            
            //Update the model
            StickerModel!.image = data
            StickerModel!.alreadyImageSet = true
            
            //Update visible image
            tappedImage.image = uiimage
            
            //Update in disk the model
            StickersManager.shared.updateCustomPackageStickerImage(name: name!, stickerId: StickerModel!.id!, data: data)
        
            //Add the new listener in touch
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.deleteStickerImageTapped(tapGestureRecognizer:)))
            tappedImage.addGestureRecognizer(tapGestureRecognizer)
        }
        EditPackageImageShare.shared.returnToUIViewController = self
        ViewControllersManager.shared.setRoot(UIViewController: self, id: "EditPackageImageViewController")
    }
    
    @objc func deleteStickerImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! DetailsPackageUIImageView
        let name = tappedImage.name
        let StickerModel = tappedImage.StickerModel
        
        DeleteStickerShare.shared.imageData = tappedImage.getData()
        DeleteStickerShare.shared.onOk = {
            
            //Delete the image from the sticker pack of the system
            let stickerId = StickerModel?.id
            StickersManager.shared.deleteCustomSticker(packageName: name!, id: stickerId!)
            
            //Remove visual image
            tappedImage.image = UIImage(named: "add_icon")
            
            //Add the new listener in touch
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.setStickerImageTapped(tapGestureRecognizer:)))
            tappedImage.addGestureRecognizer(tapGestureRecognizer)
        }
        
        ViewControllersManager.shared.push(UIViewController: self, id: "DeleteStickerViewController")
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
        EditPackageImageShare.shared.onImageSetted = {uiimage, data in
            
            //Change the image to the edited one
            self.imgPackage.image = uiimage
            
            //Update the tray image in the local system
            StickersManager.shared.updateCustomPackageTrayImage(name: self.packageName!, data: data)
        }
        EditPackageImageShare.shared.returnToUIViewController = self
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
