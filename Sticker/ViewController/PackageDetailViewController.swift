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

        // Do any additional setup after loading the view.
        
        details.append(PackageDetailTableRow())
        details.append(PackageDetailTableRow())
        details.append(PackageDetailTableRow())
        details.append(PackageDetailTableRow())
        details.append(PackageDetailTableRow())
        details.append(PackageDetailTableRow())
        details.append(PackageDetailTableRow())
        details.append(PackageDetailTableRow())
        details.append(PackageDetailTableRow())
        details.append(PackageDetailTableRow())
        
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
        
        let stringValue = "\(indexPath.row)"
        print("index = " + stringValue)
        
        let PackageDetailTableRow = details[indexPath.row]
        
        cell.img1.image = PackageDetailTableRow.image1.image
        cell.img2.image = PackageDetailTableRow.image2.image
        cell.img3.image = PackageDetailTableRow.image3.image
        
        if(cell.img1.index == nil){
            
            cell.img1.index = indexPath.row
            cell.img1.position = 1
            cell.img2.index = indexPath.row
            cell.img2.position = 2
            cell.img3.index = indexPath.row
            cell.img3.position = 3
            
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
            
            cell.img1.index = indexPath.row
            cell.img2.index = indexPath.row
            cell.img3.index = indexPath.row
        }
        
        return cell
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! DetailsPackageUIImageView
        
        let indexS = "\(tappedImage.index)"
        let positionS = "\(tappedImage.position)"
        print("tappedImage  index = " + indexS + " position = " + positionS)
        
        let PackageDetailTableRow = details[tappedImage.index!]
        if(tappedImage.position == 1){
            EditPackageImageShare.shared.UIImageView2 = PackageDetailTableRow.image1
        }
        else if(tappedImage.position == 2){
            EditPackageImageShare.shared.UIImageView2 = PackageDetailTableRow.image2
        }
        else if(tappedImage.position == 3){
            EditPackageImageShare.shared.UIImageView2 = PackageDetailTableRow.image3
        }
        
        //Open window to select image from gallery and edit it
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
        ViewControllersManager.shared.setRoot(UIViewController: self, id: "EditPackageImageViewController")
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
