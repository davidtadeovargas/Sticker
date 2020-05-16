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
            
            //If already not init
            if(cell_!.mainStack.subviews.count == 0){
               
                //Add action for "mas" button
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.plusAction))
                cell_!.masLabel.isUserInteractionEnabled = true
                cell_!.masLabel.addGestureRecognizer(tap)
                
                //Create the stack rows
                if(StickerPackageHttpModel_.stickerPack!.count > 0){
                    self.addStackToMain(stickerPack:StickerPackageHttpModel_.stickerPack!,index:0, mainStack:cell_!.mainStack)
                    self.addStackToMain(stickerPack:StickerPackageHttpModel_.stickerPack!,index:1, mainStack:cell_!.mainStack)
                    self.addStackToMain(stickerPack:StickerPackageHttpModel_.stickerPack!,index:2, mainStack:cell_!.mainStack)
                }
            }
            
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
    
    @objc
    func plusAction(sender:UITapGestureRecognizer) {
        print("plusAction tapped")
        
        let touch = sender.location(in: self)
        if let indexPath = self.indexPathForRow(at: touch) {
            
            let index = indexPath.row
            
            let model = self.dataTmp[index] as! StickerPackageHttpModel
            
            //Open the screen to see all the stickers of this package
            PackageDetailUIShare.shared.StickerPackageHttpModel_ = model
            ViewControllersManager.shared.setRoot(UIViewController: self.parentViewController!, id: "PackageDetailUIViewController")
        }
    }
    
    func addStackToMain(stickerPack:[StickerInnerPackHttpModel],index:Int, mainStack:UIStackView){
        if(stickerPack.indices.contains(index)){
            let StickerInnerPackHttpModel_ = stickerPack[index]
            let UIStackView_ = self.getStackCell(StickerInnerPackHttpModel_: StickerInnerPackHttpModel_)
            if(UIStackView_ != nil){
                mainStack.insertArrangedSubview(UIStackView_!,at: index)
            }
        }
    }
    
    func getStackCell(StickerInnerPackHttpModel_:StickerInnerPackHttpModel) -> UIStackView? {
        
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
                
                let StickerHttpModel_ = StickerInnerPackHttpModel_.stickers![0]
                let UIImageView_:UIImageView = getUIImageView(StickerHttpModel_: StickerHttpModel_)
                firstUIStackView.addArrangedSubview(UIImageView_)
            }
            if((StickerInnerPackHttpModel_.stickers?.indices.contains(1)) != nil){
                
                let StickerHttpModel_ = StickerInnerPackHttpModel_.stickers![1]
                let UIImageView_:UIImageView = getUIImageView(StickerHttpModel_: StickerHttpModel_)
                firstUIStackView.addArrangedSubview(UIImageView_)
            }
            if((StickerInnerPackHttpModel_.stickers?.indices.contains(2)) != nil){
                
                let StickerHttpModel_ = StickerInnerPackHttpModel_.stickers![2]
                let UIImageView_:UIImageView = getUIImageView(StickerHttpModel_: StickerHttpModel_)
                middleUIStackView.addArrangedSubview(UIImageView_)
            }
            if((StickerInnerPackHttpModel_.stickers?.indices.contains(3)) != nil){
                
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
        let url = URL(string: uri!)
        let UIImageView_ =  UIImageView()
        UIImageView_.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        UIImageView_.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        UIImageView_.contentMode = .scaleAspectFit // OR .scaleAspectFill
        UIImageView_.clipsToBounds = true
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                if(data == nil){
                    print("Found nil in data in \(StickerHttpModel_.imageFileName ?? "Default value")")
                }
                else{
                    let imageIcon = UIImage(data: data!)
                    UIImageView_.image = imageIcon
                    print("Asigning image to UIImageView_ asyncronous in \(StickerHttpModel_.imageFileName ?? "Default value")")
                }
            }
        }
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
