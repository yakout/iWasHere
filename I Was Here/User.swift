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
    
    // MARK: vars
    
    var uid: String?
    var email: String?
    var username: String?
    var name: String?
    var profileImageUrl: String?
    var memories: [Memory]?
    var places: [Place]?
    
    
    // singelton user
    
    static var user: User?
    
    init(authData: FIRUser) {
        uid = authData.uid
        email = authData.email!
    }
    
    // MARK: Methods
    private func uploadImageToDatabase() {
        //TODO: update
    }
    
    static func getUser() -> User? {
        return user
    }
    
    func setData(auth: FIRUser) {
        self.uid = auth.uid
        self.email = auth.email
    }
    func getNumberOfFolders() -> Int? {
        return (places?.count)
    }
    
    func getFolderName(index: Int) -> String? {
        return places?[index].getPlaceName()
    }
    
    func getFolderImage(index: Int) -> UIImage? {
        return UIImage(named: "location")
    }
    
//    func getFolderImage(index: Int, handler: completionHandler) {
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
//    }
    
}