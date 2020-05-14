//
//  BaseRequest.swift
//  Sticker
//
//  Created by usuario on 08/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BaseRequest {
    
    var url:String?
    var onReceive:((JSON)->Void)? = nil
    var onError:((Error)->Void)? = nil
    var UIViewController_:UIViewController? = nil
    
    
    init(url:String) {
        self.url = url
    }
    
    func request() {
        
        print("Entered to request")
        
        //Show loading icon
        if(self.UIViewController_ != nil){
            LoadingIcon.shared.show(onView: (UIViewController_?.view)!)
        }
        
        let headers: HTTPHeaders = [
            Constants.shared.AUTH_TOKEN_KEY: Constants.shared.AUTH_TOKEN,
            "Content-Type": "application/json"
        ]
        
        print("Starting request to url = " + url!)
        
        let request = Alamofire.request(self.url!, headers: headers)
        request.responseJSON { (data) in
            
            do {
                
                print("Request responded data = \(data)")
                
                //Any error
                if let error = data.error {
                    
                    print("Error found in request: " + error.localizedDescription)
                    
                    if self.onError != nil {
                        print("Redirecting to onError")
                        self.onError!(error)
                    }
                    return
                }
                
                //Convert to json and send to the callback
                let json:JSON = try JSON(data: data.data!)
                print("Converted to json = \(json)")
                print("Sending data to onReceive")
                self.onReceive!(json)
                
            } catch {
                
                print("Error exception found in request: \(error)")
                
                if self.onError != nil {
                    print("Redirecting to onError")
                    self.onError!(error)
                }
            }
            
            //Hide loading icon
            if(self.UIViewController_ != nil){
                LoadingIcon.shared.hide()
            }
        }
    }
}
