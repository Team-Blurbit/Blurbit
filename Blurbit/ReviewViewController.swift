//
//  ReviewViewController.swift
//  Blurbit
//
//  Created by Marco Aguilera on 4/25/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {


    @IBOutlet var rating: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var reviewTitle: UILabel!
    @IBOutlet var reviewView: UITextView!
    
    var reviewOBJ: [String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profile = reviewOBJ["profile"] as! [String: Any]
        let ratingNumb = reviewOBJ["rating"] as! Int
        let imgName = "stars_\(ratingNumb).png" as String
        
        rating.image = UIImage(named: imgName)
        reviewTitle.text = reviewOBJ["title"] as! String
        username.text = profile["name"] as! String
        reviewView.text = reviewOBJ["body"] as! String
        
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
