//
//  SettingsTableViewCell.swift
//  iWasHere
//
//  Created by Ahmed Khaled on 8/17/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import UIKit

protocol SettingsTableViewCellDelegate {
    func userDidSelectSettingsCell(cell: SettingsTableViewCell)
}

class SettingsTableViewCell: UITableViewCell {
    
    var delegate: SettingsTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //Mark :- Properties
    @IBOutlet weak var notificationsLabel: UILabel!
    @IBAction func notificationSelector(sender: AnyObject) {
        self.delegate?.userDidSelectSettingsCell(self)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        self.delegate?.userDidSelectSettingsCell(self)
    }

}
