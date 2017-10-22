//
//  ViewController.swift
//  iosMidterm
//
//  Created by Naman Sharma on 2017-10-20.
//  Copyright © 2017 Naman Sharma. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var yourLocation: UITextField!
    @IBOutlet weak var yourDestination: UITextField!
    @IBOutlet weak var methodOfTransportation: UISegmentedControl!
    @IBOutlet weak var routeRestrictions: UISegmentedControl!
    @IBOutlet weak var distance: UITextField!
    @IBOutlet weak var Duration: UITextField!
    @IBOutlet weak var duration_regular: UITextField!
    @IBOutlet weak var fare: UITextField!
    
    //initialize location
    let locationManager = CLLocationManager()
    var lat = "", long = "", originLocation = "", destinationLocation = "",
    mode = "", avoid = ""
    let locationDestination = "BCIT"
	

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    // Print out the location to the console
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let myLocation: CLLocationCoordinate2D = manager.location!.coordinate
        lat = String(myLocation.latitude)
        long = String(myLocation.longitude)
        originLocation = lat + "," + long
        //self.yourLocation.text = originLocation;
        destinationLocation = yourDestination.text!;
        originLocation = yourLocation.text!;
        if methodOfTransportation.selectedSegmentIndex == 0{ mode = "driving";}
        if methodOfTransportation.selectedSegmentIndex == 1{ mode = "walking";}
        if methodOfTransportation.selectedSegmentIndex == 2{ mode = "bicycling";}
        if methodOfTransportation.selectedSegmentIndex == 3{ mode = "transit";}
        if routeRestrictions.selectedSegmentIndex == 0{avoid = "tolls";}
        if routeRestrictions.selectedSegmentIndex == 1{avoid = "highways";}
        if routeRestrictions.selectedSegmentIndex == 2{avoid = "ferries";}
        if routeRestrictions.selectedSegmentIndex == 3{avoid = "indoors";}
        let googleURL = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(originLocation)&destinations=\(destinationLocation)&departure_time=now&mode=\(mode)&avoid=\(avoid)&key=AIzaSyC5H-sEVe-QW87odkKvAshiCTmncUNPT9E"
        let url = URL(string: googleURL);
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let data = data {
                do {
                    // Convert the data to JSON
                    let json = JSON(data: data)
                    if let rowsArray = json["rows"].array{
                        for element in rowsArray{
                            let duration_in_traffic: String! = element["elements"][0]["duration_in_traffic"]["text"].string;
                            let duration: String! = element["elements"][0]["duration"]["text"].string;
                            let yourDistance: String! = element["elements"][0]["distance"]["text"].string;
                            self.distance.text = yourDistance;
                            self.Duration.text = duration_in_traffic;
                            self.duration_regular.text = duration;
                            
                        }
                    }
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

