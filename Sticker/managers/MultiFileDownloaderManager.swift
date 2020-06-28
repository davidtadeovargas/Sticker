//
//  MultiFileDownloaderManager.swift
//  Sticker
//
//  Created by usuario on 02/06/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation
import Alamofire

class MultiFileDownloaderManager {
    
    //Contains the urls to download
    var FileMultiFiles:[FileMultiFile] = [FileMultiFile]()
    
    //On any error
    var onError:((Error)->Void)? = nil
    
    //On completion
    var onCompleted:(()->Void)? = nil
    
    //Destination of all downloaded images
    let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
    
    static let shared = MultiFileDownloaderManager()
    
    
    
    
    private init() {
    }
    
    func addFileToDownload(FileMultiFile_:FileMultiFile){
        self.FileMultiFiles.append(FileMultiFile_)
    }
    
    func download() throws {
        
        //Start downloading files
        try self.downloadFile(index: 0)
    }
    
    func downloadFile(index:Int) throws {
        
        //End of recursion
        if(FileMultiFiles.count == index){
            
            print("MultiFileDownloaderManager: All files properly downloaded")
            
            //Clear the list of files
            self.FileMultiFiles = []
            
            //All files are correctly downloaded so return user control for success
            if(self.onCompleted != nil){
                self.onCompleted!()
            }
            
            return
        }
        else { //Continue recursion
            
            //Get the file model
            let FileMultiFile = FileMultiFiles[index]
            
            print("MultiFileDownloaderManager: Downloading image \(FileMultiFile.url)")
            
            //Delete the file if exists
            if(try FilesManager.shared.fileExistsFromdDocumentDirectory(fileName: FileMultiFile.fileName)){
                print("MultiFileDownloaderManager: Image \(FileMultiFile.url) exists in local")
                try FilesManager.shared.removeFileFromdDocumentDirectory(fileName: FileMultiFile.fileName)
                print("MultiFileDownloaderManager: Image \(FileMultiFile.url) deleted from local")
            }
            
            //Download the file to disk
            AF.download(FileMultiFile.url, to: destination).response { response in
                if(!(response.error != nil)){
                    
                    print("MultiFileDownloaderManager: Image \(FileMultiFile.url) downloaded")
                    
                    do {
                        
                        //Recursive solution
                        try self.downloadFile(index: index + 1)
                        
                    } catch {
                        
                        //Callback for error
                        if(self.onError != nil){
                            self.onError!(response.error!)
                        }
                    }
                }
                else{
                    
                    print("MultiFileDownloaderManager: Error found while downloading image \(response.error!.localizedDescription)")
                    
                    //Callback for error
                    if(self.onError != nil){
                        self.onError!(response.error!)
                    }
                }
            }
        }
    }
}

class FileMultiFile {
    var url:String!
    var fileName:String!
}
