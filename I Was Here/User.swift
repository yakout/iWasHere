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
    var uid: String?
    var email: String?
    var username: String?
    var name: String?
    var profileImageUrl: String?
    var memories: [Memory]?
  
  init(authData: FIRUser) {
    uid = authData.uid
    email = authData.email!
  }
    
}