//
//  ReviewsViewController.swift
//  Blurbit
//
//  Created by user163612 on 4/7/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//

import UIKit
import AlamofireImage

class ReviewsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var gtin=""
    var imageURL=URL(string:"https://camo.githubusercontent.com/e69c2fe22d071aa6c93355e008fe56a9aff0a14a/68747470733a2f2f692e696d6775722e636f6d2f763257514346412e706e67")!
    var bookTitle = ""
    var authorName="unknown"
    var reviews=[[String:Any]]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startSetup();
    }
    
    func startSetup(){
        tableView.delegate=self
        tableView.dataSource=self
        loadReviews()
        
    }
    
    func loadReviews(){
        let url = URL(string: "https://api.rainforestapi.com/request?api_key=379913B5856E4E079E13E66CDD814EB9&type=reviews&amazon_domain=amazon.com&gtin=9780141362250")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            self.reviews=dataDictionary["results"] as! [[String:Any]]
                let product=dataDictionary["product"] as! [[String:Any]]
                /*if let imageData=product["image"] as! String{
                let imageUrl=URL(imageData)
                self.imageURL=imageUrl
            }
            if let title=product["title"] as? String{
                self.bookTitle=title
            }
                if let bookAuthor=product["self.subtitle"]. as? String{
                self.authorName=bookAuthor
            }*/
                print(self.reviews)
                print(product)
            self.tableView.reloadData()
            }
        }
        task.resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count+1
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   if indexPath.row == 0 {
       let cell=tableView.dequeueReusableCell(withIdentifier: "BookCell") as! BookViewCell
       cell.bookTitle.text=self.bookTitle
       cell.bookAuthor.text=self.authorName
       let urlString=self.imageURL
       //let url=URL(string:urlString)!
       cell.bookImage.af_setImage(withURL: imageURL)
       return cell
   }
   else   {
       let cell=tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewViewCell
       let review=reviews[indexPath.row]
       cell.ratingLabel.text=review["rating"] as? String
       //cell.authorLabel.text=review["profile"]["name"] as? String
       cell.reviewLabel.text=review["body"] as? String
       return cell
   }   }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
