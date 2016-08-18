//
//  memoriesTableViewController.swift
//  iWasHere
//
//  Created by Mohammed Abdelbarry on 8/18/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import UIKit

class MemoriesTableViewController: UITableViewController, GridTableViewCellDelegate {
    var currentFolderIndex: Int!
    var user = User.getUser()
    func userDidSelectGridCell(cell: GridTableViewCell, whichImage: Int) {
        // TODO: - add a segue to a view controller with the full imageview and description
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfFolders = user.getNumberOfMemoriesInFolder(currentFolderIndex)
        if (numberOfFolders % 3) == 0 {
            return numberOfFolders / 3
        } else {
            return numberOfFolders / 3 + 1
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("wallGridViewCell") as? GridTableViewCell
        cell?.folderName1.text = nil
        cell?.folderName2.text = nil
        cell?.folderName3.text = nil
        cell?.setFolderImages(user.getMemoryImage(currentFolderIndex, memoryIndex: indexPath.row * 3),
                              image2: user.getMemoryImage(currentFolderIndex, memoryIndex: indexPath.row * 3 + 1),
                              image3: user.getMemoryImage(currentFolderIndex, memoryIndex: indexPath.row * 3 + 2))
        cell?.delegate = self
        return cell!
        
    }
}
