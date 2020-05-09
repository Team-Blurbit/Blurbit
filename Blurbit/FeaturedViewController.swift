//
//  FeaturedViewController.swift
//  Blurbit
//
//  Created by user163612 on 4/15/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//

import Parse
import UIKit

class FeaturedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var featuredTableView: UITableView!

    // hard coded dictionary for now
    // later we will cross reference the title with the Book class in Parse
    var database: NSDictionary = [
        "Alice in Wonderland": "Lewis Carrol",
        "Bag of Bones": "Stephen King",
        "California": "Edan Lepucki",
        "Dark Voyage": "Alan Furst",
        "Emma": "Jane Austin",
        "Fall of Frost": "Brian Hall",
        "Great Expectations": "Charles Dickens",
        "Holes": "Louis Sachar"
    ]

    var recommendations: [[String: Any]] = []
    var reviews: [String: Double] = [:]
    
    override func viewDidLoad() {
        print("FeaturedViewController.swift: viewDidLoad()")
        super.viewDidLoad()
        self.featuredTableView.dataSource = self
        self.featuredTableView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        print("FeaturedViewController.swift: viewDidAppear()")
        self.loadReviews()
    }

    override func viewDidDisappear(_ animated: Bool) {
        self.recommendations = []
        self.reviews = [:]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("FeaturedViewController.swift: tableView(cellForRowAt)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedTableViewCell") as! FeaturedTableViewCell
        let recommendation = self.recommendations[indexPath.row]
        //print("recommendation=<\(recommendation)>")
        cell.author.text = recommendation["author"] as? String
        let url = URL(string: recommendation["imageUrl"]! as! String)
        cell.coverView.af_setImage(withURL: url!)
        cell.rating.text = ""
        cell.title.text = recommendation["title"] as? String
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("FeaturedViewController.swift: tableView(numberOfRowsInSection)")
        return self.recommendations.count
    }

    func loadPredictions() {
        print("FeaturedViewController.swift: loadPredictions()")
        let model = ItemSimilarityRecommender()
        // items = The list of items used to generate the recommendations.
        // k = The number of items to return on a recommendation.
        // retrict_ = A sequence of items from which to generate recommendations.
        // exclude = A sequence of items to exclude from recommendations.  Defaults to the input item list if not given.
        // if user has no reviews add a dummy review to seed the recommender
        if self.reviews.count < 1 {
            print("FeaturedViewController.swift: user has no reviews")
        } else {
            print("FeaturedViewController.swift: user has at least one review")
        }
        guard let prediction = try? model.prediction(input: ItemSimilarityRecommenderInput(items: self.reviews, k: 5, restrict_: ["None"], exclude: ["None"])) else {
            fatalError("FeaturedViewController.swift: runtime error while generating prediction")
        }
        var ct=0
        //print("prediction.recommendations=<\(prediction.recommendations)>")
        for recommendation in prediction.recommendations {
            ct=ct+1
            self.getBookById(bookId: recommendation)
        }
        //print("count:")
        //print(ct)
        self.featuredTableView.reloadData()
    }

    //func getBookById(bookId: String) -> [String: Any] {
    func getBookById(bookId: String) {
        print("FeaturedViewController.swift: getBookById(bookId: \(bookId))")
        let query = PFQuery(className: "Book")
        var detailedBook: [String: Any] = [:]
        query.includeKeys(["author", "title"])
        query.limit = 1
        query.whereKey("objectId", equalTo: bookId)
        query.findObjectsInBackground { (books, error) in
            if books != nil {
                //print("found books")
                //print("books=<\(books!)>")
                for book in books! {
                    //print("book[\"author\"]=<\(book["author"]!)>")
                    //print("book[\"imageUrl\"]!=<\(book["imageUrl"]!)>")
                    //print("book[\"isbn\"]=<\(book["isbn"]!)>")
                    //print("book[\"title\"]=<\(book["title"]!)>")
                    detailedBook["author"] = book["author"]!
                    detailedBook["imageUrl"] = book["imageUrl"]!
                    detailedBook["isbn"] = book["isbn"]!
                    detailedBook["title"] = book["title"]!
                    //print("detailedBook=<\(detailedBook)>")
                    self.recommendations.append(detailedBook)
                    self.featuredTableView.reloadData()
                    return
                }
            } else {
                let message = error?.localizedDescription ?? "error loading book record"
                print("FeaturedViewController.swift: \(message)")
            }
        }
        //print("detailedBook=<\(detailedBook)>")
        //return detailedBook
    }

    func loadReviews() {
        print("FeaturedViewController.swift: loadReviews()")
        let query = PFQuery(className: "Review")
        query.includeKeys(["bookId", "rating"])
        query.limit = 10
        query.whereKey("userId", equalTo: PFUser.current()!)
        query.findObjectsInBackground { (reviews, error) in
            if reviews != nil {
                for review in reviews! {
                    self.reviews["\(review["bookId"]!)"] = review["rating"] as? Double
                }
            } else {
                let message = error?.localizedDescription ?? "error loading review records"
                print("FeaturedViewController.swift: \(message)")
            }
            self.loadPredictions()
        }
    }

    @IBAction func onLogout(_ sender: Any) {
        print("FeaturedViewController.swift: onLogout()")
        PFUser.logOut()
        let main=UIStoryboard(name: "Main", bundle: nil)
        let loginViewController=main.instantiateViewController(withIdentifier: "LoginViewController")
        let delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        delegate.window?.rootViewController=loginViewController
    }

}
