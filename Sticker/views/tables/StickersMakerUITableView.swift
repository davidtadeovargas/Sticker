//
//  StickersMakerUITableView.swift
//  Sticker
//
//  Created by usuario on 17/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit

class StickersMakerUITableView: BaseUITableView, InitTableProtocol {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initTable(TableType_:TableType){
        
        self.TableType_ = TableType_
        
        self.tableRowHeigth = 100
        
        //Render the table row
        self.cellForRowAt = {index, cell, model in
            
            //Cast the cell
            let cell_ = cell as? StickersMakerTableViewCell
            
            //Cast the row model
            let StickerPackage = model as! StickerPackage
            
            cell_!.image_.image = UIImage(named: "add_icon.png")
            cell_!.labelPackageName.text = StickerPackage.name
            cell_!.labelCreator.text = StickerPackage.creator
            
            return cell_!
        }
        
        self.delegate = self
        self.dataSource = self
        
        //When text changes in the search bar
        self.textDidChange = { searchText in
            
            let StickerPackageArray = self.data as! [StickerPackage]
            
            self.dataTmp = StickerPackageArray.filter({ (StickerPackage) -> Bool in
                
                let StickerPackageTmp: StickerPackage = StickerPackage
                return (StickerPackageTmp.name?.starts(with: searchText))!
            })
            self.reloadData()
        }
        
        //When the search bar button is clicked
        self.searchBarSearchButtonClicked = {
            
            
        }
    }
}

class StickersMakerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var image_: UIImageView!
    @IBOutlet weak var stackStickers: UIStackView!
    @IBOutlet weak var labelPackageName: UILabel!
    @IBOutlet weak var labelCreator: UILabel!
    @IBOutlet weak var btnView: UIButton!
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
