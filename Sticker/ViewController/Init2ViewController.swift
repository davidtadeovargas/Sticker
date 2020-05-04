//
//  Init2ViewController.swift
//  Sticker
//
//  Created by usuario on 03/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit

class Init2ViewController: UIViewController {

    @IBOutlet weak var btnGrantPermissions: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnGrantPermissions(_ sender: Any) {
        
        PHPhotoLibraryManager.shared.askPermission(onGranted: {
            
            DispatchQueue.main.async {
                ViewControllersManager.shared.setRoot(UIViewController: self, id: "Init3ViewController")
            }
        
        }, onNotGranted:  {
            
        }, onDenied: {
    
            AlertManager.shared.showOk(UIViewController: self,message: "Denegaste este permiso, en ajustes de la app puedes otorgarlo de nuevo")
        })
    }
}
