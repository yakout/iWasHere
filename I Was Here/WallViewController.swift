//
//  WallViewController.swift
//  iWasHere
//
//  Created by Ahmed Yakout on 9/3/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import UIKit
import Alamofire



class WallViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    struct Const {
        static let logoutSegueIdentifier = "logout"
        static let GridView = "GridCellIdentifer"
        static let folderSegue = "openFolderSegue"
    }
    
    // MARK: Properties
    
    var places = [Place]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var isList: Bool = true
    
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
    
    @IBAction func deleteFolder(sender: AnyObject) {
        
    }
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var pickedImage: UIImage?
        if let pickedEditedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            pickedImage = pickedEditedImage
        } else if let pickedOriginalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pickedImage = pickedOriginalImage
        }
        dismissViewControllerAnimated(true, completion: nil)
        
        uploadPicture(pickedImage!)
    }
    
    
    // MARK: helpers
    
    func uploadPicture(pickedImage: UIImage) {
        // note there is uploading method in alamofire check it late
        
        // to know the image size
        let imgData: NSData = NSData(data: UIImageJPEGRepresentation((pickedImage), 1)!)
        // var imgData: NSData = UIImagePNGRepresentation(image)
        // you can also replace UIImageJPEGRepresentation with UIImagePNGRepresentation.
        let imageSize = imgData.length
        print("size of image in KB: %f ", Double(imageSize)/1024.0)
        
        
        if let imageData = UIImageJPEGRepresentation(pickedImage, 0.2) {
            let imageDataSize = imageData.length
            print("size of image in KB after compression: %f ", Double(imageDataSize)/1024.0)
            
            
            let strBase64:String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            
            configuration.timeoutIntervalForRequest = 600
            configuration.timeoutIntervalForResource = 600
            alamoFireManager = Alamofire.Manager(configuration: configuration)
            
            Alamofire.request(.POST, "\(url)/image", parameters:[
                "id":User.currentUser.uid!,
                "token": User.currentUser.token!,
                "folderName":"temp",
                "imageName": NSUUID().UUIDString,
                "imageDescription":"no description",
                "extension":"jpg",
                "data": strBase64
                ], encoding: .JSON)
                .responseJSON { [weak self] response in
                    debugPrint(response)
                    switch response.result {
                    case .Success:
                        if let JSON = response.result.value {
                            print("JSON: \(JSON)")
                        } else {
                            self?.showErrorView(String(data: response.data!, encoding: NSUTF8StringEncoding))
                        }
                        
                        // update the current model and reload the data in the collection view
                        
                        self?.collectionView.reloadData()
                        
                    case .Failure(_):
                        self?.showErrorView(String(data: response.data!, encoding: NSUTF8StringEncoding))
                    }
            }
        }
    }
    
    
    // MARK: - life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        places = User.currentUser.places ?? []
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
        
        let tempImageNameToFetchLocatedInBaryAwesoneServerButItsNotIncludingInTheImagesObject = "14124157_1138265276229954_375787950_o"
        
        let folder = places[indexPath.row]
        let folderName = folder.name
        let firstImageInFolder = folder.memories?[0].name ?? ""
        
        cell?.spinner.hidesWhenStopped = true
        cell?.spinner.startAnimating()
        cell?.placeName.text = folderName
        
        
        if let cachedImage = imageCache.objectForKey(firstImageInFolder) as? UIImage {
            cell?.placeImage.image = cachedImage
            cell?.placeName.text = folderName
            cell?.spinner.stopAnimating()
            return cell!
        }
        
        configuration.timeoutIntervalForRequest = 600
        configuration.timeoutIntervalForResource = 600
        alamoFireManager = Alamofire.Manager(configuration: configuration)
        
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
            return CGSize(width: 500, height: 400)
        }
        return CGSize(width: 125, height: 125)
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
                
                Alamofire.request(.DELETE, "\(url)/folder/\(folderName!)", parameters:[
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
            }
        }
    }
    
}
