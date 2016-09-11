//
//  MemoryCollectionViewCell.swift
//  iWasHere
//
//  Created by Khalil Mohammed Yakout on 9/6/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import UIKit

class MemoryCollectionViewCell: UICollectionViewCell {
    
    var memoryName: String!
    @IBOutlet weak var memoryDescription: UILabel!
    @IBOutlet weak var memoryImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
}
