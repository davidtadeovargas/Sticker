//
//  EditPackageImageViewController.swift
//  Sticker
//
//  Created by usuario on 06/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit
import iOSPhotoEditor

class EditPackageImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotoEditorDelegate {

    var imagePicker = UIImagePickerController()
    
    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?;
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
         {
            UIAlertAction in
            self.openCamera()
         }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default)
         {
            UIAlertAction in
            self.openGallary()
         }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
         {
            UIAlertAction in
            ViewControllersManager.shared.setRoot(routeUIViewController: EditPackageImageShare.shared.returnToUIViewController)
            
         }

        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            picker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(picker, animated: true, completion: nil)
        }
        else
        {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
            alertWarning.show()
            
            //Return to the specified view controller
            ViewControllersManager.shared.setRoot(routeUIViewController: EditPackageImageShare.shared.returnToUIViewController)
        }
    }
    func openGallary()
    {
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }

    //PickerView Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        //Open library for editing image
        let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController",bundle: Bundle(for: PhotoEditorViewController.self))

        //PhotoEditorDelegate
        photoEditor.photoEditorDelegate = self

        //The image to be edited
        photoEditor.image = image

        //Stickers that the user will choose from to add on the image
        //photoEditor.stickers.append(UIImage(named: "sticker" )!)

        //Optional: To hide controls - array of enum control
        photoEditor.hiddenControls = [.crop, .draw, .share]

        //Optional: Colors for drawing and Text, If not set default values will be used
        photoEditor.colors = [.red,.blue,.green]

        //Present the View Controller
        present(photoEditor, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        ViewControllersManager.shared.setRoot(routeUIViewController: EditPackageImageShare.shared.returnToUIViewController)
    }
    
    
    
    
    func doneEditing(image: UIImage) {
        
        let data = UIImagePNGRepresentation(image)
        
        if(EditPackageImageShare.shared.onImageSetted != nil){
            EditPackageImageShare.shared.onImageSetted!(image,data!)
        }
        
        //Return to the specified view controller
        ViewControllersManager.shared.setRoot(routeUIViewController: EditPackageImageShare.shared.returnToUIViewController)
    }
        
    func canceledEditing() {
        ViewControllersManager.shared.setRoot(routeUIViewController: EditPackageImageShare.shared.returnToUIViewController)
    }
}
