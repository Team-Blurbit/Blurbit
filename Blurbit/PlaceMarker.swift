//
//  PlaceMarker.swift
//  Blurbit
//
//  Created by user163612 on 4/21/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//

import CoreLocation
import GoogleMaps
import Parse
import UIKit

class PlaceMarker: GMSMarker {

    //create GooglePlace object
    let place_id:String

    //initialize marker to get the Google Maps type it usually gets
    init(place_id:String) {
        print("PlaceMarker.swift: init()")
        self.place_id=place_id
        super.init()
    }

}
