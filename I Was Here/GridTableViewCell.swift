//
//  GridTableViewCell.swift
//  iWasHere
//
//  Created by Mohammed Abdelbarry on 8/15/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import UIKit
protocol GridTableViewCellDelegate {
    func userDidSelectGridCell(cell: GridTableViewCell, whichImage: Int)
}
class GridTableViewCell: UITableViewCell {
    // MARK: - Properties
    var delegate: GridTableViewCellDelegate?
    @IBOutlet weak var folderName1: UILabel!
    @IBOutlet weak var folderName2: UILabel!
    @IBOutlet weak var folderName3: UILabel!
    @IBOutlet weak var folder1: UIButton!
    @IBOutlet weak var folder2: UIButton!
    @IBOutlet weak var folder3: UIButton!
   
    // MARK: - Actions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func setFolderImages(image1: UIImage?, image2: UIImage?, image3: UIImage?) {
        folder1.imageView?.image = image1
        folder2.imageView?.image = image2
        folder3.imageView?.image = image3
    }
    @IBAction func clickedFolder1(sender: UIButton) {
        self.delegate?.userDidSelectGridCell(self, whichImage: 0)
    }
    @IBAction func clickedFolder2(sender: UIButton) {
        self.delegate?.userDidSelectGridCell(self, whichImage: 1)
    }
    @IBAction func clickedFolder3(sender: UIButton) {
        self.delegate?.userDidSelectGridCell(self, whichImage: 2)
    }
}
