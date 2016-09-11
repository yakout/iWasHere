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
    
    var latitude: Double?
    var longitude: Double?
    
    var thumbnailUrl: String?
    var imageUrl: String?   
    
    init(name: String?, description: String?, addedByUser: String?, imageExtension: String?, latitude: Double?, longitude: Double?) {
        self.name = name
        self.description = description
        self.addedByUser = addedByUser
        self.imageExtension = imageExtension
        self.latitude = latitude
        self.longitude = longitude
    }
}