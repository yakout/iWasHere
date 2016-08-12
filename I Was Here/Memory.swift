//
//  Memory.swift
//  iWasHere
//
//  Created by Ahmed Yakout on 8/11/16.
//  Copyright © 2016 iYakout. All rights reserved.
//
import Foundation
import Firebase

class Memory {
    
    var key: String?
    var ref: FIRDatabaseReference?
    var description: String?
    var addedByUser: String?
    var imageUrl: String?
    
    init(imageUrl: String?, description: String?, addedByUser: String?, key: String? = "") {
        self.key = key
        self.ref = nil
        self.imageUrl = imageUrl
        self.description = description
        self.addedByUser = addedByUser
    }
    
    init(snapshot: FIRDataSnapshot) {
        self.key = snapshot.key
        self.ref = snapshot.ref
        self.description = snapshot.value?["description"] as? String
        self.addedByUser = snapshot.value?["addedByUser"] as? String
        self.imageUrl = snapshot.value!["imageUrl"] as? String
    }
    
    // Use setValue(_:) to save data to the database. This method expects a dictionary. GroceryItem has a helper function to turn it into a dictionary called toAnyObject().
    func toAnyObject() -> [String:AnyObject] {
        return [
            "description": description!,
            "addedByUser": addedByUser!,
            "imageUrl": imageUrl!
        ]
    }
}