//
//  RecentViewController.swift
//  Blurbit
//
//  Created by Frank Piva on 4/12/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//

import Parse
import UIKit

class RecentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var recentTableView: UITableView!
    var searches = [PFObject]()

    override func viewDidLoad() {
        print("RecentViewController.swift: viewDidLoad()")
        super.viewDidLoad()
        self.recentTableView.dataSource = self
        self.recentTableView.delegate = self
        self.loadSearches()
    }

    override func viewDidAppear(_ animated: Bool) {
        print("RecentViewController.swift: viewDidLoad()")
        self.loadSearches()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("RecentViewController.swift: tableView(cellForRowAt)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentTableViewCell") as! RecentTableViewCell
        let search = searches[indexPath.row]
        cell.bookAuthor.text = search["author"] as? String
        cell.bookTitle.text = search["title"] as? String
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("RecentViewController.swift: tableView(numberOfRowsInSection)")
        return searches.count
    }

    func loadSearches() {
        print("RecentViewController.swift: loadSearches()")
        let query = PFQuery(className: "Search")
        query.limit = 10
        query.includeKeys(["author", "title"])
        query.whereKey("user", equalTo: PFUser.current()!)
        query.findObjectsInBackground { (searches, error) in
            if (searches != nil) {
                self.searches = searches!
                self.recentTableView.reloadData()
            } else {
                let message = error?.localizedDescription ?? "error loading search records"
                print("FeedViewController.swift: \(message)")
            }
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        let main=UIStoryboard(name: "Main", bundle: nil)
        let loginViewController=main.instantiateViewController(withIdentifier: "LoginViewController")
        let delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        delegate.window?.rootViewController=loginViewController    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //find the selected search
        let cell=sender as! RecentTableViewCell
        let indexPath=recentTableView.indexPath(for: cell)!
        let search=searches[indexPath.row]
        //pass the selected search's isbn to the reviews view controller
        let reviewsViewController=segue.destination as! ReviewsViewController
        reviewsViewController.gtin=search["isbn"] as! String
        recentTableView.deselectRow(at: indexPath, animated: true)
    }
}
