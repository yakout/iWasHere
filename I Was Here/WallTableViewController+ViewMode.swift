//
//  WallTableViewController_Merge.swift
//  iWasHere
//
//  Created by Mohammed Abdelbarry on 8/16/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import UIKit
import Firebase

extension WallTableViewController: ListTableViewCellDelegate, GridTableViewCellDelegate {
    
    // MARK: - Properties
    
    // .. moved to original class
    
    
    // MARK: Table view
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfFolders = user.getNumberOfFolders()
        if isList! {
            return numberOfFolders
        } else {
            if (numberOfFolders % 3) == 0 {
                return numberOfFolders / 3
            } else {
                return numberOfFolders / 3 + 1
            }
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isList! {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("wallListViewCell") as? ListTableViewCell
            cell?.folderName.text = user.getFolderName(indexPath.row)
            cell?.folderImage.image = user.getFolderImage(indexPath.row)
            cell?.delegate = self
            return cell!
        } else {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("wallGridViewCell") as? GridTableViewCell
            cell?.folderName1.text = user.getFolderName(indexPath.row * 3)
            cell?.folderName2.text = user.getFolderName(indexPath.row  * 3 + 1)
            cell?.folderName3.text = user.getFolderName(indexPath.row * 3 + 2)
            cell?.setFolderImages(user.getFolderImage(indexPath.row * 3), image2: user.getFolderImage(indexPath.row * 3 + 1),
                                  image3: user.getFolderImage(indexPath.row * 3 + 2))
            cell?.delegate = self
            return cell!
        }
    }
    
    // MARK: Grid and List Delegate Methods
    
    func userDidSelectGridCell(cell: GridTableViewCell, whichImage: Int) {
        //let folderIndex = whichImage + self.tableView.indexPathForCell(cell)
        print(whichImage + 3 * self.tableView.indexPathForCell(cell)!.row)
    }
    func userDidSelectListCell(cell: ListTableViewCell) {
        //let folderIndex = self.tableView.indexPathForCell(cell)
        //performSegueWithIdentifier(Image Table Controller)
        if let indexPath = self.tableView.indexPathForCell(cell) {
            print(indexPath.row)
        }
    }
}
