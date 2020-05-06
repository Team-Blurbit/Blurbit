//
//  RatingViewController.swift
//  Blurbit
//
//  Created by user163612 on 4/28/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class RatingViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate {
    
    var isbn=""
    var bookId=""
    var imageUrl=""
    var reviTitle="review"
    var placeholder="Write a review..."
    var reviewExists=false
    var rowSelected=5
    
    @IBOutlet weak var comment: UITextView!
    
    @IBOutlet weak var reviewtitle: UITextField!
    
    @IBOutlet weak var bookCover: UIImageView!
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.rowSelected=row
        return self.pickerData[row]
    }
    
    @IBOutlet weak var pickerView: UIPickerView!
    var pickerData:Array<String> = ["Awesome read!","Good read","Okay to pass time","Not worth reading","Waste of money"]
    var pickerRatings:Array<Int> = [5,4,3,2,1]
    var reverseRatings:Array<Int> = [1,2,3,4,5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.comment.layer.borderWidth=1
        self.comment.layer.borderColor=UIColor.lightGray.cgColor
        self.comment.delegate = self
        self.comment.textColor = UIColor.lightGray
        self.comment.text = placeholder
        if let url=URL(string:imageUrl){
            bookCover.af_setImage(withURL: url)
        }
        // Do any additional setup after loading the view.
        self.pickerView.delegate=self
        self.pickerView.dataSource=self
        print(self.isbn)
        self.loadReview()
    }
    
    func loadReview(){
        print("loading review")
        var query=PFQuery(className:"Review")
        query=query.whereKey("bookId", equalTo: self.bookId)
        query=query.whereKey("userId",equalTo:PFUser.current()!)
        query.findObjectsInBackground { (data, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else{
                print("data")
                print(data != nil && data!.count > 0)
            }
            if data != nil&&data!.count != 0{
                print("else")
                if let review=data![0] as? PFObject{
                    print(review)
                    self.reviewtitle.text=review["title"] as! String
                    self.comment.text=review["comment"] as! String
                    var rating=review["rating"] as! Int
                    rating=rating-1
                    print(rating)
                    rating=self.pickerRatings[rating]-1
                    print(rating)
                    self.pickerView.selectRow(rating, inComponent: 0, animated: true)
                }
            }
        }
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func submitRating(_ sender: Any) {
        //create review
        print("boodId")
        print(self.bookId)
        print("isbn")
        print(self.isbn)
        var query=PFQuery(className:"Review")
        query=query.whereKey("bookId", equalTo: self.bookId)
        query=query.whereKey("userId",equalTo:PFUser.current()!)
        query.findObjectsInBackground { (data, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else{
                print("data")
                print(data != nil && data!.count > 0)
            }
            if (data != nil && data!.count == 0) || (data == nil) {
                let review = PFObject(className: "Review")
                review["userId"]=PFUser.current()!
                review["comment"] = self.comment.text
                review["bookId"] = self.bookId
                review["title"] = self.reviewtitle.text!
                review["rating"]=self.pickerRatings[self.rowSelected]
                review.saveInBackground { (success, error) in
                if (success) {
                    print("ReviewsViewController.swift: search record saved")
                    //find search and add review to it
                    var query=PFQuery(className:"Search")
                    query=query.whereKey("isbn", equalTo: self.isbn)
                    query.findObjectsInBackground { (data, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        else if data != nil{
                            data![0]["reviewId"]=review.objectId
                        }
                    //dismiss modal view
                        print("really?")
                    self.dismiss(animated: true, completion: nil)
                    }
                }
                
                else {
                    let message = error?.localizedDescription ?? "error creating search record"
                    print("ReviewsViewController.swift: \(message)")
                    self.dismiss(animated: true, completion: nil)
                    
                }
                
            }
        }
        else if data != nil {
            if let dataId=data![0].objectId{
                print("updating")
                print(dataId)
                query.getObjectInBackground(withId: dataId) { (review, error) in
                    if let review = review{
                        print("found to update")
                        review["comment"] = self.comment.text
                        review["title"] = self.reviewtitle.text!
                        review["rating"]=self.pickerRatings[self.rowSelected]
                        review.saveInBackground { (success, error) in
                            if success{
                                print("data saved")
                            }
                            else{
                                print("error saving data")
                            }
                        }
                    }
                }
            }
        }
    }
    self.dismiss(animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write a review..."
            textView.textColor = UIColor.lightGray
            placeholder = ""
        }
        else {
            placeholder = textView.text
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        placeholder = textView.text
    }
}

