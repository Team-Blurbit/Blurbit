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
    var searches = [Int:(PFObject,PFObject)]()
    //var books = [PFObject]()
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
        super.viewDidAppear(true)
        self.loadSearches()
    }
    
    /*override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.searches=[Int:(PFObject,PFObject)?]() as! [Int : (PFObject, PFObject)]
        /*var search:PFObject
        var book:PFObject
        (search,book)=searches[0]!
        print(search)*/
        //self.books=[PFObject]()
    }*/

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
        if (self.searches.count > indexPath.row) {
            var search:PFObject
            var book:PFObject
            (search,book)=searches[indexPath.row]!            //book.fetchIfNeeded()
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
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground { (searchResults, error) in
            if (searchResults != nil) {
                print("searching...")
                //self.searches = searches!
                self.loadBooks(searchResults:searchResults!)
                print("searched")
            } else {
                let message = error?.localizedDescription ?? "error loading search records"
                print("FeedViewController.swift: \(message)")
            }
        }
    }
    
    func loadBooks(searchResults:[PFObject]) {
        self.searches=[Int:(PFObject,PFObject)]()
        print("RecentViewController.swift: loadBooks()")
        //self.books = [] // reset books array before appending
        var idx=0
        for search in searchResults{
            let query = PFQuery(className: "Book")
            query.whereKey("objectId", equalTo: search["bookId"]!)
            //query.addDescendingOrder("createdAt")
            query.findObjectsInBackground { (data, error) in
                if let error = error {
                    print("FeedViewController.swift: \(error.localizedDescription)")
                }
                if data != nil {
                    //print(data!.count)
                    //self.books.append(data![0])
                    self.searches[idx]=(search,data![0])
                    print(self.searches[idx])
                    idx=idx+1
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
            var search:PFObject
            var book:PFObject
            (search,book)=searches[indexPath.row]!
            print("searching for user reviews...")
            let query=PFQuery(className: "Review")
            let gtin=search["isbn"] as! String
            query.includeKey("userId")
            query.whereKey("bookId", equalTo: search["bookId"]!)
            query.findObjectsInBackground { (data, error) in
                print("data")
                print(data)
                if let data=data{
                    let reviewsd=data
                    print("reviews2:")
                    print(reviewsd)
                    let reviewsViewController=segue.destination as! ReviewsViewController
                    print("search")
                    print(search["isbn"] as! String)
                    reviewsViewController.gtin=gtin
                    reviewsViewController.isRecentSearch = true
                    //reviewsViewController.reviews2=reviewsd
                    self.recentTableView.deselectRow(at: indexPath, animated: true)
                }
                else{
                    let reviewsViewController=segue.destination as! ReviewsViewController
                    reviewsViewController.gtin=gtin
                    reviewsViewController.isRecentSearch = true
                    self.recentTableView.deselectRow(at: indexPath, animated: true)
                    
                }
            }
                //pass the selected search's isbn to the reviews view controller
            
        }
        if (sender as? UIButton) != nil{
            if let indexPath=getIndexPath(sender as! UIButton){
                let ratingController=segue.destination as! RatingViewController
                var search:PFObject
                var book:PFObject
                (search,book)=searches[indexPath.row]!
                ratingController.bookId = search["bookId"] as! String
                print("bookId")
                print(ratingController.bookId)
                ratingController.isbn = search["isbn"] as! String
                print("isbn")
                print(ratingController.isbn)
                ratingController.imageUrl=book["imageUrl"] as! String
                //var url=URL(string:imageUrl)!
                //ratingController.bookCover.af_setImage(withURL: url)
                //print(ratingController.isbn)
            }
        }
    }

}
