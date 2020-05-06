//
//  SearchResultsViewController.swift
//  Blurbit
//
//  Created by Jesse Betts on 4/12/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//

import UIKit
import AlamofireImage

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return search_results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell()
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell") as! BookCell
        let book = search_results[indexPath.row]
        let book_title = book["title"] as! String
        let book_asin = book["asin"] as! String
        var book_author="unknown"
        let fallback_image_url = URL(string: "https://adazing.com/wp-content/uploads/2019/02/closed-book-clipart-01-300x300.png")
        let image_url = (URL(string: book["image"] as! String) ?? fallback_image_url)!
        
        cell.bookImage.af_setImage(withURL: image_url)
        
        //cell.textLabel!.text = "row: \(indexPath.row)"
        //cell.textLabel!.text = book_title
        cell.bookTitleLabel.text = book_title
        //cell.bookAsin.text = book_asin
        
        return cell
    }
    
  
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var resultsTableView: UITableView!
    
    var searchterm = "crown+of+swords" // we have to change this var to change the search results
    var search_results = [[String:Any]]() // array of dictionaries to hold search results
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        searchBar.delegate = self

        loadBooks()
        print("search results view controller loaded.")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            DispatchQueue.main.async{
                LoadingOverlay.shared.hideOverlay()
            }
    }
    
    func loadBooks(){
        let url = URL(string: "https://api.rainforestapi.com/request?api_key=379913B5856E4E079E13E66CDD814EB9&type=search&amazon_domain=amazon.com&category_id=n:283155&search_term="+searchterm+"&sort_by=featured")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
              self.loadBooks()
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

              print(dataDictionary)
            
              self.search_results = dataDictionary["search_results"] as! [[String : Any]]
            
              self.resultsTableView.reloadData()

           }
        }
        task.resume()
        LoadingOverlay.shared.displayOverlay(backgroundView:self.view)
        self.resultsTableView.reloadData()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        if(searchBar.text != "") {
            var name = searchBar.text! as String
            name = name.replacingOccurrences(of: " ", with: "")
            self.searchterm = name
            print(name)
            loadBooks()
        }
    }
  

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let bookReviews = segue.destination as! ReviewsViewController
        let cell = sender as! UITableViewCell
        let indexPath = resultsTableView.indexPath(for: cell)!
        let result = search_results[indexPath.row]
        print(result)
        
        bookReviews.gtin = result["asin"] as! String
        bookReviews.useASIN = true
        
        resultsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}


