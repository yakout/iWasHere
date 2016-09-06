//
//  ViewController.swift
//  test
//
//  Created by Ahmed Yakout on 8/6/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    // our model
    var memories: [Memory]? {
        didSet {
            if let _ = memories {
                clearAnnotations()
                addAnnotaion()
            }
        }
    }
    
    // MARK: - Constants
    
    private struct Constants {
        static let LeftCalloutFrame = CGRect(x: 0, y: 0, width: 59, height: 59)
        static let AnnotationViewReuseIdentifier = "waypoint"
        static let ShowImageSegue = "show image"
        
    }
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self;
            mapView.mapType = .Standard;
        }
    }
    
    
    // MARK: - Helpers
    func addAnnotaion() {
        var annotations = [MKAnnotation]()
        for memory in memories! {
            if let annotation = memory.annotation {
                mapView?.addAnnotation(annotation);
                annotations.append(annotation)
            }
        }
        mapView?.showAnnotations(annotations, animated: true);
    }
    
    func clearAnnotations() {
        mapView?.removeAnnotations(mapView.annotations);
    }
    
    
    // MARK: - MapView delegate methods
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKAnnotationView! = mapView.dequeueReusableAnnotationViewWithIdentifier(Constants.AnnotationViewReuseIdentifier)
        
        // VERY IMPORTANT: because there is no prototype like table view we should check if we have used annotation or otherwise will create a new one
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.AnnotationViewReuseIdentifier)
            view.canShowCallout = true
        } else {
            view.annotation = annotation
        }
        
        view.leftCalloutAccessoryView = nil // cuz we only gonna show this button only if this view has a thumbnail image so first thing is to clear it out
        
        if let waypoint = annotation as? Memory {
            if waypoint.thumbnailUrl != nil {
                view.leftCalloutAccessoryView = UIButton(frame: Constants.LeftCalloutFrame)
            }
        }
        
        return view
    }
    
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if  let thumbnailImageButton = view.leftCalloutAccessoryView as? UIButton,
            let url = NSURL(string: ((view.annotation as? Memory)?.thumbnailUrl)!),
            let imageData = NSData(contentsOfURL: url),
            let image = UIImage(data: imageData) {
            thumbnailImageButton.setImage(image, forState: .Normal)
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let annotation = Annotation(title: "iYakout House", subtitle: "Test Test", longitude: 30.063824, latitude: 31.312353)
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
    }
}


