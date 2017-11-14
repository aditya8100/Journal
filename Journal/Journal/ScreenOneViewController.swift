//
//  ScreenOneViewController.swift
//  Journal
//
//  Created by Aditya Deepak on 10/16/17.
//  Copyright © 2017 Aditya Deepak. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class ScreenOneViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var descriptionLabel: UILabel!
    var didChangeLocation: Bool = true
    var currentLocation: CLLocation!
    var location = CLLocationManager();
    var timer: Timer!
    
    @IBAction func onPressSignout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "backToLogin", sender: self)
        } catch let signOutError as NSError {
            print("Error!")
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        location.delegate = self
        requestLocationPermission()
        
        guard let current = location.location else {
            return
        }
        
        currentLocation = current
        
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: (#selector(ScreenOneViewController.addPlace)), userInfo: nil, repeats: didChangeLocation)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let userLoc = userLocation.location, currentLocation != nil else {
            return
        }
        
        let region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000, 2000)
        
        mapView.setRegion(region, animated: true)
        
        if currentLocation.distance(from: userLoc) > 800 || currentLocation.distance(from: userLoc) == 0 {
            currentLocation = userLoc
            didChangeLocation = true
            timer.fire()
        } else {
            didChangeLocation = false
        }
    }
    
    func requestLocationPermission() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            mapView.userTrackingMode = .follow
            mapView.showsUserLocation = true
        } else {
            location.requestAlwaysAuthorization()
            location.startUpdatingLocation()
            location.desiredAccuracy = kCLLocationAccuracyBest
            mapView.userTrackingMode = .follow
            mapView.showsUserLocation = true
        }
    }
    
    @objc func addPlace() {
        if didChangeLocation {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(currentLocation) { (placemarkData, error) in
                if error != nil {
                    return
                }
                guard let placemarks = placemarkData else {
                    return
                }
                
                let placeDetails = placemarks[0]
                var name: String!
                if let placeName = placeDetails.name {
                    name = placeName
                } else if let thoroughFare = placeDetails.thoroughfare {
                    name = thoroughFare
                } else if let subLocality = placeDetails.subLocality {
                    name = subLocality
                } else {
                    name = "Unknown Location"
                }
                
                let placeData: [String:Any] = ["location": ["lat":self.currentLocation.coordinate.latitude, "long": self.currentLocation.coordinate.longitude], "name": name]
                
                DataService.instance.addPlace(placeData: placeData)
                print("Worked!")
            }
        }
        
        didChangeLocation = false
    }
}
