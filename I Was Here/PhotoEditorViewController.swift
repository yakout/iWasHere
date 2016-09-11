//
//  PhotoEditorViewController.swift
//  iWasHere
//
//  Created by Khalil Mohammed Yakout on 9/9/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation


protocol PickedLocation {
    func setPickedLocation(lat: Double, long: Double)
}

class PhotoEditorViewController: UIViewController {
    
    struct Const {
        static let containerSegueIdentifier = "map"
    }
    
    let locationManager = CLLocationManager()
    var pickedImage: UIImage?
    
    var latitude: Double?
    var longitude: Double?
    var folderName: String?
    
    
    // MARK: outlets
    
    @IBOutlet weak var imageDescription: UITextField!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.image = pickedImage
        }
    }
    @IBOutlet weak var spinner: UIActivityIndicatorView! {
        didSet {
            spinner.hidesWhenStopped = true
            spinner.hidden = true
        }
    }
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Choose Location"
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(cancel))
        
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Const.containerSegueIdentifier {
            if let dest = segue.destinationViewController as? UINavigationController {
                (dest.viewControllers[0] as? MapViewController)?.PickedLocationDelegate = self
            }
        }
    }
    
    
    // MARK: helpers
    
    func done() {
        spinner.hidden = false
        spinner.startAnimating()
        self.view.alpha = 0.5
        uploadPicture(pickedImage!)
    }
    
    func cancel() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func uploadPicture(pickedImage: UIImage) {
        // note there is uploading method in alamofire check it late
        
        // to know the image size
        let imgData: NSData = NSData(data: UIImageJPEGRepresentation((pickedImage), 1)!)
        // var imgData: NSData = UIImagePNGRepresentation(image)
        // you can also replace UIImageJPEGRepresentation with UIImagePNGRepresentation.
        let imageSize = imgData.length
        print("size of image in KB: ", Double(imageSize)/1024.0)
        
        
        if let imageData = UIImageJPEGRepresentation(pickedImage, 0.3) {
            let imageDataSize = imageData.length
            print("size of image in KB after compression: ", Double(imageDataSize)/1024.0)
            
            
            let strBase64:String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            let description = imageDescription.text
            
            
            configuration.timeoutIntervalForRequest = 600
            configuration.timeoutIntervalForResource = 600
            alamoFireManager = Alamofire.Manager(configuration: configuration)
            
            guard let lat = latitude, let long = longitude else {
                // TODO: show alert to the user to select a location or select the current location of the user if not found or the user has disabled the location services uploading should fail
                
                return
            }
            
            print(User.currentUser.token!)
            print(User.currentUser.uid!)
            Alamofire.request(.POST, "\(url)/image", parameters:[
                "id":User.currentUser.uid!,
                "token": User.currentUser.token!,
                "folderName":folderName ?? "",
                "latitude":lat,
                "longitude":long,
                "imageName": NSUUID().UUIDString,
                "imageDescription": description ?? "no description",
                "extension":"jpg",
                "data": strBase64
                ], encoding: .JSON)
                .responseJSON { [weak self] response in
                    debugPrint(response)
                    
                    self?.spinner.stopAnimating()
                    self?.view.alpha = 1
                    
                    let message = String(data: response.data!, encoding: NSUTF8StringEncoding)
                    let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { action in
                        self?.cancel()
                        // return // you must add explicit return here, the reason is that a single statement in any closure is handled by it's return value in popViewControllerAnimated case the compiler is using it's return type! so adding explicit return avoids this
                        })
                    self?.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
}

extension PhotoEditorViewController: PickedLocation {
    func setPickedLocation(lat: Double, long: Double) {
        self.latitude = lat
        self.longitude = long
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: long)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { [weak self] (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Address dictionary
            print(placeMark.addressDictionary)
            
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? String {
                print("location name: \(locationName)")
            }
            
            // Street address
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? String {
                print("street: \(street)")
            }
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? String , let country = placeMark.addressDictionary!["Country"] as? String{
                print("city: \(city)")
                print("country: \(country)")
                
                self?.folderName = "\(city),\(country)"
            }
            
            // Zip code
            if let zip = placeMark.addressDictionary!["ZIP"] as? String {
                print("zip: \(zip)")
            }
            
            })
    }
}

