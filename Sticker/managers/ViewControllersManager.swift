//
//  ViewControllersManager.swift
//  Sticker
//
//  Created by usuario on 03/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation

class ViewControllersManager {
    
    static let shared = ViewControllersManager()
    
    private init() {
    }
    
    func push(UIViewController:UIViewController, id:String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: id)
        UIViewController.navigationController?.pushViewController(controller, animated: true)
        UIViewController.present(controller, animated: true, completion: nil)
    }
    
    func pushAndPop(UIViewController:UIViewController, id:String){
        UIViewController.dismiss(animated: true, completion: nil)
        UIViewController.navigationController?.popViewController(animated: true)
        self.push(UIViewController: UIViewController, id: id)
    }
    
    func close(UIViewController:UIViewController){
        
        UIViewController.navigationController?.popViewController(animated: true)
        UIViewController.dismiss(animated: true, completion: nil)
    }
    
    func setRoot(UIViewController:UIViewController,id:String){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: id)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.window?.rootViewController = viewController
        }
    }
    
    func setRoot(routeUIViewController:UIViewController){
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.window?.rootViewController = routeUIViewController
        }
    }
}
