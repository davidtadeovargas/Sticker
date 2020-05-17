//
//  PackageDetailBaseUITableView.swift
//  Sticker
//
//  Created by usuario on 14/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit
import RealmSwift

class PackageDetailBaseUITableView: BaseUITableView, InitTableProtocol {

    required init?(coder: NSCoder) {
       super.init(coder: coder)
    }
    
    func initTable(TableType_:TableType){
        
        self.TableType_ = TableType_
        
        self.tableRowHeigth = 250
        
        //Render the table row
        self.cellForRowAt = {index, cell, model in
            
            //Cast the cell
            let cell_ = cell as? PackageDetailTableViewCell
            
            //Cast the row model
            let StickerInnerPackHttpModel_ = model as! StickerInnerPackHttpModel
                    
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
                            cell_!.mainImage.image = imageIcon
                        }
                    }
                }
            }
            
            if(!cell_!.cellInit){
                
                cell_?.cellInit = true
                
                if(StickerInnerPackHttpModel_.stickers.indices.contains(0)){
                    let StickerHttpModel = StickerInnerPackHttpModel_.stickers[0]
                    let UIImageView = self.getUIImageView(url: StickerHttpModel.uri)
                    cell_?.imagesStack.addArrangedSubview(UIImageView)
                }
                if(StickerInnerPackHttpModel_.stickers.indices.contains(1)){
                    let StickerHttpModel = StickerInnerPackHttpModel_.stickers[1]
                    let UIImageView = self.getUIImageView(url: StickerHttpModel.uri)
                    cell_?.imagesStack.addArrangedSubview(UIImageView)
                }
                if(StickerInnerPackHttpModel_.stickers.indices.contains(2)){
                    let StickerHttpModel = StickerInnerPackHttpModel_.stickers[2]
                    let UIImageView = self.getUIImageView(url: StickerHttpModel.uri)
                    cell_?.imagesStack.addArrangedSubview(UIImageView)
                }
                if(StickerInnerPackHttpModel_.stickers.indices.contains(3)){
                    let StickerHttpModel = StickerInnerPackHttpModel_.stickers[3]
                    let UIImageView = self.getUIImageView(url: StickerHttpModel.uri)
                    cell_?.imagesStack.addArrangedSubview(UIImageView)
                }
                if(StickerInnerPackHttpModel_.stickers.indices.contains(4)){
                    let StickerHttpModel = StickerInnerPackHttpModel_.stickers[4]
                    let UIImageView = self.getUIImageView(url: StickerHttpModel.uri)
                    cell_?.imagesStack.addArrangedSubview(UIImageView)
                }
            }
            
            cell_!.mainLabel.text = StickerInnerPackHttpModel_.name
            cell_!.secondaryLabel.text = StickerInnerPackHttpModel_.publisher
            
            return cell_!
        }
        
        //When row is selected
        self.didSelectRowAt = {index, cell, model in
            
            let StickerInnerPackHttpModel_ = model as! StickerInnerPackHttpModel
            
            //Open the next screen to view the package info
            //PackageDetailShare.shared.StickerPackage = StickerPackage_ //Params for the screen
            //ViewControllersManager.shared.setRoot(UIViewController: self, id:"PackageDetailViewController")
        }
        
        self.delegate = self
        self.dataSource = self
        
        //When text changes in the search bar
        self.textDidChange = { searchText in
            
            let stickerPack = self.data as! [StickerInnerPackHttpModel]
            self.dataTmp = stickerPack.filter({ (stickerPack) -> Bool in
                
                let stickerPackTmp_ = stickerPack
                
                return (stickerPackTmp_.name!.starts(with: searchText))
            })
            self.reloadData()
        }
        
        //When the search bar button is clicked
        self.searchBarSearchButtonClicked = {
            
        }
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
}

class PackageDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var imagesStack: UIStackView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var goImage: UIImageView!
    
    var cellInit = false
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
