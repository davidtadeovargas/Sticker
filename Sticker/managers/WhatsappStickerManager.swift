//
//  WhatsappStickerManager.swift
//  Sticker
//
//  Created by usuario on 02/06/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import Foundation
import Alamofire

class WhatsappStickerManager {
    
    static let shared = WhatsappStickerManager()
    
    var onCompleted:(()->Void)? = nil
    
    
    private init() {
    }
    
    func OnError(onError: @escaping (Error) -> Void){
        
        //Connect error handler to the file multi manager
        MultiFileDownloaderManager.shared.onError = onError
    }

    func downloadToWhatsappHttp(StickerInnerPackHttpModel_:StickerInnerPackHttpModel) throws {
        try self.downloadToWhatsappUtil(StickerInnerPackHttpModel_: StickerInnerPackHttpModel_, trayImageFileName: StickerInnerPackHttpModel_.trayImageUri)
    }
    
    func downloadToWhatsappUtil(StickerInnerPackHttpModel_:StickerInnerPackHttpModel, trayImageFileName:String) throws {
        
        let trayImageFileNameNew:String
        if(trayImageFileName.hasPrefix("http")){
            trayImageFileNameNew = trayImageFileName.replacingOccurrences(of: " ", with: "%20")
        }
        else{
            trayImageFileNameNew = trayImageFileName
        }
        
        
        let bundleID = Bundle.main.bundleIdentifier
        let name = (StickerInnerPackHttpModel_.name)!
        let publisher = (StickerInnerPackHttpModel_.publisher)!
        let publisherWebsite = "www.gatitosyperritoschidos.com"
        
        print("WhatsappStickerManager: Trying to add the sticker: ")
        print("WhatsappStickerManager: identifier: \(bundleID!)")
        print("WhatsappStickerManager: name: \(name)")
        print("WhatsappStickerManager: publisher: \(publisher)")
        print("WhatsappStickerManager: trayImageFileName: \(trayImageFileNameNew)")
        print("WhatsappStickerManager: publisherWebsite: \(publisherWebsite)")
        
        //Send the sticker package to whatsapp
        let stickerPack = try StickerPack(  identifier: bundleID!,
                                            name: name,
                                            publisher: publisher,
                                            trayImageFileName: trayImageFileNameNew,
                                            publisherWebsite: publisherWebsite,
                                            privacyPolicyWebsite: nil,
                                            licenseAgreementWebsite: nil)
        let stickers = StickerInnerPackHttpModel_.stickers
        var x = 0
        for StickerHttpModel_ in stickers! {
            var imageFileName:String
            if(trayImageFileName.hasPrefix("http")){
                imageFileName = StickerHttpModel_.uri
                imageFileName = imageFileName.replacingOccurrences(of: " ", with: "%20")
            }
            else{
                imageFileName = StickerHttpModel_.imageFileName
            }
            
            x += 1
            
            print("WhatsappStickerManager: Image number: \(x)")
            
            print("WhatsappStickerManager: Adding sticker image: \(imageFileName)")
            
            let fileExtension: String = (imageFileName as NSString).pathExtension
            
            print("WhatsappStickerManager: File extention: \(fileExtension)")
            
            if(x==9){
                x = 9
            }
            try stickerPack.addSticker(contentsOfFile: imageFileName, emojis: nil)
        }
        stickerPack.sendToWhatsApp { _ in }
        
        //Callback for complete
        if(self.onCompleted != nil){
            self.onCompleted!()
        }
    }
        
    func downloadToWhatsapp(StickerInnerPackHttpModel_:StickerInnerPackHttpModel) throws {
        
        //Init the tray image to be downloaded to disk
        var FileMultiFile_ = FileMultiFile()
        FileMultiFile_.url = StickerInnerPackHttpModel_.trayImageUri
        FileMultiFile_.fileName = StickerInnerPackHttpModel_.trayImageFile
        MultiFileDownloaderManager.shared.addFileToDownload(FileMultiFile_: FileMultiFile_)
        
        //Init the stickers image files to be download to disk
        let stickers = StickerInnerPackHttpModel_.stickers
        for StickerHttpModel_ in stickers! {
            	
            FileMultiFile_ = FileMultiFile()
            FileMultiFile_.url = StickerHttpModel_.uri
            FileMultiFile_.fileName = StickerHttpModel_.imageFileName
            MultiFileDownloaderManager.shared.addFileToDownload(FileMultiFile_: FileMultiFile_)
        }
        
        //Download all the files to disk
        MultiFileDownloaderManager.shared.onCompleted = {
            
            do {
                  
                //Create the file path
                let documentsDir = try FilesManager.shared.getFileFromDocumentDirectoryPath(fileName: FileMultiFile_.fileName)
                let trayImageFileName = documentsDir?.absoluteString
                
                //Download the whatsapp stickr pack to whatsapp app
                try! self.downloadToWhatsappUtil(StickerInnerPackHttpModel_: StickerInnerPackHttpModel_, trayImageFileName: trayImageFileName!)
                
            }
            catch {
                
                print("WhatsappStickerManager: Error \(error.localizedDescription)")
                print("WhatsappStickerManager: Error \(error)")
                
                //Callback for errors
                if(MultiFileDownloaderManager.shared.onError != nil){
                    MultiFileDownloaderManager.shared.onError!(error)
                }
            }
        }
        try MultiFileDownloaderManager.shared.download()
    }
}
