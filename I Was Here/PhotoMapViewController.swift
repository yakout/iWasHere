//
//  PhotoMapViewController.swift
//  iWasHere
//
//  Created by Khalil Mohammed Yakout on 9/11/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class PhotoMapViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  31.3124,30.0638
        // test
        let coordinate = CLLocationCoordinate2D(latitude: 31.3124, longitude: 30.0638)
        let annotaion1 = PhotoMapAnnotation(title: "title", coordinate: coordinate, subtitle: "subtilte", folderName: nil)
        mapView.addAnnotation(annotaion1)
        mapView.showAnnotations([annotaion1], animated: true)
        
        let annotations = getAnnotations()
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: true)
    }
    
    
    // MARK: Helpers
    
    func getAnnotations() -> [PhotoMapAnnotation] {
        var annotations:[PhotoMapAnnotation] = []
        let places = User.currentUser.places!
        
        for place in places {
            let memories = place.memories!
            for memory in memories {
                let lat = memory.latitude!
                let lng = memory.longitude!
                let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                let annotation = PhotoMapAnnotation(title: memory.name, coordinate: coordinates, subtitle: memory.description, folderName: place.name)
                annotations.append(annotation)
            }
        }
        
        return annotations
    }
    
    func fetchImageForImageNameAndFolderName(imageName: String?, folderName: String?) -> UIImage? {
        
        if let cachedImage = imageCache.objectForKey(imageName!) as? UIImage {
            return cachedImage
        }
        
        var fetchedImage: UIImage?
        Alamofire.request(.GET, "\(url)/image", parameters:[
            "id":User.currentUser.uid ?? "",
            "token": User.currentUser.token ?? "",
            "folderName": folderName ?? "",
            "imageName": imageName ?? "",
            ])
            .responseJSON { response in
                let base64 = String(data:(response.data)!, encoding: NSUTF8StringEncoding)!
                dispatch_async(dispatch_get_main_queue()) {
                    if let data = NSData(base64EncodedString: base64, options: []) {
                        if let image = UIImage(data: data) {
                            fetchedImage = image
                            imageCache.setObject(image, forKey: imageName!)
                        }
                    }
                }
        }
        
        return fetchedImage
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PhotoMapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let annotationIdentifier = "annotationIdentifier"
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        } else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            annotationView = av
        }
        
        if let annotationView = annotationView {
            annotationView.canShowCallout = true
            let photoMapAnnotation = annotation as? PhotoMapAnnotation
            let fetchedImage = fetchImageForImageNameAndFolderName(photoMapAnnotation?.title, folderName: photoMapAnnotation?.folderName)
            annotationView.image = fetchedImage
            annotationView.frame.size.width = 60.0
            annotationView.frame.size.height = 60.0
        }
        
        return annotationView
    }
    
}
