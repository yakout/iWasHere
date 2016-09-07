//
//  WallViewController.swift
//  iWasHere
//
//  Created by Ahmed Yakout on 9/3/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import UIKit
import Alamofire


var imageCache = NSCache()

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
        
        if let imageData = UIImagePNGRepresentation(pickedImage) {
            
            let strBase64:String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            
            Alamofire.request(.POST, "https://ec42e392.ngrok.io/image", parameters:[
                "id":User.currentUser.uid ?? "2",
                "token": User.currentUser.token ?? "",
                "folderName":"test",
                "imageName": NSUUID().UUIDString,
                "imageDescription":"no description",
                "extension":"png",
                "data": strBase64
                ])
                .responseJSON { response in
                    debugPrint(response)
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                    }
            }
        }
    }
    
    
    // MARK: - life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        places = User.currentUser.places!
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if User.currentUser.isList != isList {
            collectionView.reloadData()
            isList = User.currentUser.isList
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let tempImageNameToFetchLocatedInBaryAwesoneServerButItsNotIncludingInTheImagesObject = "14124157_1138265276229954_375787950_o"
        let folder = places[indexPath.row]
        let folderName = folder.name
        let firstImageInFolder = folder.memories?[0].name ?? ""
        cell?.spinner.hidesWhenStopped = true
        cell?.spinner.startAnimating()
        
        if let cachedImage = imageCache.objectForKey(firstImageInFolder) as? UIImage {
            cell?.placeImage.image = cachedImage
            cell?.placeName.text = folderName
            cell?.spinner.stopAnimating()
            return cell!
        }
        
        Alamofire.request(.GET, "https://ec42e392.ngrok.io/image", parameters:[
            "id":User.currentUser.uid ?? "2",
            "token": User.currentUser.token ?? "",
            "folderName": folderName ?? "",
            "imageName": firstImageInFolder ?? "",
            ])
            .responseJSON { response in
                let base64 = String(data:(response.data)!, encoding: NSUTF8StringEncoding)!
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
