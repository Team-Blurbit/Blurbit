//
//  RatingViewController.swift
//  Blurbit
//
//  Created by user163612 on 4/28/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//

import UIKit
import Parse

class RatingViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var isbn=""
    var bookId=""
    var rowSelected=0
    
    @IBOutlet weak var comment: UITextView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.rowSelected=row
        return pickerData[row]
    }
    
    @IBOutlet weak var pickerView: UIPickerView!
    var pickerData:Array<String> = ["Awesome read!","Good read","Okay to pass time","Not worth reading","Waste of money"]
    var pickerRatings:Array<Int> = [5,4,3,2,1]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickerView.delegate=self
        pickerView.dataSource=self
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
        let review = PFObject(className: "Review")
        review["userId"]=PFUser.current()!
        review["comment"] = comment.text
        review["bookId"] = self.bookId
        review["rating"]=pickerRatings[rowSelected]
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
                self.dismiss(animated: true, completion: nil)           }
            
        }
        
    self.dismiss(animated: true, completion: nil)    }
    
}
