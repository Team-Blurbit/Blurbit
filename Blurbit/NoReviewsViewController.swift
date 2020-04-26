//
//  NoReviewsViewController.swift
//  Blurbit
//
//  Created by Marco Aguilera on 4/26/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//

import UIKit
import AlamofireImage

class NoReviewsViewController: UIViewController {

    @IBOutlet var poster: UIImageView!
    @IBOutlet var bookTitle: UILabel!
    @IBOutlet var author: UILabel!
    @IBOutlet var rating: UIImageView!
    
    var cell = BookViewCell()
    var a = ""
    var t = ""
    var img = UIImage()
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        poster.af_setImage(withURL: URL(string:url)!)
        bookTitle.text = t
        author.text = a
        rating.image = img
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
