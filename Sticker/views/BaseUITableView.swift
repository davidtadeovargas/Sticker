//
//  BaseUITableView.swift
//  Sticker
//
//  Created by usuario on 14/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit
import RealmSwift

class BaseUITableView: UITableView {

    private var searchBar: UISearchBar? = nil
    private var searchButton: UIButton? = nil
    var searchBarSearchButtonClicked:(()->Void)? = nil
    var textDidChange:((String)->Void)? = nil
    var onShowSearchBar:(()->Void)? = nil
    var onHideSearchBar:(()->Void)? = nil
    
    var parentViewController:UIViewController? = nil
    
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
    func initTable()->Void
    func loadData(data:[AnyObject])
}
