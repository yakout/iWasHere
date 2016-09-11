//
//  Place.swift
//  iWasHere
//
//  Created by Ahmed Yakout on 8/14/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import Foundation
import MapKit

class Place {
    
    init(name: String?, memories: [Memory]?, count: Int) {
        self.name = name
        self.memories = memories
        self.memoriesCount = count
    }

    var name: String?
    var memories: [Memory]?
    var memoriesCount: Int?

}