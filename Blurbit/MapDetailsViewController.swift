//
//  MapDetailsViewController.swift
//  Blurbit
//
//  Created by user163612 on 4/21/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//

import UIKit

class MapDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var weekdayTextTableView: UITableView!

    var detailsTask: URLSessionDataTask!
    var key: String = "AIzaSyAiPLeK9PFJzvGlAugRivosfuBjsk9ixSE"
    var weekdayTexts = [String]()
    var placeId: String = ""

    override func viewDidLoad() {
        print("MapDetailsViewController.swift: viewDidLoad()")
        super.viewDidLoad()
        self.weekdayTextTableView.dataSource = self
        self.weekdayTextTableView.delegate = self
        self.loadDetails()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("MapDetailsViewController.swift: tableView(cellForRowAt)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeekdayTextTableViewCell") as! WeekdayTextTableViewCell
        let weekdayText = weekdayTexts[indexPath.row]
        cell.weekdayText.text = weekdayText as? String
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("MapDetailsViewController.swift: tableView(numberOfRowsInSection)")
        return self.weekdayTexts.count
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
                                        self.weekdayTexts.append(weekdayText)
                                    }
                                }
                                DispatchQueue.main.async {
                                    self.weekdayTextTableView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
        self.detailsTask.resume()
    }

}
