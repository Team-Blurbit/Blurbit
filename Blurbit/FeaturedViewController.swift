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

    var recommendations: [NSDictionary] = []

    override func viewDidLoad() {
        print("FeaturedViewController.swift: viewDidLoad()")
        super.viewDidLoad()
        self.featuredTableView.dataSource = self
        self.featuredTableView.delegate = self
        self.loadPredictions()
    }

    override func viewDidAppear(_ animated: Bool) {
        print("FeaturedViewController.swift: viewDidAppear()")
        self.loadPredictions()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("FeaturedViewController.swift: tableView(cellForRowAt)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedTableViewCell") as! FeaturedTableViewCell
        let recommendation = self.recommendations[indexPath.row]
        print(recommendation)
        cell.author.text = recommendation["author"] as? String
        cell.rating.text = "5"
        cell.title.text = recommendation["title"] as? String
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("FeaturedViewController.swift: tableView(numberOfRowsInSection)")
        return self.recommendations.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }

    func loadPredictions() {
        print("FeatureViewController.swift: loadPredictions()")
        let model = ItemSimilarityRecommender()
        // items = list of ratings to evaluate the model
        // k = number of recommendations
        // retrict_ = ???
        // exclude = ???
        guard let prediction = try? model.prediction(input: ItemSimilarityRecommenderInput(items: ["Alice in Wonderland" : 3.0], k: 5, restrict_: ["None"], exclude: ["None"])) else {
            fatalError("FeaturedViewController.swift: runtime error while generating prediction")
        }
        print(prediction.recommendations)
        for recommendation in prediction.recommendations {
            let author = database[recommendation] as! String
            let title = recommendation
            self.recommendations.append(["author": author, "title": title])
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
