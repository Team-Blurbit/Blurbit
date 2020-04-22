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
    var placeId: String = ""

    override func viewDidLoad() {
        print("MapDetailsViewController.swift: viewDidLoad()")
        super.viewDidLoad()
        let urlString = "https://maps.googleapis.com/maps/api/place/details/json?key=\(key)&place_id=\(placeId)"
        let urlVar = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request=URLRequest(url: urlVar, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 50)
        request.httpMethod = "GET"
        self.detailsTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("MapDetailsViewController.swift: \(error.localizedDescription)")
            }
            if let data = data {
                if let json = try! JSONSerialization.jsonObject(with: data,options:[]) as? [String:Any]{
                    if let result = json["result"] as? [String:Any] {
                        if let name = result["name"] as? NSString {
                            let storeName = name as String
                            print(storeName)
                        }
                    }
                }
            }
        }
        self.detailsTask.resume()
    }

}
