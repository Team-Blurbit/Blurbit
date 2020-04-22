//
//  PlaceMarker.swift
//  Blurbit
//
//  Created by user163612 on 4/21/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Parse

class PlaceMarker: GMSMarker {
  //create GooglePlace object
    let place_id:String
  //initialize marker to get the Google Maps type it usually gets
    init(place_id:String) {
        self.place_id=place_id
        super.init()
        
    }
}
