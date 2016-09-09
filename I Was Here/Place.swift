//
//  Place.swift
//  iWasHere
//
//  Created by Ahmed Yakout on 8/14/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import Foundation
import MapKit

class Place: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    var title: String?
    var subtitle: String?
    
    
    init(title: String?, coordinate: CLLocationCoordinate2D?, subtitle: String?, name: String?, memories: [Memory]?, count: Int) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate ?? CLLocationCoordinate2D()
        self.name = name
        self.memories = memories
        self.memoriesCount = count
    }

    var name: String?
    var memories: [Memory]?
    var memoriesCount: Int?

}