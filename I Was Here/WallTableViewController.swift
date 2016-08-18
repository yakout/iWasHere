//
//  WallTableViewController.swift
//  iWasHere
//
//  Created by Ahmed Yakout on 8/11/16.
//  Copyright © 2016 iYakout. All rights reserved.
//


import UIKit
import Firebase

class WallTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Constants
    
    struct Const {
        static let logoutSegueIdentifier = "logout"
        static let memoryCell = "memoryCell"
    }
    let rootRef = FIRDatabase.database().reference() // This establishes a connection to your Firebase database using the unique URL in GoogleService-Info.plist file.
    // let ref = FIRDatabase.database().referenceFromURL("http")
    let ref = FIRDatabase.database().reference()
    
    
    // MARK: Properties
    var appSettings = AppSettings()
    var user = User.getUser()
    var isList: Bool!
    var memories = [Memory]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    //        let newMemory = memories[indexPath.row]
    //        cell?.textLabel?.text = newMemory.description
    //        cell?.detailTextLabel?.text = newMemory.addedByUser
    //        if let imageUrlString = newMemory.imageUrl {
    //            let imageUrl = NSURL(string: imageUrlString)!
    //            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
    //                let fetchImageData = NSData(contentsOfURL: imageUrl)
    //                dispatch_async(dispatch_get_main_queue()) {
    //                    if let imageData = fetchImageData {
    //                        cell?.imageView?.image = UIImage(data: imageData)
    //                        print("image must show now!")
    //                    }
    //                }
    //            }
    //        }
    
    
    // MARK: - Actions
    
    @IBAction func addButtonDidTouch(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true // if you set this for true you need to access the editted photo using UIImagePickerControllerEditedImage
        
        imagePicker.sourceType = .PhotoLibrary
        // imagePicker.sourceType = .Camera
        presentViewController(imagePicker, animated: true, completion: nil)
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
        
        updataDatabse(pickedImage!)
    }
    
    func updataDatabse(pickedImage: UIImage) {
        
        let uploadData = UIImagePNGRepresentation(pickedImage)
        let uniqueId = NSUUID().UUIDString
        let storageRef = FIRStorage.storage().reference().child("users_images").child("\(user.email)!").child("\(uniqueId).png")
        
        
        let alert = UIAlertController(title: "Uploading", message: "Uploading the image please wait", preferredStyle: UIAlertControllerStyle.ActionSheet)
        presentViewController(alert, animated: true, completion: nil)
        
        storageRef.putData(uploadData!, metadata: nil) { [weak self]
            (metaData, error) in
            print("should be uploaded now")
            if let error = error {
                print(error)
                self?.dismissViewControllerAnimated(true, completion: nil)
                
            } else {
                let imageUrl = metaData?.downloadURL()?.absoluteString
                print(imageUrl)
                let newMemory = Memory(imageUrl: imageUrl, description: "beautiful image", addedByUser: self?.user.email)
                self?.memories.append(newMemory)
                
                let memoryRef = self?.ref.child("users").child((self?.user.uid)!)
                memoryRef?.setValue(newMemory.toAnyObject())
                self?.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if didLogoutWithSuccess() {
            // TODO: change this
            // navigationItem.popToRootViewControllerAnimated(true)?.popLast()
            return true
        }
        return false
    }
    
    
    func didLogoutWithSuccess() -> Bool {
        do {
            try FIRAuth.auth()?.signOut()
            print("user signed out")
            User.user.uid = nil
            return true
        } catch let logoutError {
            print(logoutError)
            return false
        }
    }
    
    
    // MARK: UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // make the cell height flixeble
        // tableView.estimatedRowHeight = tableView.rowHeight
        // tableView.rowHeight = UITableViewAutomaticDimension
        
        user.loadMemories()
        isList = false // appSettings.get(AppSettings.Settings.ListViewIsEnabled) as! Bool
        
        if FIRAuth.auth()?.currentUser?.uid == nil {
            performSelector(#selector(didLogoutWithSuccess), withObject: nil, afterDelay: 0)
        } else {
            let auth = FIRAuth.auth()?.currentUser
            self.user = User.getUser()
            user.setData(auth!)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Here we’ve added an observer that executes the given closure whenever the value that ref points to is changed.
        // ref.queryOrderedByChild("somekey").obser... to order
        //        ref.observeEventType(.Value, withBlock: { snapshot in // snapshot repressent data at specific moments in time
        //            print(snapshot.value)
        //            var newItems = [Memory]()
        //            for item in snapshot.children {
        //                let newMemory = Memory(snapshot: item as! FIRDataSnapshot)
        //                newItems.append(newMemory)
        //            }
        //            self.memories = newItems
        //            }, withCancelBlock: { error in
        //                print(error.description)
        //        })
        
        //        FIRAuth.auth()?.addAuthStateDidChangeListener { (auth, user) in
        //            if let user = user {
        //                print("User is signed in with uid:", user.uid)
        //                self.user = User(authData: user)
        //            } else {
        //                print("No user is signed in.")
        //            }
        //        }
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
}