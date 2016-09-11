//
//  User.swift
//  iWasHere
//
//  Created by Ahmed Yakout on 8/11/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

typealias completionHandler = ([Place]?, String?) -> Void

class User {
    
    // MARK: Properties
    
    var uid: String?
    var token: String?
    var email: String?
    var username: String?
    var name: String?
    var profileImageUrl: String?
    var places: [Place]?
    var isList = true // default
    var sendNotifications = true // defualt
    
    
    // MARK: - User Life Cycle
    
    // singelton user
    static var currentUser = User()
    
    private init() {
        
    }
    static func getCurrentUser() -> User {
        return currentUser
    }
    
    // MARK: - User Settings
    
    func sendNotificationsMode() -> Bool {
        return sendNotifications
    }
    func setNotificationsMode(enable: Bool) {
        self.sendNotifications = enable
    }
    func iconsModeIsList() -> Bool {
        return isList
    }
    func setIconsMode(isList: Bool) {
        self.isList = isList
    }
    
    
    // MARK: - Methods
    
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
        return places?[index].memories?.count ?? 0
    }
    func getMemoryImage(folderIndex: Int, memoryIndex: Int) -> UIImage {
        // TODO: - Given the folder index and memory index, return the picture attached to this memory.
        if let _ = places?[folderIndex].memories?[memoryIndex].imageUrl {
            // ...
        }
        
        return UIImage()
    }
    func getMemoryDescription(folderIndex: Int, memoryIndex: Int) -> String {
        return places?[folderIndex].memories?[memoryIndex].description ?? ""
    }
    
    
    
    func updateTheModel(completion: completionHandler) {
        var returnVlaue: String?
        
        let id = User.currentUser.uid
        let token = User.currentUser.token
        
        Alamofire.request(.GET, "\(url)/user", parameters: [
            "id": id ?? "",
            "token": token ?? ""
            ])
            .responseJSON { response in
                debugPrint(response)
                
                switch response.result {
                case .Success:
                    if let JSON = response.result.value as? [String: AnyObject] {
                        let folders = JSON["folders"] as? [AnyObject] ?? []
                        let foldersCount = JSON["foldersCount"] as! Int
                        
                        var places = [Place]()
                        for i in 0 ..< foldersCount {
                            let folder = folders[i] as? [String : AnyObject] ?? [:]
                            let placeName = folder["folderName"] as? String
                            let imagesCount = folder["imagesCount"] as! Int
                            let images = folder["images"] as? [AnyObject] ?? []
                            
                            var memories = [Memory]()
                            for j in 0 ..< imagesCount {
                                let image = images[j] as? [String: AnyObject] ?? [:]
                                let imageName = image["imageName"] as? String
                                let imageDescription = image["imageDescription"] as? String
                                let imageExtension = image["imageExtension"] as? String
                                let latitude = image["latitude"] as? Double
                                let longitude = image["longitude"] as? Double
                                
                                let memory = Memory(name: imageName, description: imageDescription, addedByUser: User.currentUser.email, imageExtension: imageExtension, latitude: latitude, longitude: longitude)
                                memories.append(memory)
                            }
                            
                            let place = Place(name: placeName, memories: memories, count: foldersCount)
                            places.append(place)
                        }
                        
                        User.currentUser.places = places
                    } else {
                        let message = String(data: response.data!, encoding: NSUTF8StringEncoding)
                        returnVlaue = message ?? ""
                    }
                case .Failure(let error):
                    print(error)
                    let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
                    let errorMessage2 = String(data: response.data!, encoding: NSUTF8StringEncoding)
                    returnVlaue = errorMessage ?? errorMessage2 ?? ""
                }
                
                completion(User.currentUser.places, returnVlaue)
        }
        
    }
    
}
