//
//  PhotoMapAnnotation.swift
//  iWasHere
//
//  Created by Khalil Mohammed Yakout on 9/11/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class PhotoMapAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    var title: String? // will be the name in Memory
    var subtitle: String?
    var folderName: String?
    
    init(title: String?, coordinate: CLLocationCoordinate2D?, subtitle: String?, folderName: String?) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate ?? CLLocationCoordinate2D()
        self.folderName = folderName
    }
}