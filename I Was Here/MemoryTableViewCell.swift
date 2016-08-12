//
//  MemoryTableViewCell.swift
//  iWasHere
//
//  Created by Ahmed Yakout on 8/8/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import UIKit

class MemoryTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var memoryDescription: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var memoryImage: UIImageView!
    
    
    
    
    // MARK: - Actions
    
    @IBAction func instagramShare(sender: AnyObject) {
        print("posted on instagram")
    }
    @IBAction func facebookShare(sender: UIButton) {
        print("posted on facebook")
    }
    @IBAction func tweet(sender: UIButton) {
        print("tweet sent")
    }
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
