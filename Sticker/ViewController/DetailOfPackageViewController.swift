//
//  DetailOfPackageViewController.swift
//  Sticker
//
//  Created by usuario on 13/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit

class DetailOfPackageViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var whatsappButton: UIButton!
    @IBOutlet weak var downloadStickersPackButton: UIButton!
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var img6: UIImageView!
    @IBOutlet weak var img7: UIImageView!
    @IBOutlet weak var img8: UIImageView!
    @IBOutlet weak var img9: UIImageView!
    @IBOutlet weak var img10: UIImageView!
    @IBOutlet weak var img11: UIImageView!
    @IBOutlet weak var img12: UIImageView!
    
    @IBOutlet weak var labelStickersAddedWhatsaApp: UILabel!
    
    var StickerInnerPackHttpModel_:StickerInnerPackHttpModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.StickerInnerPackHttpModel_ = DetailOfPackageShare.shared.StickerInnerPackHttpModel
        
        //Check if the stickers is already saved or not
        let StickerPackage = StickersManager.shared.getRemotePackage(name: self.StickerInnerPackHttpModel_!.name)
        if((StickerPackage) == nil){
            packageStickersNotAlreadyDownloaded()
        }
        else if(!StickerPackage!.alreadyWhatsapp){
            packageStickersAlreadyDownloaded()
        }
        else{
            packageStickersAlreadyDownloadedInWhatsapp()
        }
        
        //Set main image
        let imageUri = self.StickerInnerPackHttpModel_?.trayImageUri
        self.mainImage.loadImageFromUrl(urlString: imageUri!)
        
        //Name and publisher
        self.mainLabel.text = self.StickerInnerPackHttpModel_?.name
        self.secondaryLabel.text = self.StickerInnerPackHttpModel_?.publisher
        
        //Load all the stickers
        let stickers = self.StickerInnerPackHttpModel_?.stickers
        
        guard let StickerHttpModel1 = stickers![safe: 0] else {
          return
        }
        self.img1.loadImageFromUrl(urlString: StickerHttpModel1.uri)
        guard let StickerHttpModel2 = stickers![safe: 1] else {
          return
        }
        self.img2.loadImageFromUrl(urlString: StickerHttpModel2.uri)
        guard let StickerHttpModel3 = stickers![safe: 2] else {
          return
        }
        self.img3.loadImageFromUrl(urlString: StickerHttpModel3.uri)
        guard let StickerHttpModel4 = stickers![safe: 3] else {
          return
        }
        self.img4.loadImageFromUrl(urlString: StickerHttpModel4.uri)
        guard let StickerHttpModel5 = stickers![safe: 4] else {
          return
        }
        self.img5.loadImageFromUrl(urlString: StickerHttpModel5.uri)
        guard let StickerHttpModel6 = stickers![safe: 5] else {
          return
        }
        self.img6.loadImageFromUrl(urlString: StickerHttpModel6.uri)
        guard let StickerHttpModel7 = stickers![safe: 6] else {
          return
        }
        self.img7.loadImageFromUrl(urlString: StickerHttpModel7.uri)
        guard let StickerHttpModel8 = stickers![safe: 7] else {
          return
        }
        self.img8.loadImageFromUrl(urlString: StickerHttpModel8.uri)
        guard let StickerHttpModel9 = stickers![safe: 8] else {
          return
        }
        self.img9.loadImageFromUrl(urlString: StickerHttpModel9.uri)
        guard let StickerHttpModel10 = stickers![safe: 9] else {
          return
        }
        self.img10.loadImageFromUrl(urlString: StickerHttpModel10.uri)
        guard let StickerHttpModel11 = stickers![safe: 10] else {
          return
        }
        self.img11.loadImageFromUrl(urlString: StickerHttpModel11.uri)
        guard let StickerHttpModel12 = stickers![safe: 11] else {
          return
        }
        self.img12.loadImageFromUrl(urlString: StickerHttpModel12.uri)
        
    }
    
    func packageStickersAlreadyDownloaded(){
        self.deleteButton.isHidden = false
        self.downloadStickersPackButton.isHidden = true
        self.whatsappButton.isHidden = false
        self.labelStickersAddedWhatsaApp.isHidden = true
    }
    func packageStickersNotAlreadyDownloaded(){
        self.deleteButton.isHidden = true
        self.downloadStickersPackButton.isHidden = false
        self.whatsappButton.isHidden = true
        self.labelStickersAddedWhatsaApp.isHidden = true
    }
    func packageStickersAlreadyDownloadedInWhatsapp(){
        self.deleteButton.isHidden = false
        self.downloadStickersPackButton.isHidden = true
        self.whatsappButton.isHidden = true
        self.labelStickersAddedWhatsaApp.isHidden = false
    }
    
    func getStack() -> UIStackView{
        
        let UIStackView_ = UIStackView()
        UIStackView_.axis = .horizontal
        UIStackView_.distribution = .fillEqually
        UIStackView_.alignment = .center
        UIStackView_.spacing = 50
        
        return UIStackView_
    }
    
    func getUIImageView(url:String) -> UIImageView{
        
        let UIImageView_ = UIImageView()
        
        let url = URL(string: url)
        DispatchQueue.global().async {
            if(url != nil){
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    if(data == nil){
                        
                    }
                    else{
                        
                        let imageIcon = UIImage(data: data!)
                        UIImageView_.image = imageIcon
                    }
                }
            }
        }
        
        return UIImageView_
    }
    
    @IBAction func downloadStickersTouch(_ sender: Any) {
    }
    
    @IBAction func whatsappButtonTouch(_ sender: Any) {
        
        //Validate that the amound of stickers is valid
        if((self.StickerInnerPackHttpModel_?.stickers.count)! < 3){
            AlertManager.shared.showError(UIViewController: self, message: "La cantida de stickers debe ser de 3 o mayor para poder continuar")
            return
        }
        
        //Question if continue
        AlertManager.shared.showQuestion(UIViewController: self, question: "¿Seguro que quieres agregar el paquete de stickers a whatsapp?", onYes: {
            
            do{
                
                //Save the package stickers to whatsapp
                WhatsappStickerManager.shared.onCompleted = {
                    
                    //Now the sticker package is on whatsapp
                    self.StickerInnerPackHttpModel_?.alreadyWhatsapp = true
                    
                    //Update the package sticker that now is added to whatsapp
                    StickersManager.shared.updateRemotePackage(StickerInnerPackHttpModel_: self.StickerInnerPackHttpModel_!)
                    
                    //Show the view for whatsapp downloaded
                    self.packageStickersAlreadyDownloadedInWhatsapp()
                    
                    AlertManager.shared.showOk(UIViewController: self, message: "Paquete de stickers agregado a whatsapp correctamente")
                }
                WhatsappStickerManager.shared.OnError(onError: {_ in
                    AlertManager.shared.showError(UIViewController: self, message: self.description)
                })
                try WhatsappStickerManager.shared.downloadToWhatsappHttp(StickerInnerPackHttpModel_: self.StickerInnerPackHttpModel_!)
                
            }catch StickerPackError.fileNotFound{
                AlertManager.shared.showError(UIViewController: self, message: "Stickers SDK Archivo no encontrado")
            }
            catch(StickerPackError.emptyString){
                AlertManager.shared.showError(UIViewController: self, message: "Stickers SDK Cadena vacia")
            }
            catch(StickerPackError.unsupportedImageFormat(let String)){
                AlertManager.shared.showError(UIViewController: self, message: "Stickers SDK Formato de imagen no soportado " + String)
            }
            catch(StickerPackError.imageTooBig(let Int64)){
                AlertManager.shared.showError(UIViewController: self, message: "Stickers SDK Tamano de imagen muy grande " + String(Int64) + ", el maximo es  \(Limits.MaxStickerFileSize)")
            }
            catch(StickerPackError.incorrectImageSize(let CGSize)){
                AlertManager.shared.showError(UIViewController: self, message: "Stickers SDK Tamaño de imagen incorrecta " + NSStringFromCGSize(CGSize))
            }
            catch(StickerPackError.animatedImagesNotSupported){
                AlertManager.shared.showError(UIViewController: self, message: "Stickers SDK Imagenes animadas no son soportadas")
            }
            catch(StickerPackError.stickersNumOutsideAllowableRange){
                AlertManager.shared.showError(UIViewController: self, message: "Stickers SDK stickersNumOutsideAllowableRange")
            }
            catch(StickerPackError.stringTooLong){
                AlertManager.shared.showError(UIViewController: self, message: "Stickers SDK Cadena muy larga")
            }
            catch(StickerPackError.tooManyEmojis){
                AlertManager.shared.showError(UIViewController: self, message: "Stickers SDK Demasiados emojis")
            }
            catch{
                
                AlertManager.shared.showError(UIViewController: self, message: error.localizedDescription)
            }
            
        }, onNo: {
            
        })
    }
    
    @IBAction func deleteButtonTouch(_ sender: Any) {
        
        AlertManager.shared.showQuestion(UIViewController: self, question: "¿Seguro que quieres borrar el paquete de stickers?", onYes: {
            
            //Delete the sticker in the system self.StickerInnerPackHttpModel_
            StickersManager.shared.deleteRemotePackage(name: self.StickerInnerPackHttpModel_!.name)
            
            AlertManager.shared.showOk(UIViewController: self, message: "Paquete de stickers borrado")
            
            DispatchQueue.main.async() {
                self.packageStickersNotAlreadyDownloaded()
            }
            
        }, onNo: {
            
        })
    }
    
    @IBAction func backButtonTouch(_ sender: Any) {
        let returnTo = DetailOfPackageShare.shared.comesFrom
        ViewControllersManager.shared.setRoot(UIViewController: self, id: returnTo!)
    }
    
    @IBAction func downloadStickersPackageButtonTouch(_ sender: Any) {
        
        AlertManager.shared.showQuestion(UIViewController: self, question: "¿Seguro que quieres descargar el paquete de stickers?", onYes: {
            
            self.StickerInnerPackHttpModel_!.alreadyWhatsapp = false
            
            //Save the sticker in the system
            StickersManager.shared.addRemotePackage(StickerInnerPackHttpModel_: self.StickerInnerPackHttpModel_!)
            
            AlertManager.shared.showOk(UIViewController: self, message: "Paquete de stickers descargado")
            
            DispatchQueue.main.async() {
                self.packageStickersAlreadyDownloaded()
            }
            
        }, onNo: {
            
        })
    }
}
