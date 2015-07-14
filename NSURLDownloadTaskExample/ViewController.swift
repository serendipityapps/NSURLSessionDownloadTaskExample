//
//  ViewController.swift
//  NSURLDownloadTaskExample
//
//  Created by David Roberts on 14/07/2015.
//  Copyright © 2015 Dave Roberts. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let paths = NSSearchPathForDirectoriesInDomains(.DesktopDirectory, .UserDomainMask, true)

        if let desktopPath = paths.first {
            
            let filePathToCopyTo = desktopPath.stringByAppendingPathComponent("downloadedFile.pdf")
            
            downloadFile("http://devstreaming.apple.com/videos/wwdc/2015/711y6zlz0ll/711/711_networking_with_nsurlsession.pdf?dl=1", locationToCopyToPath:filePathToCopyTo)
        }
    }
    
    func downloadFile(fileToDownload: String, locationToCopyToPath:String) {
        
        let url = NSURL(string: fileToDownload)
        let urlToCopyTo = NSURL(fileURLWithPath: locationToCopyToPath)  // NOTE: fileURLWithPath initializer for local file path

        if let unwrappedURL = url {
            
            let downloadTask = NSURLSession.sharedSession().downloadTaskWithURL(unwrappedURL) { (urlToCompletedFile, reponse, error) -> Void in
                
                // unwrap error if present
                if let unwrappedError = error {
                    print(unwrappedError)
                }
                else {
                    
                    if let unwrappedURLToCachedCompletedFile = urlToCompletedFile {
                        
                        print(unwrappedURLToCachedCompletedFile)
                        
                        // Swift 2
                        do {
                         try NSFileManager.defaultManager().moveItemAtURL(unwrappedURLToCachedCompletedFile, toURL: urlToCopyTo)
                        }
                        catch let error {
                            print(error)
                        }
                        
                        // Swift 1.2
                        // NSFileManager.defaultManager().moveItemAtURL(unwrappedURLToCachedCompletedFile, toURL: urlToCopyTo, error:nil)
                        
                        // Careful here this moving / copying can fail and give errors - i.e if file already present, can be dealt with by using delegate of NSFileManager such as: -
                        
                        // optional func fileManager(fileManager: NSFileManager, shouldMoveItemAtURL srcURL: NSURL, toURL dstURL: NSURL) -> Bool

                    
                    }
                }
            }
            downloadTask?.resume()
        }
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

