//
//  BaseUITableView.swift
//  Sticker
//
//  Created by usuario on 14/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit
import RealmSwift

class BaseUITableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    private var searchBar: UISearchBar? = nil
    private var searchButton: UIButton? = nil
    var searchBarSearchButtonClicked:(()->Void)? = nil
    var textDidChange:((String)->Void)? = nil
    var onShowSearchBar:(()->Void)? = nil
    var onHideSearchBar:(()->Void)? = nil
    var data = [AnyObject]()
    var dataTmp = [AnyObject]()
    var modelData:AnyObject? = nil
    var TableType_:TableType? = nil
    var parentViewController:UIViewController? = nil
    
    var tableRowHeigth = 250
    var cellForRowAt:((Int, UITableViewCell, AnyObject)->UITableViewCell)? = nil
    var didSelectRowAt:((Int, UITableViewCell, AnyObject)->Void)? = nil
    
    
    private var searchActive : Bool = false
    
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
    }
    
    //Work with search bar
    func initSearchBar(searchBar: UISearchBar, searchButton:UIButton){
        
        self.searchBar = searchBar
        self.searchButton = searchButton
        
        self.searchBar?.isHidden = true
        
        //Connect the search bar
        self.searchBar!.delegate = self
        
        //Remove borders
        self.searchBar!.backgroundImage = UIImage()
        
        //Add event to the button
        self.searchButton!.addTarget(self, action: #selector(buttonSearchTouch), for: .touchUpInside)
        
        self.keyboardDismissMode = .onDrag
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.dataTmp.count
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(self.tableRowHeigth)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Get cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") else {
            return
        }
        
        let index = indexPath.row
        
        //Get model
        let model = self.dataTmp[index]
        
        if(self.didSelectRowAt != nil){
            self.didSelectRowAt!(index, cell,model)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Get cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") else {
            return UITableViewCell()
        }
        
        let index = indexPath.row
        
        //Get model
        let model = self.dataTmp[index]
        
        var editedCell:UITableViewCell? = nil
        if(self.cellForRowAt != nil){
            editedCell = self.cellForRowAt!(index, cell, model)
        }
        
        return editedCell!
    }
    
    func saveDataInCache(data_:[AnyObject]){
        TablesCache.shared.saveDataInCache(data_: data_, TableType_: self.TableType_!)
    }
    
    func getDataFromCache() -> [AnyObject]? {
        return TablesCache.shared.getDataFromCache(TableType_: self.TableType_!)
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        self.searchActive = true;
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchActive = true;
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchActive = false;
        hideSerchBar()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchActive = false;
        
        hideSerchBar()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        hideSerchBar()
        
        //Callback
        if(self.searchBarSearchButtonClicked != nil){
            self.searchBarSearchButtonClicked!()
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        if(self.textDidChange != nil){
            self.textDidChange!(searchText)
        }
    }
    
    @objc func buttonSearchTouch() {
        self.showSerchBar()
    }
    
    func dataInCache() -> Bool{
        let data_ = self.getDataFromCache()
        return data_ != nil
    }
    
    func loadData(data:[AnyObject]) {
        
        self.data = data //Save data in cache
        self.dataTmp = self.data
        
        self.isHidden = false
        self.reloadData()
        
        //Save data in cache
        self.saveDataInCache(data_: self.data)
    }
    
    func loadDataFromCache() {
        let data_ = self.getDataFromCache()
        self.loadData(data: data_!)
    }
    
    func showSerchBar(){
        
        self.searchBar!.isHidden = false
        self.searchButton!.isHidden = true
        
        //Callback
        if(self.onShowSearchBar != nil){
            self.onShowSearchBar!()
        }
    }
    
    func hideSerchBar(){
        
        self.searchBar!.isHidden = true
        self.searchButton!.isHidden = false
        self.searchBar!.endEditing(true)
        
        //Callback
        if(self.onHideSearchBar != nil){
            self.onHideSearchBar!()
        }
    }
}
extension BaseUITableView: UISearchBarDelegate {
    
    
}
protocol InitTableProtocol {
    func initTable(TableType_:TableType)->Void
    func loadData(data:[AnyObject])
}
