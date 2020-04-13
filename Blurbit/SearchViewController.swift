//
//  SearchViewController.swift
//  Blurbit
//
//  Created by user163612 on 4/7/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//

import UIKit
import MTBBarcodeScanner
import Parse

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet var previewView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var isbn: UILabel!
    var isbn_value: String = ""
    var scanner: MTBBarcodeScanner?
    var selection: Bool = false
    
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
        
        MTBBarcodeScanner.requestCameraPermission(success: { success in
            stringValue = ""
            self.isbn_value = ""
            self.selection = false
            
            if success {
                do {
                    try self.scanner?.startScanning(with: .back, resultBlock: { codes in
                        if let codes = codes {
                            
                            for code in codes {
                                if(self.isbn_value != code.stringValue) {
                                    self.isbn_value = code.stringValue!
                                    stringValue = code.stringValue!
                                    
                                    // We need to performSegue, send over the isbn number
                                    self.selection = true
                                    self.performSegue(withIdentifier: "searchSegue", sender: "selection")
                                    
//                                    if(counter == 0) {
//                                        //
//                                        print(stringValue)
//                                        counter+=1
//                                    }
//                                    else {
//                                        print(stringValue)
//                                        counter-=1
//                                    }
                                
                                // self.scanner?.stopScanning()
                                }
                            }
                        }
                    })
                    
                } catch {
                    NSLog("Unable to start scanning")
                }
                
                
            } else {
                let alert = UIAlertController(title: "Scanning Unavailable", message:  "This app does not have permission to access the camera", preferredStyle: UIAlertController.Style.alert)
                self.present(alert, animated: true, completion: nil)
                let when=DispatchTime.now()+5
                DispatchQueue.main.asyncAfter(deadline:when){
                    alert.dismiss(animated: true, completion: nil)
                }
            }
        })
        
    }
    
    func startSetup(){
        
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        let main=UIStoryboard(name: "Main", bundle: nil)
        let loginViewController=main.instantiateViewController(withIdentifier: "LoginViewController")
        let delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        delegate.window?.rootViewController=loginViewController
        
    }
    


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        var reviewsViewController=segue.destination as! ReviewsViewController
        
        if(selection == true) {
            reviewsViewController.gtin = isbn_value as! String
        }
        else {
            reviewsViewController.gtin=searchTextField.text as! String
        }
    
        
        // reviewsViewController.gtin=searchTextField.text as! String
    }

}
