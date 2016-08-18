//
//  ListTableViewCell.swift
//  iWasHere
//
//  Created by Mohammed Abdelbarry on 8/15/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import UIKit
protocol ListTableViewCellDelegate {
    func userDidSelectListCell(cell: ListTableViewCell)
}
class ListTableViewCell: UITableViewCell {
    // MARK: - Properties
    var delegate: ListTableViewCellDelegate?
    @IBOutlet weak var folderImage: UIImageView!
    @IBOutlet weak var folderName: UILabel!
    
    // MARK: - Actions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.delegate?.userDidSelectListCell(self)
        }
        // Configure the view for the selected state
    }
    
}
