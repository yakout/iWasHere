//
//  Annotation.swift
//  iWasHere
//
//  Created by Ahmed Yakout on 8/27/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation


class Annotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
    }
    
    var title: String?
    var subtitle: String?
    
    var longitude: Double?
    var latitude: Double?
    
    init(title: String, subtitle: String, longitude: Double, latitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.subtitle = subtitle
    }
}