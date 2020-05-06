//
//  MapDetailsViewController.swift
//  Blurbit
//
//  Created by user163612 on 4/21/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//

import UIKit
import AlamofireImage
import GooglePlaces
import GoogleMaps

class MapDetailsViewController: UIViewController {

    @IBOutlet weak var bookstoreView: UIImageView!
    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var hoursOpLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var detailsTask: URLSessionDataTask!
    var key: String = "AIzaSyAiPLeK9PFJzvGlAugRivosfuBjsk9ixSE"
    var weekdayTexts = [String]()
    var weekdayTextString = ""
    var placeId: String = ""
    var imageUrl=""
    var phone=""
    var location=""

    override func viewDidLoad() {
        print("MapDetailsViewController.swift: viewDidLoad()")
        super.viewDidLoad()
        self.loadDetails()
    }

    func loadDetails() {
        print("MapDetailsViewController.swift: loadDetails()")
        let urlString = "https://maps.googleapis.com/maps/api/place/details/json?key=\(key)&place_id=\(placeId)"
        let urlVar = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request=URLRequest(url: urlVar, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 50)
        request.httpMethod = "GET"
        self.detailsTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("MapDetailsViewController.swift: \(error.localizedDescription)")
            }
            // unpack data
            if let data = data {
                if let json = try! JSONSerialization.jsonObject(with: data,options:[]) as? [String:Any]{
                    if let result = json["result"] as? [String:Any] {
                        if let name = result["name"] as? NSString {
                            DispatchQueue.main.async {
                                self.name.text = name as String
                            }
                        }
                        if let openingHours = result["opening_hours"] as? [String: Any] {
                            if let openNow = openingHours["open_now"] as? Int {
                                if (openNow == 1) {
                                    DispatchQueue.main.async {
                                        self.hours.text = "Open"
                                    }
                                }
                            }
                            if let weekdayTexts = openingHours["weekday_text"] as? NSArray {
                                for index in 0 ..< weekdayTexts.count {
                                    if let weekdayText = weekdayTexts[index] as? String {
                                            self.weekdayTextString.append(weekdayText+"\n")
                                    }
                                }
                                DispatchQueue.main.async{
                                    self.hoursOpLabel.text=self.weekdayTextString
                                }
                            }
                        }
                        if let website = result["website"] as? String{
                            DispatchQueue.main.async{
                                self.websiteLabel.text=website
                            }
                        }
                        if let phoneText = result["formatted_phone_number"] as? String{
                            DispatchQueue.main.async{                            self.phoneLabel.text=phoneText
                            }
                        }
                        if let locationText = result["formatted_address"] as? String{
                            DispatchQueue.main.async{                            self.locationLabel.text=locationText
                            }
                        }
                        /*if let photos=result["photos"] as? [[String:Any]]{
                            if let photo=photos[0]["photo_reference"] as? String{
                                let imgUrlString="https://maps.googleapis.com/maps/api/place?maxwidth=200&key=\(self.key)&photoreference=\(photo)"
                                    print(imgUrlString)
                                    if let imgUrl=URL(string: imgUrlString){
                                        let urlRequest=URLRequest(url:imgUrl)
                                        let dataTask=URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                                            if let data = data{
                                                print(response)
                                                if let image=UIImage(data:data){
                                                DispatchQueue.main.async{
                                                    self.bookstoreView.image=image
                                                    print("image set")
                                                }
                                                }
                                            }
                                        }
                                        dataTask.resume()
                    
                                    }
                            }
                        }*/
                        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.photos.rawValue))!
                        let placesClient=GMSPlacesClient()
                        placesClient.fetchPlace(fromPlaceID: self.placeId,
                                                 placeFields: fields,
                                                 sessionToken: nil, callback: {
                          (place: GMSPlace?, error: Error?) in
                          if let error = error {
                            print("An error occurred: \(error.localizedDescription)")
                            return
                          }
                          if let place = place {
                            let photoMetadata: GMSPlacePhotoMetadata = place.photos![0]

                            placesClient.loadPlacePhoto(photoMetadata, callback: { (photo, error) -> Void in
                              if let error = error {
                                print("Error loading photo metadata: \(error.localizedDescription)")
                                return
                              } else {
                                self.bookstoreView?.image = photo;
                              }
                            })
                          }
                        })                    }
                }
            }
        }
        self.detailsTask.resume()
    }

}
