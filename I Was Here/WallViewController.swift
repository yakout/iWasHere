//
//  WallViewController.swift
//  iWasHere
//
//  Created by Ahmed Yakout on 9/3/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import UIKit
import Alamofire
import AssetsLibrary
import CoreLocation
import MapKit


class WallViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    typealias completionHandler = (Double, Double, Double, Double) -> Void
    
    struct Const {
        static let logoutSegueIdentifier = "logout"
        static let GridView = "GridCellIdentifer"
        static let folderSegue = "openFolderSegue"
        static let showPhotoEditor = "showPhotoEditor"
    }
    
    // MARK: Properties
    
    var places = [Place]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var isList: Bool = true
    var refreshControl: UIRefreshControl!
    var locationManager: CLLocationManager! {
        didSet {
            locationManager.delegate = self
        }
    }
    var currentLocationLat: Double?
    var currentLocationLng: Double?
    var notificationsDidSet = false
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - Actions
    
    @IBAction func logout(sender: AnyObject) {
        performSegueWithIdentifier(Const.logoutSegueIdentifier, sender: nil)
    }
    
    
    @IBAction func addButtonDidTouch(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true // if you set this for true you need to access the editted photo using UIImagePickerControllerEditedImage
        
        let options = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        options.addAction(UIAlertAction(title: "Photo Album", style: .Default) { [weak self] (action: UIAlertAction) in
            imagePicker.sourceType = .PhotoLibrary
            self?.presentViewController(imagePicker, animated: true, completion: nil)
            })
        
        options.addAction(UIAlertAction(title: "Camera", style: .Default) { [weak self] (action) in
            imagePicker.sourceType = .Camera
            self?.presentViewController(imagePicker, animated: true, completion: nil)
            })
        
        options.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // you dont need to dismiss the view controller
            })
        
        presentViewController(options, animated: true, completion: nil)
    }
    
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var pickedImage: UIImage?
        let library = ALAssetsLibrary()
        let url: NSURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        
        
        if let pickedEditedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            pickedImage = pickedEditedImage
        } else if let pickedOriginalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pickedImage = pickedOriginalImage
        }
        
        // code to extract location from photo it will only work for photo taken by iphone or the camera app ..
        library.assetForURL(url, resultBlock: {
            (asset: ALAsset!) in
            if asset.valueForProperty(ALAssetPropertyLocation) != nil {
                let lat = (asset.valueForProperty(ALAssetPropertyLocation) as? CLLocation)!.coordinate.latitude
                let lang = (asset.valueForProperty(ALAssetPropertyLocation) as? CLLocation)!.coordinate.longitude
                print(lat, lang)
            }
            }, failureBlock: {
                (error: NSError!) in
                NSLog("Error!")
        })
        
        dismissViewControllerAnimated(true, completion: nil)
        performSegueWithIdentifier(Const.showPhotoEditor, sender: pickedImage)
        // upload function has moved from here
    }
    
    
    // MARK: - life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), forControlEvents: UIControlEvents.ValueChanged)
        collectionView.addSubview(refreshControl)
        
        places = User.currentUser.places ?? []
        
        
        locationManager = CLLocationManager()
        
        // important must add "UIBackgroundModes" in info plist and add "location" in the array or the app will crash
        locationManager.allowsBackgroundLocationUpdates = true
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //  kCLLocationAccuracyHundredMeters to conserve battery life.
        
        locationManager.requestAlwaysAuthorization()
        // locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        // locationManager.requestLocation()
        
        
        
//        // T E S T             //        31.3124,30.0638
//
//        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude:
//            31.3124, longitude: 30.0638), radius: 30.0 * 100.0, identifier: "test")
//        region.notifyOnExit = false
//        let locattionnotification = UILocalNotification()
//        locattionnotification.alertBody = "You are near the past!"
//        locattionnotification.regionTriggersOnce = false
//        locattionnotification.region = region
//        UIApplication.sharedApplication().scheduleLocalNotification(locattionnotification)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // grid/list switching
        
        if User.currentUser.isList != isList {
            collectionView.reloadData()
            isList = User.currentUser.isList
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout methods very important !!
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 4;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1;
    }
    
    
    
    // MARK: - UICollectionViewDatasource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Const.GridView, forIndexPath: indexPath) as? PlaceCollectionViewCell
        
        // set value for button to know which buton for which cell has been pressed and should be deleted
        cell?.delete.layer.setValue(indexPath.row, forKey: "index")
        cell?.delete.addTarget(self, action: #selector(deletePlace(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        let folder = places[indexPath.row]
        let folderName = folder.name
        let firstImageInFolder = folder.memories?[0].name ?? ""
        
        cell?.spinner.hidesWhenStopped = true
        cell?.spinner.startAnimating()
        cell?.placeName.text = folderName
        
        cell?.layer.cornerRadius = 10.0
        cell?.layer.borderColor = UIColor.grayColor().CGColor
        cell?.layer.borderWidth = 2
        
        
        if let cachedImage = imageCache.objectForKey(firstImageInFolder) as? UIImage {
            cell?.placeImage.image = cachedImage
            cell?.placeName.text = folderName
            cell?.spinner.stopAnimating()
            return cell!
        }
        
        configuration.timeoutIntervalForRequest = 600
        configuration.timeoutIntervalForResource = 600
        alamoFireManager = Alamofire.Manager(configuration: configuration)
        
        let token = User.currentUser.token
        Alamofire.request(.GET, "\(url)/image", parameters:[
            "id":User.currentUser.uid ?? "",
            "token": User.currentUser.token ?? "",
            "folderName": folderName ?? "",
            "imageName": firstImageInFolder ?? "",
            ])
            .responseJSON { [weak self] response in
                if let base64 = String(data:(response.data)!, encoding: NSUTF8StringEncoding) {
                    dispatch_async(dispatch_get_main_queue()) {
                        if let data = NSData(base64EncodedString: base64, options: []) {
                            if let image = UIImage(data: data) {
                                cell?.placeImage.image = image
                                cell?.placeName.text = folderName
                                cell?.spinner.stopAnimating()
                                imageCache.setObject(image, forKey: firstImageInFolder)
                            }
                        }
                    }
                }
        }
        
        
        // cell.backgroundColor = chooseColor() // for testing purposes
        return cell!
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if User.currentUser.isList {
            return CGSize(width: self.view.frame.width, height: self.view.frame.width + 100.0)
        }
        return CGSize(width: self.view.frame.width/3 - 2.0, height: self.view.frame.width/3 + 60.0)
    }
    
    //    func chooseColor() -> UIColor {
    //        let r = CGFloat(drand48())
    //        let g = CGFloat(drand48())
    //        let b = CGFloat(drand48())
    //        return UIColor(red: r, green: g, blue: b, alpha: 0.7)
    //    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        performSegueWithIdentifier(Const.folderSegue, sender: indexPath.row)
    }
    
    
    
    func deletePlace(sender: UIButton) {
        // delete folder from backend
        
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete this folder? It will no longer be available", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) {
            [weak self] action in
            // delete
            
            if let folderIndex = (sender.layer.valueForKey("index")) as? Int {
                
                configuration.timeoutIntervalForRequest = 60
                configuration.timeoutIntervalForResource = 60
                alamoFireManager = Alamofire.Manager(configuration: configuration)
                
                let folderName = self?.places[folderIndex].name!
                
                let encodedFolderName = folderName!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!

                Alamofire.request(.DELETE, "\(url)/folder?folderName=\(encodedFolderName)", parameters:[
                    "id":User.currentUser.uid ?? "",
                    "token": User.currentUser.token ?? ""
                    ], encoding: .JSON)
                    .responseJSON { response in
                        switch response.result {
                        case .Success:
                            break
                        case .Failure(_):
                            break
                        }
                }
                self?.places.removeAtIndex(folderIndex)
                self?.collectionView.reloadData()
            }
            })
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil)) // do no thing
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    func refresh() {
        User.currentUser.updateTheModel() { [weak self] (updatedPlaces,recievedMessage) in
            dispatch_async(dispatch_get_main_queue()) {
                self?.showErrorView(recievedMessage)
                self?.refreshControl.endRefreshing()
                self?.places = updatedPlaces!
                self?.collectionView.reloadData()
            }
        }
    }
    
    func setUpNotifications() {
        // let the game begins!!
        // since we are limited with 20 region to be tracked and get notification when user is enters the region we will do a little trick here with the help of Harvensine formula first we will cancel all registred notifications
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        // now we have 20 region available we will choose the nearest region for current location of the user using Harvensine
        
        
        
        let geocoder = CLGeocoder()
        var regionsToBeRegistred:[CLCircularRegion] = [] // TODO: use NSMutableArray
        var maximumDistInArray: Double?
        for place in places {
            var lat: Double!
            var long: Double!
            geocoder.geocodeAddressString(place.name!) { [weak self] (placemarks,error) in
                if error != nil {
                    print(error)
                    return
                }
                lat = placemarks?[0].location?.coordinate.latitude
                long = placemarks?[0].location?.coordinate.longitude
                
                let dist = self!.haversine(self!.currentLocationLat!, lon1: self!.currentLocationLng!, lat2: lat, lon2: long)
                if let _ = maximumDistInArray {
                    if dist <= maximumDistInArray && !regionsToBeRegistred.isEmpty {
                        self!.fetchBoundries(place.name!) {
                            (latNortheast, lngNortheast, _, _) in
                            let radiusInKm = self!.haversine(self!.currentLocationLat!, lon1: self!.currentLocationLng!, lat2: latNortheast, lon2: lngNortheast)
                            
                            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude:
                                lat, longitude: long), radius: radiusInKm * 100.0, identifier: "\(place.name!)")
                            print("++++++++++++++++++++++++++++++++++++++++++++++++++++++")
                            print(lat,long,radiusInKm * 100.0, place.name!)
                            print("++++++++++++++++++++++++++++++++++++++++++++++++++++++")
                            self?.registerForRegionNotifications(region)
                            regionsToBeRegistred.append(region)
                        }
                    } else if !regionsToBeRegistred.isEmpty {
                        maximumDistInArray = dist
                        self!.fetchBoundries(place.name!) {
                            (latNortheast, lngNortheast, _, _) in
                            let radiusInKm = self?.haversine(self!.currentLocationLat!, lon1: self!.currentLocationLng!, lat2: latNortheast, lon2: lngNortheast)
                            
                            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude:
                                lat, longitude: long), radius: radiusInKm! * 100.0, identifier: "\(place.name!)")
                            print("++++++++++++++++++++++++++++++++++++++++++++++++++++++")
                            print(lat,long,radiusInKm! * 100.0, place.name!)
                            print("++++++++++++++++++++++++++++++++++++++++++++++++++++++")
                            self?.registerForRegionNotifications(region)
                            regionsToBeRegistred.append(region)
                        }
                    }
                } else {
                    maximumDistInArray = dist
                    
                    
                    // here i should request "http://maps.googleapis.com/maps/api/geocode/json?sensor=false&address=\(place.name!)" to know the boundries of a city (radius) note that you have  2500 request/day
                    
                    self!.fetchBoundries(place.name!) { (latNortheast, lngNortheast, _, _) in
                        let radiusInKm = self!.haversine(self!.currentLocationLat!, lon1: self!.currentLocationLng!, lat2: latNortheast, lon2: lngNortheast)
                        
                        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude:
                            lat, longitude: long), radius: radiusInKm * 100.0, identifier: "\(place.name!)")
                        print("++++++++++++++++++++++++++++++++++++++++++++++++++++++")
                        print(lat,long,radiusInKm * 100.0, place.name!)
                        print("++++++++++++++++++++++++++++++++++++++++++++++++++++++")
                        self?.registerForRegionNotifications(region)
                        regionsToBeRegistred.append(region)
                    }
                }
                
            }
            
            //  testing values:
            //        51.50998, -0.1337
            //        lat:  31.3123825321504
            //        long: 30.0638253624121
            //        31.3124,30.0638
        }
    }
    
    func fetchBoundries(address: String, completion: completionHandler) {
        let encodedadress = address.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let googleGeocodeApiUrlWithQuery = "https://maps.googleapis.com/maps/api/geocode/json?sensor=false&address=\(encodedadress)"
        
        Alamofire.request(.GET, googleGeocodeApiUrlWithQuery)
            .responseJSON { [weak self] response in
                debugPrint(response)
                switch response.result {
                case .Success:
                    if let JSON = response.result.value as? [String: AnyObject] {
                        print(JSON)
                        let results = JSON["results"] as? [AnyObject] ?? []
                        let firstResults = results.first as? [String: AnyObject] ?? [:]
                        let geometry = firstResults["geometry"] as! [String: AnyObject]
                        let bounds = geometry["bounds"] as! [String: AnyObject]
                        let northeast = bounds["northeast"] as! [String: AnyObject]
                        let southwest = bounds["southwest"] as! [String: AnyObject]
                        
                        let latNortheast = northeast["lat"] as? Double
                        let lngNortheast = northeast["lng"] as? Double
                        
                        let latSouthwest = southwest["lat"] as? Double
                        let lngSouthwest = southwest["lng"] as? Double
                        
                        completion(latNortheast!, lngNortheast!, latSouthwest!, lngSouthwest!)
                        
                    } else {
                        print(String(data: response.data!, encoding: NSUTF8StringEncoding))
                        self?.showErrorView(String(data: response.data!, encoding: NSUTF8StringEncoding))
                    }
                case .Failure(let error):
                    print(error)
                    let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
                    self?.showErrorView(errorMessage)
                    
                    print(String(data: response.data!, encoding: NSUTF8StringEncoding))
                    self?.showErrorView(String(data: response.data!, encoding: NSUTF8StringEncoding))
                }
        }
        
    }
    
    func registerForRegionNotifications(region: CLCircularRegion) {
        region.notifyOnExit = false
        let locattionnotification = UILocalNotification()
        locattionnotification.alertBody = "You are near the past!"
        locattionnotification.regionTriggersOnce = false
        locattionnotification.region = region
        UIApplication.sharedApplication().scheduleLocalNotification(locattionnotification)
    }
    
    func haversine(lat1:Double, lon1:Double, lat2:Double, lon2:Double) -> Double {
        let lat1rad = lat1 * M_PI/180
        let lon1rad = lon1 * M_PI/180
        let lat2rad = lat2 * M_PI/180
        let lon2rad = lon2 * M_PI/180
        
        let dLat = lat2rad - lat1rad
        let dLon = lon2rad - lon1rad
        let a = sin(dLat/2) * sin(dLat/2) + sin(dLon/2) * sin(dLon/2) * cos(lat1rad) * cos(lat2rad)
        let c = 2 * asin(sqrt(a))
        let R = 6372.8
        
        return R * c
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Const.folderSegue {
            if let dest = segue.destinationViewController as? MemoriesViewController {
                let index = (sender as! Int)
                dest.memories = places[index].memories!
                dest.folderName = places[index].name!
                dest.folderIndex = index
            }
        } else if segue.identifier == Const.showPhotoEditor {
            if let dest = segue.destinationViewController as? PhotoEditorViewController {
                let pickedImage = sender as! UIImage
                dest.pickedImage = pickedImage
            }
        }
    }
    
}


extension WallViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            if let _ = currentLocationLat, let _ = currentLocationLng {
                if !notificationsDidSet {
                    setUpNotifications()
                    // locationManager.stopUpdatingLocation()
                    notificationsDidSet = true
                    print("current location: \(location)")
                }
            }
            self.currentLocationLat = location.coordinate.latitude
            self.currentLocationLng = location.coordinate.longitude
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error: \(error)")
    }
    
}



