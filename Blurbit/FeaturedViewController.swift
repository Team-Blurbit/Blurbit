//
//  FeaturedViewController.swift
//  Blurbit
//
//  Created by user163612 on 4/15/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//

import UIKit
import Parse

class FeaturedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        let main=UIStoryboard(name: "Main", bundle: nil)
        let loginViewController=main.instantiateViewController(withIdentifier: "LoginViewController")
        let delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        delegate.window?.rootViewController=loginViewController
    }

}
