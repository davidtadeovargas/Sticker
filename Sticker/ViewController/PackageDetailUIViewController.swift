//
//  PackageDetailTableViewController.swift
//  Sticker
//
//  Created by usuario on 13/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit

class PackageDetailUIViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableStickers: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    
    var searchActive : Bool = false
    
    var StickerPackageHttpModel_:StickerPackageHttpModel? = nil
    
    var stickerPack:[StickerInnerPackHttpModel]? = nil
    var stickerPackTmp:[StickerInnerPackHttpModel]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Get the sticker package to preview
        self.StickerPackageHttpModel_ = PackageDetailUIShare.shared.StickerPackageHttpModel_
        
        //Set the list of stickers of the sticker package
        self.stickerPack = self.StickerPackageHttpModel_?.stickerPack
        self.stickerPackTmp = self.stickerPack
        
        tableStickers.delegate = self
        tableStickers.dataSource = self
        
        searchBar.delegate = self
        
        //Show publicity if applies
        AddsManager.shared.showAddIfApply(UIViewController: self)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        self.stickerPackTmp = self.stickerPack!.filter({ (stickerPack) -> Bool in
            
            let stickerPackTmp_ = stickerPack
            
            return (stickerPackTmp_.name!.starts(with: searchText))
        })
        if(self.stickerPackTmp!.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableStickers.reloadData()
    }
    
    // Set the spacing between sections
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? PackageDetailTableViewCell else {
            return UITableViewCell()
        }
        /*cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true*/
        
        let StickerInnerPackHttpModel_:StickerInnerPackHttpModel = self.stickerPackTmp![indexPath.row]
        
        //Fill cell data
        let imageUri = StickerInnerPackHttpModel_.trayImageUri
        let url = URL(string: imageUri!)
        DispatchQueue.global().async {
            
            if(url != nil){
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    if(data == nil){
                        print("Found nil in data in \(StickerInnerPackHttpModel_.trayImageUri ?? "Default value")")
                    }
                    else{
                        print("Asigning image to cell.mainImage.image asyncronous in \(StickerInnerPackHttpModel_.trayImageUri ?? "Default value")")
                        let imageIcon = UIImage(data: data!)
                        cell.mainImage.image = imageIcon
                    }
                }
            }
        }
        cell.mainLabel.text = StickerInnerPackHttpModel_.name
        cell.secondaryLabel.text = StickerInnerPackHttpModel_.publisher
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard (tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? PackageDetailTableViewCell) != nil else {
                return
        }
        
        let StickerInnerPackHttpModel_:StickerInnerPackHttpModel = self.stickerPackTmp![indexPath.row]
        
        //Open the next screen to view the package info
        //PackageDetailShare.shared.StickerPackage = StickerPackage_ //Params for the screen
        //ViewControllersManager.shared.setRoot(UIViewController: self, id:"PackageDetailViewController")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stickerPackTmp!.count
    }
    
    @IBAction func backButtonTouch(_ sender: Any) {
        ViewControllersManager.shared.setRoot(UIViewController: self, id: "PrincipalViewController")
    }
}

class PackageDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var imagesStack: UIStackView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var goImage: UIImageView!
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

