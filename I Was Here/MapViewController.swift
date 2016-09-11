//
//  ViewController.swift
//  test
//
//  Created by Ahmed Yakout on 8/6/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation



protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class MapViewController: UIViewController {
    
    // MARK: - Constants
    
    var locationManager: CLLocationManager! {
        didSet {
            locationManager.delegate = self
        }
    }
    
    var resultSearchController: UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    var PickedLocationDelegate: PickedLocation?
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self;
            mapView.mapType = .Hybrid;
            
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressMap(_:)))
            mapView.addGestureRecognizer(longGesture)
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        
        // important must add "UIBackgroundModes" in info plist and add "location" in the array or the app will crash
        locationManager.allowsBackgroundLocationUpdates = true
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //  kCLLocationAccuracyHundredMeters to conserve battery life.
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        // locationManager.startUpdatingLocation()
        locationManager.requestLocation()
        
        
        // Set up the UISearchController
        let locationSearchTable = storyboard!.instantiateViewControllerWithIdentifier("LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        // now we set up the search bar
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        
        // show helper message
        if userDefaults.showHelperMessageNo1 {
            
            let alert = UIAlertController(title: "Choose location", message: "You can select location by long press the location or search for it", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            alert.addAction(UIAlertAction(title: "Don't Show Again", style: UIAlertActionStyle.Default) {
                action in
                userDefaults.showHelperMessageNo1 = false
                })
            presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    
    // MARK: - helpers
    
    func didLongPressMap(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Began {
            let touchPoint = sender.locationInView(mapView)
            let touchCoordinate = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchCoordinate
            annotation.title = "Your position"
            // clear the map view before adding new annotaion to make sure that only one place will be considered when uploading the image
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotation(annotation) //drops the pin
            print("lat:  \(touchCoordinate.latitude)")
            let num = (touchCoordinate.latitude as NSNumber).floatValue
            let formatter = NSNumberFormatter()
            formatter.maximumFractionDigits = 4
            formatter.minimumFractionDigits = 4
            let str = formatter.stringFromNumber(num)
            print("long: \(touchCoordinate.longitude)")
            let num1 = (touchCoordinate.longitude as NSNumber).floatValue
            let formatter1 = NSNumberFormatter()
            formatter1.maximumFractionDigits = 4
            formatter1.minimumFractionDigits = 4
            let str1 = formatter1.stringFromNumber(num1)
            // adressLoLa.text = "\(num),\(num1)"
            print("\(num),\(num1)")
            
            
            // notify the photo editor here
            PickedLocationDelegate?.setPickedLocation(touchCoordinate.latitude, long: touchCoordinate.longitude)
            

        }
    }
}


extension MapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orangeColor()
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), forState: .Normal)
        button.addTarget(self, action: #selector(getDirections), forControlEvents: .TouchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
    
    
    // TODO: check
    func getDirections() {
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMapsWithLaunchOptions(launchOptions)
        }
    }
}


extension MapViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        if let location = locations.first {
            print("location: \(location)")
            
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: center, span: span)
            
            self.mapView.setRegion(region, animated: true)

        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error: \(error)")
    }
    
}


extension MapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        
        // cache the pin
        selectedPin = placemark
        
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        
        mapView.setRegion(region, animated: true)
        
        // now notify the photo editor
        PickedLocationDelegate?.setPickedLocation(annotation.coordinate.latitude, long: annotation.coordinate.longitude)

    }
}
