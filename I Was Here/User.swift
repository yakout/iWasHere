//
//  User.swift
//  iWasHere
//
//  Created by Ahmed Yakout on 8/11/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class User {
    
    // MARK: - Properties
    var uid: String?
    var email: String?
    var username: String?
    var name: String?
    var profileImageUrl: String?
    var memories: [Memory]?
    var isList = false //set to true if you want list view
    static var user = User()
    // MARK: - User Life Cycle
    private init() {
        
    }
    static func getUser() -> User {
        return user
    }
    func setData(authData: FIRUser) {
        uid = authData.uid
        email = authData.email!
    }
    // MARK: - Actions
    func loadMemories() {
        // TODO: - Retrieve user's memories from an offline source (file i/o).
        // Getting memories from the back-end would be a big overhead.
        // We will store the data using some convention like uid + / + images + / + folderName.
    }
    func getNumberOfFolders() -> Int {
        // TODO: - Return the number of folders.
        // Notice that the current memories array has to be replaced by a 2d array.
        return 4;
    }
    func getFolderName(index: Int) -> String? {
        // TODO: - Given the folder index, return its name.
        if index > 3 {
            return nil
        }
        return "folder" + String(index + 1)
    }
    func getFolderImage(index: Int) -> UIImage? {
        // TODO: - Return the first image in a folder.
        if index > 3 {
            return nil
        }
        return UIImage(named: "addPictures")
    }
    func getNumberOfMemoriesInFolder(index: Int) -> Int {
        // TODO: - Return the number of memories in this folder.
        return 0
    }
    func getMemoryImage(folderIndex: Int, memoryIndex: Int) -> UIImage {
        // TODO: - Given the folder index and memory index, return the picture attached to this memory.
        return UIImage()
    }
    func getMemoryDescription(folderIndex: Int, memoryIndex: Int) -> String {
        // TODO: - Given the folder index and memory index, return the description of the memory.
        return ""
    }
    func getViewMode() -> Bool {
        return isList
    }
    
    //For sending notifications in settings
    func getNotificationForUser() -> Bool {
        // Here we get user's mode from back-end .. and return whether it is true or false.
        return true
    }
}