//
//  GridTableViewCell.swift
//  iWasHere
//
//  Created by Mohammed Abdelbarry on 8/15/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import UIKit
protocol GridTableViewCellDelegate {
    func userDidSelectCell(cell: GridTableViewCell)
}
class GridTableViewCell: UITableViewCell {
    // MARK: - Properties
    var delegate: GridTableViewCellDelegate?
    @IBOutlet weak var folderImage1: UIImageView!
    @IBOutlet weak var folderName1: UILabel!
    @IBOutlet weak var folderImage2: UIImageView!
    @IBOutlet weak var folderName2: UILabel!
    @IBOutlet weak var folderImage3: UIImageView!
    @IBOutlet weak var folderName3: UILabel!
   
    // MARK: - Actions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.delegate?.userDidSelectCell(self)
        // Configure the view for the selected state
    }

}
