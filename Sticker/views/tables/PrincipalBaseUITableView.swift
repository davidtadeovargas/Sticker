//
//  PrincipalBaseUITableView.swift
//  Sticker
//
//  Created by usuario on 14/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit
import RealmSwift

class PrincipalBaseUITableView: BaseUITableView, InitTableProtocol {

    var stickerPackageTouch:((StickerInnerPackHttpModel)->Void)? = nil
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initTable(TableType_:TableType){
        
        self.TableType_ = TableType_
        
        self.tableRowHeigth = 250
        
        //Render the table row
        self.cellForRowAt = {index, cell, model in
            
            //Cast the cell
            let cell_ = cell as? PrincipalTableViewCell
            
            //Cast the row model
            let StickerPackageHttpModel_ = model as! StickerPackageHttpModel
            
            //Set the main text
            cell_!.mainLabel.text = StickerPackageHttpModel_.categoryName
            
            print("Showing category " + StickerPackageHttpModel_.categoryName)
            
            //If already not init
            //if(cell_!.mainStack.subviews.count == 0){
               
            //Add action for "mas" button
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.plusAction))
            cell_!.masLabel.isUserInteractionEnabled = true
            cell_!.masLabel.addGestureRecognizer(tap)
            
            print("Category contains in total \(StickerPackageHttpModel_.stickerPack!.count)")
            
            print("cell_!.mainStack count \(cell_!.mainStack.arrangedSubviews.count)")
            
            cell_!.mainStack.removeAllArrangedSubviews()
            
            //If there are stickers pack
            if(StickerPackageHttpModel_.stickerPack!.count > 0){
                let stickersTmp = StickerPackageHttpModel_.stickerPack
                for StickerInnerPackHttpModel in stickersTmp! {
                    
                    //Create the stack with sticker images
                    let UIStackView_ = self.getStackCell(StickerInnerPackHttpModel_: StickerInnerPackHttpModel)
                    
                    //Add gesture recognizer
                    let StickerPackageUITapGestureRecognizer_ = StickerPackageUITapGestureRecognizer(target:self, action: #selector(self.stackStickerTouch))
                    StickerPackageUITapGestureRecognizer_.StickerInnerPackHttpModel = StickerInnerPackHttpModel
                    UIStackView_!.isUserInteractionEnabled = true
                    UIStackView_!.addGestureRecognizer(StickerPackageUITapGestureRecognizer_)
                    
                    //Add it to the row stack
                    if(UIStackView_ != nil){
                        cell_!.mainStack.addArrangedSubview(UIStackView_!)
                    }
                }
            }
           //}
            
            return cell_!
        }
        
        self.delegate = self
        self.dataSource = self
        
        //When text changes in the search bar
        self.textDidChange = { searchText in
            
            let StickerPackageHttpModelArray = self.data as! [StickerPackageHttpModel]
            
            self.dataTmp = StickerPackageHttpModelArray.filter({ (StickerPackageHttpModel) -> Bool in
                
                let StickerPackageHttpModelTmp: StickerPackageHttpModel = StickerPackageHttpModel
                return (StickerPackageHttpModelTmp.categoryName?.starts(with: searchText))!
            })
            self.reloadData()
        }
        
        //When the search bar button is clicked
        self.searchBarSearchButtonClicked = {
            
            
        }
    }
    
    class StickerPackageUITapGestureRecognizer: UITapGestureRecognizer {
        var StickerInnerPackHttpModel:StickerInnerPackHttpModel? = nil
    }
    
    @objc
    func stackStickerTouch(sender: StickerPackageUITapGestureRecognizer){
        
        //Get the model
        let StickerInnerPackHttpModel = sender.StickerInnerPackHttpModel
        
        if(self.stickerPackageTouch != nil){
            self.stickerPackageTouch!(StickerInnerPackHttpModel!)
        }
    }
    
    @objc
    func plusAction(sender:UITapGestureRecognizer) {
        print("plusAction tapped")
        
        let touch = sender.location(in: self)
        if let indexPath = self.indexPathForRow(at: touch) {
            
            let index = indexPath.row
            
            let model = self.dataTmp[index] as! StickerPackageHttpModel
            
            //Open the screen to see all the stickers of this package
            PackageDetailUIShare.shared.StickerPackageHttpModel_ = model
            PackageDetailUIShare.shared.comesFrom = "PrincipalViewController"
            ViewControllersManager.shared.setRoot(UIViewController: self.parentViewController!, id: "PackageDetailUIViewController")
        }
    }
    
    func getStackCell(StickerInnerPackHttpModel_:StickerInnerPackHttpModel) -> UIStackView? {
        
        print("getStackCell() \(StickerInnerPackHttpModel_.stickers!.count)")
        
        //If any stickers
        if(StickerInnerPackHttpModel_.stickers!.count > 0){
            
            //Create stack views
            let mainUIStackView = UIStackView()
            mainUIStackView.axis = .vertical
            //mainUIStackView.addBackground(color: UIColor.lightGray)
            mainUIStackView.distribution = .equalSpacing
            mainUIStackView.alignment = UIStackView.Alignment.center
            mainUIStackView.spacing = 0
            mainUIStackView.translatesAutoresizingMaskIntoConstraints = false
            let firstUIStackView = UIStackView()
            firstUIStackView.axis = .horizontal
            firstUIStackView.distribution = .equalSpacing
            firstUIStackView.alignment = UIStackView.Alignment.center
            firstUIStackView.spacing = 0
            firstUIStackView.translatesAutoresizingMaskIntoConstraints = false
            let middleUIStackView = UIStackView()
            middleUIStackView.axis = .horizontal
            middleUIStackView.distribution = .equalSpacing
            middleUIStackView.alignment = UIStackView.Alignment.center
            middleUIStackView.spacing   = 0
            middleUIStackView.translatesAutoresizingMaskIntoConstraints = false
            let bottomUIStackView = UIStackView()
            bottomUIStackView.axis = .vertical
            bottomUIStackView.distribution = .equalSpacing
            bottomUIStackView.alignment = UIStackView.Alignment.center
            bottomUIStackView.spacing   = 0
            bottomUIStackView.translatesAutoresizingMaskIntoConstraints = false
            
            //Add all the stackviews to the main stack
            mainUIStackView.addArrangedSubview(firstUIStackView)
            mainUIStackView.addArrangedSubview(middleUIStackView)
            mainUIStackView.addArrangedSubview(bottomUIStackView)
        
            //Add the images to the stacks
            if((StickerInnerPackHttpModel_.stickers?.indices.contains(0)) != nil){
                
                print("Adding to first stack index 0")
                
                let StickerHttpModel_ = StickerInnerPackHttpModel_.stickers![0]
                let UIImageView_:UIImageView = getUIImageView(StickerHttpModel_: StickerHttpModel_)
                firstUIStackView.addArrangedSubview(UIImageView_)
            }
            if((StickerInnerPackHttpModel_.stickers?.indices.contains(1)) != nil){
                
                print("Adding to first stack index 1")
                
                let StickerHttpModel_ = StickerInnerPackHttpModel_.stickers![1]
                let UIImageView_:UIImageView = getUIImageView(StickerHttpModel_: StickerHttpModel_)
                firstUIStackView.addArrangedSubview(UIImageView_)
            }
            if((StickerInnerPackHttpModel_.stickers?.indices.contains(2)) != nil){
                
                print("Adding to middle stack index 2")
                
                let StickerHttpModel_ = StickerInnerPackHttpModel_.stickers![2]
                let UIImageView_:UIImageView = getUIImageView(StickerHttpModel_: StickerHttpModel_)
                middleUIStackView.addArrangedSubview(UIImageView_)
            }
            if((StickerInnerPackHttpModel_.stickers?.indices.contains(3)) != nil){
                 
                print("Adding to middle stack index 3")
                
                let StickerHttpModel_ = StickerInnerPackHttpModel_.stickers![3]
                let UIImageView_:UIImageView = getUIImageView(StickerHttpModel_: StickerHttpModel_)
                middleUIStackView.addArrangedSubview(UIImageView_)
            }
            
            //Create labels and add them to stack
            let mainLabel = UILabel()
            mainLabel.font = UIFont(name: mainLabel.font.fontName, size: 12)
            mainLabel.text = StickerInnerPackHttpModel_.name
            mainLabel.textColor = UIColor.black
            mainLabel.numberOfLines = 2
            let secondaryLabel = UILabel()
            secondaryLabel.font = UIFont(name: secondaryLabel.font.fontName, size: 10)
            secondaryLabel.textColor = UIColor.gray
            secondaryLabel.text = StickerInnerPackHttpModel_.publisher
            bottomUIStackView.addArrangedSubview(mainLabel)
            bottomUIStackView.addArrangedSubview(secondaryLabel)
            
            print("Returning mainUIStackView")
            
            //Return resulting stack
            return mainUIStackView
        }
        else{
            return nil
        }
    }
    
    func getUIImageView(StickerHttpModel_:StickerHttpModel) -> UIImageView{
        
        let uri = StickerHttpModel_.uri?.replacingOccurrences(of: "\"", with: "")
        print("Reading image from \(uri ?? "Default value")")
        let UIImageView_ =  UIImageView()
        UIImageView_.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        UIImageView_.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        UIImageView_.contentMode = .scaleAspectFit // OR .scaleAspectFill
        UIImageView_.clipsToBounds = true
        UIImageView_.loadImageFromUrl(urlString: uri!)
        return UIImageView_
    }
}
class PrincipalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var masLabel: UILabel!
    @IBOutlet weak var mainStack: UIStackView!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
