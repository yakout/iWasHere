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
    
    // MARK: - User Life Cycle
    init(authData: FIRUser) {
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
    }
    func getFolderName(index: Int) -> String {
        // TODO: - Given the folder index, return its name.
    }
    func getFolderImage(index: Int) -> UIImage {
        // TODO: - Return the first image in a folder.
    }
    func getNumberOfMemoriesInFolder(index: Int) -> Int {
        // TODO: - Return the number of memories in this folder.
    }
    func getMemoryImage(folderIndex: Int, memoryIndex: Int) -> UIImage {
        // TODO: - Given the folder index and memory index, return the picture attached to this memory.
    }
    func getMemoryDescription(folderIndex: Int, memoryIndex: Int) -> String {
        // TODO: - Given the folder index and memory index, return the description of the memory.
    }
}