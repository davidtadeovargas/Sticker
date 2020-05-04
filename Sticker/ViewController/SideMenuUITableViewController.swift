//
//  SideMenuUITableViewController.swift
//  Sticker
//
//  Created by usuario on 03/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit

class SideMenuUITableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerCell()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnx = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func registerCell() {
        let cell = UINib(nibName: "SideMenuLogoTableViewCell",
                            bundle: nil)
        self.tableView.register(cell,
                                forCellReuseIdentifier: "CustomCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let logo = UIImage(named: "stickers_suavecitos_gris.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? SideMenuLogoTableViewCell else {
            return UITableViewCell()
        }
        
        switch(indexPath.item){
            
            case 0:
                cell.label.text = "Compartir App"
                cell.image_.image = UIImage(named:"share.png")
                break
            case 1:
                cell.label.text = "Calificar aplicacion"
                cell.image_.image = UIImage(named:"califica.png")
                break
            case 2:
                cell.label.text = "Aviso de privacidad"
                cell.image_.image = UIImage(named:"candado.png")
                break
            case 3:
                cell.label.text = "Encuentra mas aplicaciones"
                cell.image_.image = UIImage(named:"cuadros.png")
                break
                
            default:
                break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
        switch(indexPath.item){
            
            case 0:
                Share.shared.share(UIViewController: self, message: "Invite you to install this app:", link: "https://play.google.com/store/apps/details?id=gatitosyperritoschidos.whatsappsticker")
                break
            case 1:
                UIApplication.shared.open(URL(string: "http://www.google.com")!, options: [:], completionHandler: nil)
                break
            case 2:
                UIApplication.shared.open(URL(string: "http://www.google.com")!, options: [:], completionHandler: nil)
                break
            case 3:
                UIApplication.shared.open(URL(string: "http://www.google.com")!, options: [:], completionHandler: nil)
                break
                
            default:
                break
        }
        
        dismiss(animated: true, completion: nil)
    }
}
