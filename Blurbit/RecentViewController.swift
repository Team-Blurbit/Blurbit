//
//  RecentViewController.swift
//  Blurbit
//
//  Created by Frank Piva on 4/12/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//

import Parse
import UIKit
import AlamofireImage

class RecentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,RecentTableViewCellDelegate {

    @IBOutlet weak var recentTableView: UITableView!
    var searches = [PFObject]()
    var books = [PFObject]()
    var index = 0

    override func viewDidLoad() {
        print("RecentViewController.swift: viewDidLoad()")
        super.viewDidLoad()
        LoadingOverlay.shared.displayOverlay(backgroundView:self.view)
        self.recentTableView.dataSource = self
        self.recentTableView.delegate = self
        self.loadSearches()
        print("done loading")
    }

    override func viewDidAppear(_ animated: Bool) {
        print("RecentViewController.swift: viewDidLoad()")
        self.loadSearches()
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async{
            LoadingOverlay.shared.hideOverlay()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("RecentViewController.swift: tableView(cellForRowAt)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentTableViewCell") as! RecentTableViewCell
        //print("RecentViewController.swift: self.books:<\(self.books)>")
        //print("RecentViewController.swift: self.books.count:<\(self.books.count)>")
        //print("RecentViewController.swift: indexPath.row:<\(indexPath.row)>")
        if (self.books.count > indexPath.row) {
            let book=self.books[indexPath.row]
            //book.fetchIfNeeded()
            //print("book \(book)")
            let imageUrl=book["imageUrl"] as! String
            //print(imageUrl)
            let url=URL(string: imageUrl)!
            cell.bookCover.af_setImage(withURL: url)
            cell.bookAuthor.text = book["author"] as! String
            cell.bookTitle.text = book["title"] as! String
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("RecentViewController.swift: tableView(numberOfRowsInSection)")
        return self.searches.count
    }

    func getIndexPath(_ sender:UIButton?) -> IndexPath?{
        let buttonPos=sender?.convert(CGPoint.zero, to: recentTableView)
        if let indexPath:IndexPath = recentTableView.indexPathForRow(at: buttonPos!){
            return indexPath
        }
        return nil
    }

    func loadSearches() {
        print("RecentViewController.swift: loadSearches()")
        let query = PFQuery(className: "Search")
        query.limit = 10
        query.includeKeys(["author", "title"])
        query.whereKey("user", equalTo: PFUser.current()!)
        query.findObjectsInBackground { (searches, error) in
            if (searches != nil) {
                print("searching...")
                self.searches = searches!
                self.loadBooks()
                print("searched")
            } else {
                let message = error?.localizedDescription ?? "error loading search records"
                print("FeedViewController.swift: \(message)")
            }
        }
    }

    func loadBooks() {
        print("RecentViewController.swift: loadBooks()")
        self.books = [] // reset books array before appending
        for search in self.searches{
            let query = PFQuery(className: "Book")
            query.whereKey("objectId", equalTo: search["bookId"])
            query.findObjectsInBackground { (data, error) in
                if let error = error {
                    print("FeedViewController.swift: \(error.localizedDescription)")
                }
                if data != nil {
                    //print(data!.count)
                    self.books.append(data![0])
                    self.index = self.index + 1
                    if self.index >= self.searches.count {
                        print("here")
                        self.recentTableView.reloadData()
                        return
                    }
                } else {
                    let message = "something unexpected happened"
                    print("FeedViewController.swift: \(message)")
                }
            }
        }
        self.recentTableView.reloadData()
        return
    }

    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        let main=UIStoryboard(name: "Main", bundle: nil)
        let loginViewController=main.instantiateViewController(withIdentifier: "LoginViewController")
        let delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        delegate.window?.rootViewController=loginViewController
    }

    func onRatingButton(_ sender: UIButton) {}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //find the selected search
        if let cell=sender as? RecentTableViewCell{
            let indexPath=recentTableView.indexPath(for: cell)!
            let search=searches[indexPath.row]
            //pass the selected search's isbn to the reviews view controller
            let reviewsViewController=segue.destination as! ReviewsViewController
            reviewsViewController.gtin=search["isbn"] as! String
            reviewsViewController.isRecentSearch = true
            recentTableView.deselectRow(at: indexPath, animated: true)
        }
        if (sender as? UIButton) != nil{
            if let indexPath=getIndexPath(sender as! UIButton){
                let ratingController=segue.destination as! RatingViewController
                let search=self.searches[indexPath.row]
                ratingController.bookId = search["bookId"] as! String
                print("bookId")
                print(ratingController.bookId)
                ratingController.isbn = search["isbn"] as! String
                print("isbn")
                print(ratingController.isbn)
                ratingController.imageUrl=self.books[indexPath.row]["imageUrl"] as! String
                //var url=URL(string:imageUrl)!
                //ratingController.bookCover.af_setImage(withURL: url)
                //print(ratingController.isbn)
            }
        }
    }

}
