//
//  MapDetailsViewController.swift
//  Blurbit
//
//  Created by user163612 on 4/21/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//

import UIKit

class MapDetailsViewController: UIViewController {

    var detailsTask: URLSessionDataTask!
    var key: String = "AIzaSyAiPLeK9PFJzvGlAugRivosfuBjsk9ixSE"
    var name: String = ""
    var openNow: Int = 0
    var weekdayTexts = [String]()
    var placeId: String = ""

    override func viewDidLoad() {
        print("MapDetailsViewController.swift: viewDidLoad()")
        super.viewDidLoad()
        let urlString = "https://maps.googleapis.com/maps/api/place/details/json?key=\(key)&place_id=\(placeId)"
        print(urlString)
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
                            self.name = name as String
                            print(self.name)
                        }
                        if let openingHours = result["opening_hours"] as? [String: Any] {
                            if let openNow = openingHours["open_now"] as? Int {
                                self.openNow = openNow
                                print(self.openNow)
                            }
                            if let weekdayTexts = openingHours["weekday_text"] as? NSArray {
                                for index in 0 ..< weekdayTexts.count {
                                    if let weekdayText = weekdayTexts[index] as? String {
                                        self.weekdayTexts.append(weekdayText)
                                    }
                                }
                                print(self.weekdayTexts)
                            }
                        }
                    }
                }
            }
        }
        self.detailsTask.resume()
    }

}
