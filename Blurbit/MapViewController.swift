//
//  MapViewController.swift
//  Blurbit
//
//  Created by Marco Aguilera on 4/15/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//
// Google Maps API Key: AIzaSyDMQMYI8Vcpzfb3AyceMSRO3tPlWLQ8LyU
import UIKit
import Parse
import GoogleMaps
import GooglePlaces
import CoreLocation

//add to AppDelegate.swift: GMSServices.provideAPIKey(googleApiKey)
let googleApiKey = "AIzaSyAiPLeK9PFJzvGlAugRivosfuBjsk9ixSE"
//Query: https://maps.googleapis.com/maps/api/place/textsearch/json?types=book_store&location=41.3850639%2C2.1734035&radius=10000&key=AIzaSyAiPLeK9PFJzvGlAugRivosfuBjsk9ixSE
class MapViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate,GMSMapViewDelegate{
    let manager :CLLocationManager
    var userMarker :GMSMarker
    var camera :GMSCameraPosition
    //var mapView :GMSMapView
    var viewSet :Bool
    var placesTask: URLSessionDataTask!
    @IBOutlet var googleMapView: GMSMapView!
    @IBOutlet var searchBar: UISearchBar!
    
    required init?(coder aDcoder: NSCoder) {
        GMSServices.provideAPIKey("AIzaSyDMQMYI8Vcpzfb3AyceMSRO3tPlWLQ8LyU")
        GMSPlacesClient.provideAPIKey("AIzaSyAiPLeK9PFJzvGlAugRivosfuBjsk9ixSE")
        self.manager = CLLocationManager()
        self.userMarker = GMSMarker()
        self.camera = GMSCameraPosition()
        self.viewSet = false
        super.init(coder: aDcoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    
        userMarker.title = "Your Location"
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    
        // Do any additional setup after loading the view.
        print("here")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Hello187")
        searchBar.endEditing(true)
        let aController = GMSAutocompleteViewController()
        aController.delegate = self
        present(aController, animated: true, completion: nil )
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        setUserLocation(position: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), callFromAuto: false)
    }
    
    func setUserLocation(position: CLLocationCoordinate2D, callFromAuto: Bool) {
        
        
        if(viewSet == false || callFromAuto == true) {
            userMarker.position = position
            camera = GMSCameraPosition(latitude: position.latitude, longitude: position.longitude, zoom: 15)
            googleMapView.camera = camera
            userMarker.map = googleMapView
            googleMapView.delegate=self
            //get nearby bookstores
            getBookstores(near: position)
            
            viewSet = true
        }
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool
    {
        
        if let placeMarker = marker as? PlaceMarker{
            //go to details view controller
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "MapDetailsViewController") as? MapDetailsViewController
            secondVC?.place_id=placeMarker.place_id
            self.navigationController?.pushViewController(secondVC!, animated: true)
        }
        return true
    }
    
    func getBookstores(near coordinate: CLLocationCoordinate2D){
        //mapView.clear()
        //call to Google API
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=\(googleApiKey)&location=\(coordinate.latitude),\(coordinate.longitude)&radius=500000&types=book_store"
        //urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let urlVar=URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request=URLRequest(url: urlVar, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 50)
        request.httpMethod="GET"
        //cancel task if nothing is returned
        /*if placesTask!.taskIdentifier > 0 && placesTask!.state == .running {
            placesTask!.cancel()
        }*/
        self.placesTask = URLSession.shared.dataTask(with: request ) { data, response, error in
            if let error=error{
                print(error.localizedDescription)
            }
            if let data=data{
            //UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if let json = try! JSONSerialization.jsonObject(with: data,options:[]) as? [String:Any]{
                    if let results = json["results"] as? [[String:Any]] {
                      //if results != nil {
                        for index in 0..<results.count {
                            if let resultPlace = results[index] as? NSDictionary {

                                    //create empty vars in case nothing is found
                                    var storeName = ""
                                    var latitude = 0.0
                                    var longitude = 0.0

                                    //check if place is found and assing
                                    if let name = resultPlace["name"] as? NSString {
                                        storeName = name as String
                                    }
                                    if let geometry = resultPlace["geometry"] as? NSDictionary {
                                        if let location = geometry["location"] as? NSDictionary {
                                            if let lat = location["lat"] as? Double {
                                                latitude = lat
                                            }
                                            if let long = location["lng"] as? Double {
                                                longitude = long
                                            }
                                        }
                                    }
                                    let place_id=resultPlace["place_id"]  as! String
                                DispatchQueue.main.async{
                                    let marker = PlaceMarker(place_id:place_id)
                                    marker.position = CLLocationCoordinate2DMake(latitude, longitude)
                                    
                                    marker.title = storeName
                                    marker.icon=GMSMarker.markerImage(with: UIColor.systemIndigo)
                                    marker.map = self.googleMapView
                                }
                                    //print(marker)
                                }
                            }
                        //}
                    }
                }
            }
            
        }
        print("here3")
        self.placesTask.resume()
        //do this for each place
        //let marker = PlaceMarker(place: place)
        //marker.map = self.mapView
    }

    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        let main=UIStoryboard(name: "Main", bundle: nil)
        let loginViewController=main.instantiateViewController(withIdentifier: "LoginViewController")
        let delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        delegate.window?.rootViewController=loginViewController
        
    }
        
}

extension MapViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        searchBar.text = place.name
        setUserLocation(position: place.coordinate, callFromAuto: true)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}


