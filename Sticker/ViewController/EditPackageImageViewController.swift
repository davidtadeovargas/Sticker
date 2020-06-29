//
//  EditPackageImageViewController.swift
//  Sticker
//
//  Created by usuario on 06/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit
import PhotoEditorSDK

class EditPackageImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotoEditViewControllerDelegate {
    
    func photoEditViewController(_ photoEditViewController: PhotoEditViewController, didSave image: UIImage, and data: Data) {
        
        let data = UIImagePNGRepresentation(image)
        
        if(EditPackageImageShare.shared.onImageSetted != nil){
            EditPackageImageShare.shared.onImageSetted!(image,data!)
        }
        
        //Return to the specified view controller
        ViewControllersManager.shared.setRoot(routeUIViewController: EditPackageImageShare.shared.returnToUIViewController)
    }
    
    func photoEditViewControllerDidFailToGeneratePhoto(_ photoEditViewController: PhotoEditViewController) {
        
        //Show error
        AlertManager.shared.showError(UIViewController: self, message: "Fallo la generación de la imagen")
        
        //Return to the previous screen
        ViewControllersManager.shared.setRoot(routeUIViewController: EditPackageImageShare.shared.returnToUIViewController)
    }
    
    func photoEditViewControllerDidCancel(_ photoEditViewController: PhotoEditViewController) {
        ViewControllersManager.shared.setRoot(routeUIViewController: EditPackageImageShare.shared.returnToUIViewController)
    }
    

    var imagePicker = UIImagePickerController()
    
    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?;
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let configuration = buildConfiguration()
        
        let cameraViewController = CameraViewController()
        
        cameraViewController.completionBlock = { [unowned cameraViewController] image, _ in
          guard let image = image else {
            return
          }
        
          let photo = Photo(image: image)
          let photoEditViewController = PhotoEditViewController(photoAsset: photo, configuration: configuration)
          photoEditViewController.delegate = self
        
          cameraViewController.present(photoEditViewController, animated: true, completion: nil)
        }
        
        present(cameraViewController, animated: true, completion: nil)
    }
    
    private func buildConfiguration() -> Configuration {
        let configuration = Configuration { builder in
          // Configure camera
          builder.configureCameraViewController { options in
            // Just enable photos
            options.allowedRecordingModes = [.photo]
            // Show cancel button
            options.showCancelButton = true
          }
    
          // Configure editor
          builder.configurePhotoEditViewController { options in
            var menuItems = PhotoEditMenuItem.defaultItems
            menuItems.removeLast() // Remove last menu item ('Magic')
            options.menuItems = menuItems
          }
    
          // Configure sticker tool
          builder.configureStickerToolController { options in
            // Enable personal stickers
            options.personalStickersEnabled = true
          }
    
          // Configure theme
          //builder.theme = self.theme
        }
    
        return configuration
      }
}
