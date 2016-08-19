//
//  User.swift
//  iWasHere
//
//  Created by Ahmed Yakout on 8/11/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

typealias completionHandler = (UIImage?)

class User {
    
    // MARK: Properties
    
    var uid: String?
    var email: String?
    var username: String?
    var name: String?
    var profileImageUrl: String?
    var places: [Place]?
    // initially on turned on notifications.
    var isList = true
    var sendNotifications = true
    
    // singelton user
    static var user = User()
    
    // MARK: - User Life Cycle
    private init() {
        
    }
    static func getUser() -> User {
        return user
    }
    func setData(authData: FIRUser) {
        uid = authData.uid
        email = authData.email!
    }
    
    private func sendNotificationsMode() -> Bool {
        // Here we get the mode from data
        //....
        return sendNotifications
    }
    func setNotificationsMode(on: Bool) {
        //Save this data as well..
        
        sendNotifications = on
    }
    private func iconsMode() -> Bool {
        // Here we get the mode from data
        //....
        return isList
        
    }
    func setIconsMode(list: Bool) {
        isList = list
    }

    
    // MARK: - Actions
    func loadMemories() {
        // TODO: - Retrieve user's memories from an offline source (file i/o).
        // Getting memories from the back-end would be a big overhead.
        // We will store the data using some convention like uid + / + images + / + folderName.
    }
    func getNumberOfFolders() -> Int {
        // return places?.count ?? 0
        return 4; // for testing
    }
    func getFolderName(index: Int) -> String? {
        // return places?[index].getPlaceName()
        
        // for testing
        if index > 3 {
            return nil
        }
        return "folder" + String(index + 1)
    }
    func getFolderImage(index: Int) -> UIImage? {
        // TODO: - Return the first image in a folder.
        //        let imageUrl: NSURL?
        //        if let url = places?[index].getPlaceMemories().first?.imageUrl {
        //            imageUrl = NSURL(string: url)
        //        }
        //
        //        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
        //            let fetchImage: NSData?
        //            if imageUrl != nil {
        //                fetchImage = NSData(contentsOfURL: imageUrl!)
        //            }
        //
        //            let foo = UIImage(data: fetchImage!)
        //            handler(foo)
        //        }
        
        
        print(index)
        if index > 3 {
            return nil
        }
        return UIImage(named: "addPictures")
    }
    func getNumberOfMemoriesInFolder(index: Int) -> Int {
        return places?[index].getPlaceMemories().count ?? 0
    }
    func getMemoryImage(folderIndex: Int, memoryIndex: Int) -> UIImage {
        // TODO: - Given the folder index and memory index, return the picture attached to this memory.
        if let _ = places?[folderIndex].getPlaceMemories()[memoryIndex].imageUrl {
            // ...
        }
        
        return UIImage()
    }
    func getMemoryDescription(folderIndex: Int, memoryIndex: Int) -> String {
        return places?[folderIndex].getPlaceMemories()[memoryIndex].description ?? ""
    }
    
    
}
