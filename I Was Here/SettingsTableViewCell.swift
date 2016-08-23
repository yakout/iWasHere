//
//  SettingsTableViewCell.swift
//  
//
//  Created by Ahmed Khaled on 8/19/16.
//
//

import UIKit

protocol SettingsTableViewCellDelegate {
    func userDidSelectCellWithIdentifier(cell: SettingsTableViewCell, cellIdentifier: String)
}

class SettingsTableViewCell: UITableViewCell {
    
    
    
    // MARK: - Actions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        ////if selected {
         //   self.delegate?.userDidSelectListCell(self)
        //}
        // Configure the view for the selected state
    }
}
