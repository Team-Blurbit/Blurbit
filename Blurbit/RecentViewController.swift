//
//  RecentViewController.swift
//  Blurbit
//
//  Created by administrator on 4/12/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//

import Parse
import UIKit

class RecentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var recentTableView: UITableView!
    var recents = [PFObject]()

    override func viewDidLoad() {
        print("RecentViewController.swift: viewDidLoad()")
        super.viewDidLoad()
        self.recentTableView.dataSource = self
        self.recentTableView.delegate = self
        let query = PFQuery(className: "Book")
        query.includeKeys(["author", "title"])
        query.limit = 20
        query.findObjectsInBackground { (books, error) in
            if (books != nil) {
                self.recents = books!
                self.recentTableView.reloadData()
            } else {
                print("FeedViewController.swift: \(error?.localizedDescription)")
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("RecentViewController.swift: tableView()")
        return recents.count // TODO: make this dynamic
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("RecentViewController.swift: tableView()")
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentTableViewCell") as! RecentTableViewCell
        
        let recent = recents[indexPath.row]
        cell.bookAuthor.text = recent["author"] as? String
        print(cell.bookAuthor.text)
        cell.bookTitle.text = recent["title"] as? String
        print(cell.bookTitle.text)
        return cell
    }

}
