//
//  ReviewsViewController.swift
//  Blurbit
//
//  Created by user163612 on 4/7/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//

import AlamofireImage
import Parse
import UIKit

class ReviewsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var gtin=""
    var imageURL=URL(string:"https://camo.githubusercontent.com/e69c2fe22d071aa6c93355e008fe56a9aff0a14a/68747470733a2f2f692e696d6775722e636f6d2f763257514346412e706e67")!
    var bookTitle = "unknown title"
    var authorName="unknown"
    var ratingNum = 0
    var ratingsTotal = 0
    var reviews=[[String:Any]]()
    var useASIN = false

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startSetup();
    }

    func startSetup(){
        print("ReviewsViewController.swift: startSetup()")
        print(self.gtin)
        tableView.delegate=self
        tableView.dataSource=self
        loadReviews()
    }

    func loadReviews(){
        print("ReviewsViewController.swift: loadReviews()")
        //test GTIN:9780141362250
        
        var url: URL
        if(useASIN == false){
            url = URL(string: "https://api.rainforestapi.com/request?api_key=379913B5856E4E079E13E66CDD814EB9&type=reviews&amazon_domain=amazon.com&gtin="+self.gtin)!
        }
        else{
            url = URL(string: "https://api.rainforestapi.com/request?api_key=379913B5856E4E079E13E66CDD814EB9&type=reviews&amazon_domain=amazon.com&asin="+self.gtin)!
        }
    
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print("ReviewsViewController.swift: ", error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                // TODO: Unexpectedly found nil while unwrapping an Optional value
                self.reviews=dataDictionary["reviews"] as! [[String:Any]]
                let product=dataDictionary["product"] as! [String:Any]
                if let imageData=product["image"] as? String{
                    let imageUrl=URL(string:imageData)!
                    self.imageURL=imageUrl
                }
                if let title=product["title"] as? String{
                    self.bookTitle=title
                }
                let author=product["sub_title"] as! [String:Any]
                if let bookAuthor=author["text"] as? String{
                self.authorName=bookAuthor
                    if self.authorName.contains(","){
                        let splitChars=self.authorName.split(separator: ",")
                        let lastName=splitChars[0]
                        let firstName=splitChars[1]
                        self.authorName=firstName+" "+lastName as String
                    }
                }
                let ratings=dataDictionary["summary"] as! [String:Any]
                if let ratingNumber=ratings["rating"] as? Double{
                    self.ratingNum=Int(ratingNumber)
                }
                if let ratingtotal=ratings["ratings_total"] as? Int{
                    self.ratingsTotal=ratingtotal
                }
                // print(self.reviews[0])
                // print(product)
                // create new Searche record
                self.createSearch()
                
                self.tableView.reloadData()
            }
        }
        task.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("ReviewsViewController.swift: tableView(numberOfRowsInSection)")
        return reviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("ReviewsViewController.swift: tableView(cellForRowAt)")
        if indexPath.row == 0 {
            let cell=tableView.dequeueReusableCell(withIdentifier: "BookCell") as! BookViewCell
            cell.bookTitle.text=self.bookTitle
            cell.bookAuthor.text="By "+self.authorName
            
            // print(self.ratingNum)
            let ratingImageName="stars_\(self.ratingNum).png" as String
            cell.ratingView.image=UIImage(named:ratingImageName)
            let ratingText="\(self.ratingsTotal) customer ratings"
            cell.ratingLabel.text=ratingText
            cell.bookImage.af_setImage(withURL: self.imageURL)
            return cell
        }
        else {
            let cell=tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewViewCell
            let review=reviews[indexPath.row]
            // print(review)
            let ratingNumb=review["rating"] as! Int
            cell.titleLabel.text=review["title"] as? String
            let imageName="stars_\(ratingNumb).png" as String
            cell.ratingView.image=UIImage(named:imageName)!
            let profile=review["profile"] as! [String:Any]
            cell.usernameLabel.text=profile["name"] as? String
            cell.reviewLabel.text=review["body"] as? String
            return cell
        }
    }

    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        let main=UIStoryboard(name: "Main", bundle: nil)
        let loginViewController=main.instantiateViewController(withIdentifier: "LoginViewController")
        let delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        delegate.window?.rootViewController=loginViewController
    }
    
    func createSearch() {
        print("ReviewsViewController.swift: createSearch()")
        let search = PFObject(className: "Search")
        search["author"] = self.authorName
        search["title"] = self.bookTitle
        search["user"] = PFUser.current()!
        search["isbn"]=self.gtin
        search.saveInBackground { (success, error) in
            if (success) {
                print("ReviewsViewController.swift: search record saved")
           } else {
                let message = error?.localizedDescription ?? "error creating search record"
                print("ReviewsViewController.swift: \(message)")
           }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let expandedReview = segue.destination as! ReviewViewController
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let review = reviews[indexPath.row]
        
        expandedReview.reviewOBJ = review
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
// B003H4I5G2
