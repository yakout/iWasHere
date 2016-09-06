//
//  Memory.swift
//  iWasHere
//
//  Created by Ahmed Yakout on 8/11/16.
//  Copyright © 2016 iYakout. All rights reserved.
//
import Foundation
import MapKit

class Memory {
    
    var name: String?
    var description: String?
    var addedByUser: String?
    var imageExtension: String?
    
    var thumbnailUrl: String?
    var imageUrl: String?
    
    var latitude: Double?
    var longitude: Double?
    
    var annotation: Annotation? {
        get {
            return self.annotation
        }
        set {
            if let loc = newValue {
                // annotation = Annotation(title: name!, subtitle: description!, longitude: loc[0], latitude: loc[1])
            } else {
                self.annotation = nil
            }
        }
    }
    
    
    init(name: String?, description: String?, addedByUser: String?, imageExtension: String?) {
        self.name = name
        self.description = description
        self.addedByUser = addedByUser
        self.imageExtension = imageExtension
    }
}