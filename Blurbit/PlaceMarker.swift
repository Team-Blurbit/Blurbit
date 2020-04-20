//
//  PlaceMarker.swift
//  Blurbit
//
//  Created by user163612 on 4/19/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class PlaceMarker: GMSMarker {
  //create GooglePlace object
  let place: GooglePlace
  //initialize marker to get the Google Maps type it usually gets
  init(place: GooglePlace) {
    self.place = place
    super.init()
    position = place.coordinate
    groundAnchor = CGPoint(x: 0.5, y: 1)
    appearAnimation = .pop
    var searchType = "book_store"
    let availableTypes = ["book_store"]
    for type in place.types {
      if availableTypes.contains(type) {
        searchType = type
        break
      }
    }
    icon = UIImage(named: searchType+"_pin")
  }
}
