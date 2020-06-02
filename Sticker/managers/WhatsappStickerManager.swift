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
                    
                let bundleID = Bundle.main.bundleIdentifier
                let name = (StickerInnerPackHttpModel_.name)!
                let publisher = (StickerInnerPackHttpModel_.publisher)!
                let documentsDir = try FilesManager.shared.getFileFromDocumentDirectoryPath(fileName: FileMultiFile_.fileName)
                let trayImageFileName = documentsDir?.absoluteString
                
                //Send the sticker package to whatsapp
                let stickerPack = try StickerPack(  identifier: bundleID!,
                                                    name: name,
                                                    publisher: publisher,
                                                    //trayImageFileName: FileMultiFile_.url!,
                                                    trayImageFileName: "http://sinlimiteweb.com/Overoles_285803.png",
                                                    publisherWebsite: "www.gatitosyperritoschidos.com",
                                                    privacyPolicyWebsite: nil,
                                                    licenseAgreementWebsite: nil)
                for StickerHttpModel_ in stickers! {
                    try stickerPack.addSticker(contentsOfFile: StickerHttpModel_.imageFileName, emojis: nil)
                }
                stickerPack.sendToWhatsApp { _ in }
                
                //Callback for complete
                if(self.onCompleted != nil){
                    self.onCompleted!()
                }
                
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
