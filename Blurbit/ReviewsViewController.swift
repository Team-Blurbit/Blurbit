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
    var bookTitle = "Unknown Title"
    var authorName="Unknown"
    var isRecentSearch = false
    var ratingNum = 0
    var ratingsTotal = 0
    var reviews=[[String:Any]]()
    var reviews2=[PFObject]()
    var useASIN = false
    var genre="unknown"
    

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startSetup();
    }

    func startSetup(){
        print("ReviewsViewController.swift: startSetup()")
        LoadingOverlay.shared.displayOverlay(backgroundView:self.view)
        //print(self.gtin)
        tableView.delegate=self
        tableView.dataSource=self
        //loadReviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadReviews()
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("ReviewsViewController.swift: tableView(forRowAt)")
        DispatchQueue.main.async{
            LoadingOverlay.shared.hideOverlay()
        }
    }
    
    func loadReviews(){
        print("ReviewsViewController.swift: loadReviews()")
        //test GTIN:9780141362250
        
        var url: URL
        // if GTIN is 10 characters long, it's *probably* an ASIN
        if (self.gtin.count == 10) {
            url = URL(string: "https://api.rainforestapi.com/request?api_key=379913B5856E4E079E13E66CDD814EB9&type=reviews&amazon_domain=amazon.com&asin="+self.gtin)!
        } else {
            url = URL(string: "https://api.rainforestapi.com/request?api_key=379913B5856E4E079E13E66CDD814EB9&type=reviews&amazon_domain=amazon.com&gtin="+self.gtin)!
        }

        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print("ReviewsViewController.swift: ", error.localizedDescription)
                //self.loadReviews()
            } else if let data = data {
                do {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    print("datadict")
                    print(dataDictionary)
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
                    if let author=product["sub_title"] as? [String:Any] {
                        if let bookAuthor=author["text"] as? String{
                        self.authorName=bookAuthor
                            if self.authorName.contains(","){
                                let splitChars=self.authorName.split(separator: ",")
                                let lastName=splitChars[0]
                                let firstName=splitChars[1]
                                self.authorName=firstName+" "+lastName as String
                            }
                        }
                    }
                        
                    let ratings=dataDictionary["summary"] as! [String:Any]
                    if let ratingNumber=ratings["rating"] as? Double{
                        self.ratingNum=Int(ratingNumber)
                    }
                    if let ratingtotal=ratings["ratings_total"] as? Int{
                        self.ratingsTotal=ratingtotal
                    }
                    // print("IMG URL: \(self.imageURL.absoluteString)")
                    if self.reviews.count == 0 {
                        self.performSegue(withIdentifier: "NoReviews", sender: self)
                    }
                }
                self.tableView.reloadData()
                self.getGenre()
            }
        }
        task.resume()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("ReviewsViewController.swift: tableView(numberOfRowsInSection)")
        return reviews2.count+reviews.count
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
        else if indexPath.row <= reviews2.count{
            let cell=tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewViewCell
            let review=reviews2[indexPath.row-1]
            // print(review)
            let ratingNumb=review["rating"] as! Int
            cell.titleLabel.text=review["title"] as? String
            let imageName="stars_\(ratingNumb).png" as String
            cell.ratingView.image=UIImage(named:imageName)!
            let user=review["userId"] as! PFUser
            let profile=user["username"] as? String
            print(profile)
            cell.usernameLabel.text=profile as? String
            cell.reviewLabel.text=review["comment"] as? String
            return cell
        }
        else{
            let cell=tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewViewCell
            let review=reviews[indexPath.row-reviews2.count]
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

    func createSearch(bookId:String) {
        //check if book with title and author exists already
        var query=PFQuery(className:"Search")
        query=query.whereKey("isbn", equalTo: self.gtin)
        query=query.whereKey("user",equalTo: PFUser.current()!)
        query.findObjectsInBackground { (data, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            else{
                print("data")
                print(data != nil && data!.count > 0)
            }
            if (data != nil && data!.count == 0) || (data == nil) {        print("ReviewsViewController.swift: createSearch()")
                let search = PFObject(className: "Search")
                search["bookId"]=bookId
                search["isbn"]=self.gtin
                search["user"] = PFUser.current()!
                //review will be added later on
                search.saveInBackground { (success, error) in
                    if (success) {
                        print("ReviewsViewController.swift: search record saved")
                   } else {
                        let message = error?.localizedDescription ?? "error creating search record"
                        print("ReviewsViewController.swift: \(message)")
                   }
                }
            }
            else{
                DispatchQueue.main.async{
                    print("ReviewsViewController.swift: loadAppReviews()")
                    //self.loadAppReviews(bookId: bookId)
                }
                
            }
        }
    }
    
    func getGenre(){
        print("ReviewsViewController.swift: getGenre()")
        var key="unknown"
        //call openlibrary API
        //get key by //isbn-13:http://openlibrary.org/api/things?query={%22type%22:%22\/type\/edition%22,%22isbn_13%22:%229780061120084%22}
        var urlString=""
        if (useASIN==false){
            urlString = "https://openlibrary.org/api/things?query={\"type\":\"\\/type\\/edition\",\"isbn_13\":\""+self.gtin+"\"}"
        }
        else{
            urlString = "https://openlibrary.org/api/things?query={\"type\":\"\\/type\\/edition\",\"isbn_10\":\""+self.gtin+"\"}"
        }
        //print(urlString)
        //print(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        if let url=URL(string:urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                //print("json got through")
                //print(dataDictionary)
                if let keyResult=dataDictionary["result"] as? [String] {
                    if keyResult.count > 0 {
                        key=keyResult[0] as! String
                        key=key.replacingOccurrences(of: "/books/", with: "/b/")
                        //print(key)
                        DispatchQueue.main.async{
                            self.loadActualGenre(key:key)
                        }
                    }
                else{
                       DispatchQueue.main.async{
                           self.createBook()
                       }
                    }
            }
            else{
               DispatchQueue.main.async{
                   self.createBook()
               }
            }
            }
        }        //get genre with key: http://openlibrary.org/api/get?key=/b/OL1001932M
        //print("also got here")
                //print("also post")
            task.resume()
        }
    }

    func loadActualGenre(key:String){
        print("ReviewsViewController.swift: getActualGenre()")
        //print("key: \(key)")
        if key != "unknown"{
            let urlString="https://openlibrary.org/api/get?key="+key
            let urlVar=urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let url2 = URL(string: urlVar)!
            //print(urlVar)
            let session2 = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            session2.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
            let task2 = session2.dataTask(with: url2) { (data2, response2, error2) in
                if error2 != nil {
                    let message = error2?.localizedDescription ?? "error retrieving genre"
                    print("ReviewsViewController.swift: \(message)")
                } else if let data2 = data2,let dataDictionary2 = try! JSONSerialization.jsonObject(with: data2, options: []) as? [String: Any]{
                    //print("success data")
                    //print(dataDictionary2["result"]!))
                    let resultsData=dataDictionary2["result"]! as! [String:Any]
                    //print(resultsData)
                    if let genreResult=resultsData["genres"] as? [String]{
                        //print(genreResult)
                        self.genre=genreResult[0]
                    }
                    else if let subjectResults=resultsData["subjects"] as? [String]{
                        //print(subjectResults)
                        self.genre=subjectResults[0]
                    }
                    //print("genre post request")
                    //print(self.genre)
                    DispatchQueue.main.async{
                        self.createBook()
                    }
                }
                else{
                    DispatchQueue.main.async{
                        self.createBook()
                    }
                }
            }
            //print("got here")
            task2.resume()
            //print("gh post")
        }
    }

    func createBook(){
        print("ReviewsViewController.swift: createBook()")
        //print(self.authorName)
        //print(self.bookTitle)
        var bookId=""
        //check if book with title and author exists already
        var query=PFQuery(className:"Book")
        query=query.whereKey("isbn", equalTo: self.gtin)
        query.findObjectsInBackground { (data, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("data")
                print(data != nil && data!.count > 0)
            }
            // if the book isn't in our database, create a Book and Search record
            if (data != nil && data!.count == 0) || (data == nil) {
                let book = PFObject(className: "Book")
                book["author"] = self.authorName
                book["title"] = self.bookTitle
                book["genre"] = self.genre
                book["isbn"]=self.gtin
                book["imageUrl"]=self.imageURL.absoluteString
                book.saveInBackground { (success, error) in
                    if (success) {
                        print("ReviewsViewController.swift: book record saved")
                        bookId=book.objectId!
                        self.createSearch(bookId: bookId)
                   } else {
                        let message = error?.localizedDescription ?? "error creating book record"
                        print("ReviewsViewController.swift: \(message)")
                   }
                }
                
            }
            // the book already exists in our database, don't add a Book record
            else if data != nil && data!.count > 0 {
                // if the book isn't a recent search, create a Search record
                //if self.isRecentSearch == false {
                    //DispatchQueue.main.async{
                    bookId = data![0].objectId!
                    self.createSearch(bookId: bookId)
                        //self.loadAppReviews(bookId:bookId)
                    //}
                //}
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier != "NoReviews") {
            let expandedReview = segue.destination as! ReviewViewController
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)!
            let review = reviews[indexPath.row]
            
            expandedReview.reviewOBJ = review
            tableView.deselectRow(at: indexPath, animated: true)
        }
        else {
            let noReviewsView = segue.destination as! NoReviewsViewController
            let ratingImageName="stars_\(self.ratingNum).png" as String
            
            noReviewsView.url = imageURL.absoluteString
            
            if(authorName == "Unknown") {
                noReviewsView.a = "Author Unknown"
            }
            else {
                noReviewsView.a = authorName
            }
            
            noReviewsView.t = bookTitle
            noReviewsView.img = UIImage(named:ratingImageName)!
            
            self.navigationController?.popViewController(animated: false)
        }
         
    }

}

// B003H4I5G2
