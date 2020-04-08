//
//  SearchViewController.swift
//  Blurbit
//
//  Created by user163612 on 4/7/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//

import UIKit
import MTBBarcodeScanner

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var isbn: UILabel!
    var isbn_value: String = ""
    
    var scanner: MTBBarcodeScanner?
    override func viewDidLoad() {
        super.viewDidLoad()
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
        })        // Do any additional setup after loading the view.
        startSetup();
    }
    
    func startSetup(){
        
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let reviewsViewController=segue.destination as! ReviewsViewController
    }

}
