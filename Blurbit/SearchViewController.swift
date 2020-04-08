//
//  SearchViewController.swift
//  Blurbit
//
//  Created by Marco Aguilera on 4/8/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//
// SETUP CODE FOUND HERE: https://github.com/mikebuss/MTBBarcodeScanner/blob/develop/README.md


import UIKit
import MTBBarcodeScanner

class SearchViewController: UIViewController {

    @IBOutlet var previewView: UIView!
    @IBOutlet weak var isbn: UILabel!
    var isbn_value: String = ""
    
    var scanner: MTBBarcodeScanner?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // scanner = MTBBarcodeScanner(previewView: previewView)
        // scanner?.allowTapToFocus = true
        // Do any additional setup after loading the view.
        scanner = MTBBarcodeScanner(metadataObjectTypes: [AVMetadataObject.ObjectType.ean13.rawValue], previewView: previewView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var stringValue = ""
        var counter = 0;
        let colors = [UIColor.red, UIColor.white]
        MTBBarcodeScanner.requestCameraPermission(success: { success in
            if success {
                do {
                    try self.scanner?.startScanning(with: .back, resultBlock: { codes in
                        if let codes = codes {
                            
                            for code in codes {
                                if(code.stringValue != stringValue) {
                                    self.isbn_value = code.stringValue!
                                    stringValue = code.stringValue!
                                                                   
                                    self.isbn.text = "ISBN: " + (stringValue as String)
                                    self.isbn.textColor = colors[counter]
                                    
                                    if(counter == 0) {counter+=1}
                                    else {counter-=1}
                                }
                                // self.scanner?.stopScanning()
                            }
                        }
                    })
                    
                } catch {
                    NSLog("Unable to start scanning")
                }
                
                
            } else {
                let alert = UIAlertController(title: "Scanning Unavailable", message:  "This app does not have permission to access the camera", preferredStyle: UIAlertController.Style.alert)
                self.present(alert, animated: true, completion: nil)
            
            }
        })
        
    }
    
    /** Commented Out For Later Use ***
    /*******************************/
    override func viewWillDisappear(_ animated: Bool) {
        self.scanner?.stopScanning()
        
        super.viewWillDisappear(animated)
    }
    **/
    
}

