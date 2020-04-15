//
//  MapViewController.swift
//  Blurbit
//
//  Created by Marco Aguilera on 4/15/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//

// Google Maps API Key: AIzaSyDMQMYI8Vcpzfb3AyceMSRO3tPlWLQ8LyU
import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    let manager :CLLocationManager
    var userMarker :GMSMarker
    var camera :GMSCameraPosition
    var mapView :GMSMapView
    var viewSet :Bool
    
    required init?(coder aDcoder: NSCoder) {
        GMSServices.provideAPIKey("AIzaSyDMQMYI8Vcpzfb3AyceMSRO3tPlWLQ8LyU")
        self.manager = CLLocationManager()
        self.userMarker = GMSMarker()
        self.camera = GMSCameraPosition()
        self.mapView = GMSMapView()
        self.viewSet = false
        
        super.init(coder: aDcoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        userMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
        userMarker.title = "Your Location"
        
        
        if(viewSet == false) {
            camera = GMSCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15)
            mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            userMarker.map = mapView
            view = mapView
            viewSet = true
            
        }
        
    }
    
    // Runs everytime the user moves to a new location
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
