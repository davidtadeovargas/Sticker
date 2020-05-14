//
//  PrincipalViewController.swift
//  Sticker
//
//  Created by usuario on 03/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit

class PrincipalViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var btnStickersPackage: UIButton!
    @IBOutlet weak var btnStickersMaker: UIButton!
    @IBOutlet weak var imgNoStickers: UIImageView!
    @IBOutlet weak var tableStickers: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var StickerPackageHttpModelArray = [StickerPackageHttpModel]()
    private var StickerPackageHttpModelArrayTmp = [StickerPackageHttpModel]()
    
    private var StickerPackageHttpModel_:StickerPackageHttpModel? = nil
    
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableStickers.delegate = self
        tableStickers.dataSource = self
        
        if(PrincipalShare.shared.StickerPackageHttpModelArray == nil){
            
            let StickerPackageRequest_ = RequestsFactor.shared.getStickerPackageRequest()
            StickerPackageRequest_.UIViewController_ = self
            StickerPackageRequest_.onError = { Error in
                AlertManager.shared.showError(UIViewController: self, message: Error.localizedDescription)
            }
            StickerPackageRequest_.onFinish = { DataHttpModel_ in
             
                DispatchQueue.main.async {
                    
                    //No items hide the table
                    if(DataHttpModel_.data?.count == 0){
                        self.tableStickers.isHidden = true
                    }
                    else{ //Yes there are items
                        
                        self.initTable(StickerPackageHttpModelArray_: DataHttpModel_.data!)
                        
                        PrincipalShare.shared.StickerPackageHttpModelArray = self.StickerPackageHttpModelArray
                    }
                }
            }
            StickerPackageRequest_.request()
        }
        else{
            
            let stickersArray = PrincipalShare.shared.StickerPackageHttpModelArray
            self.initTable(StickerPackageHttpModelArray_: stickersArray!)
        }
    }
    
    func initTable(StickerPackageHttpModelArray_:[StickerPackageHttpModel]){
        
        self.StickerPackageHttpModelArray = StickerPackageHttpModelArray_
        
        //List for search bar for the table of stickers
        self.StickerPackageHttpModelArrayTmp = self.StickerPackageHttpModelArray
        
        self.tableStickers.isHidden = false
        self.tableStickers.reloadData()
        
        //Connect the search bar
        self.searchBar.delegate = self
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
        
        self.StickerPackageHttpModelArrayTmp = self.StickerPackageHttpModelArray.filter({ (StickerPackageHttpModel) -> Bool in
            
            let StickerPackageHttpModelTmp: StickerPackageHttpModel = StickerPackageHttpModel
            
            return (StickerPackageHttpModelTmp.categoryName?.starts(with: searchText))!
        })
        if(StickerPackageHttpModelArrayTmp.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableStickers.reloadData()
    }
    
    
    @IBAction func btnPackageStickersClicked(_ sender: Any) {
        
    }
    
    @IBAction func btnStickersMakerClicked(_ sender: Any) {
        ViewControllersManager.shared.setRoot(UIViewController: self, id: "StickersMakerViewController")
    }
    
    @IBAction func btnExplorarClicked(_ sender: Any) {
    }
    
    @IBAction func btnSalvadoClicked(_ sender: Any) {
        ViewControllersManager.shared.setRoot(UIViewController: self, id: "SalvadoViewController")
    }
    
    @IBAction func btnHamburguesaClicked(_ sender: Any) {
        
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

extension PrincipalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = StickerPackageHttpModelArrayTmp.count
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? PrincipalTableViewCell else {
            return UITableViewCell()
        }
        
        //Get the row model
        self.StickerPackageHttpModel_ = self.StickerPackageHttpModelArrayTmp[indexPath.row]
            
        //Set the main text
        cell.mainLabel.text = StickerPackageHttpModel_!.categoryName
        
        //If already not init
        if(cell.mainStack.subviews.count == 0){
           
            //Add action for "mas" button
            let tap = UITapGestureRecognizer(target: self, action: #selector(plusAction))
            cell.masLabel.isUserInteractionEnabled = true
            cell.masLabel.addGestureRecognizer(tap)
            
            //Create the stack rows
            if(StickerPackageHttpModel_!.stickerPack!.count > 0){
                addStackToMain(stickerPack:StickerPackageHttpModel_!.stickerPack!,index:0, mainStack:cell.mainStack)
                addStackToMain(stickerPack:StickerPackageHttpModel_!.stickerPack!,index:1, mainStack:cell.mainStack)
                addStackToMain(stickerPack:StickerPackageHttpModel_!.stickerPack!,index:2, mainStack:cell.mainStack)
            }
        }
        
        return cell
    }
    
    @objc
    func plusAction(sender:UITapGestureRecognizer) {
        print("plusAction tapped")
        
        //Open the screen to see all the stickers of this package
        PackageDetailUIShare.shared.StickerPackageHttpModel_ = StickerPackageHttpModel_
        ViewControllersManager.shared.setRoot(UIViewController: self, id: "PackageDetailUIViewController")
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
