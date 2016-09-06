//
//  WallTableViewController.swift
//  iWasHere
//
//  Created by Ahmed Yakout on 8/11/16.
//  Copyright © 2016 iYakout. All rights reserved.
//


import UIKit

class WallTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Constants
    
    struct Const {
        static let logoutSegueIdentifier = "logout"
        static let memoryCell = "memoryCell"
    }
    // let ref = FIRDatabase.database().referenceFromURL("http")
    let folderSegue = "openFolderSegue"
    
    // MARK: Properties
    var user = User.getCurrentUser()
    var isList: Bool!
    var memories = [Memory]() {
        didSet {
            tableView.reloadData()
        }
    }
    var segueFolderIndex: Int!
    
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
    
    
    
    
    
    // MARK: - Methods
    
    func didLogoutWithSuccess() -> Bool {
        User.currentUser.uid = nil
        User.currentUser.token = nil
        return true
    }
    
    
    
    // MARK: UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // make the cell height flixeble
        // tableView.estimatedRowHeight = tableView.rowHeight
        // tableView.rowHeight = UITableViewAutomaticDimension
        
        user.loadMemories()
        isList = user.iconsModeIsList()
        
        if let _ = User.currentUser.uid, let _ = User.currentUser.token {
            self.user = User.getCurrentUser()
        } else {
            print("no user signed in")
            performSelector(#selector(didLogoutWithSuccess), withObject: nil, afterDelay: 0)
            performSegueWithIdentifier(Const.logoutSegueIdentifier, sender: nil)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        isList = user.iconsModeIsList()
        tableView.reloadData()
    }
    
}