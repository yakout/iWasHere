//
//  UserDefaults.swift
//  Damstores
//
//  Created by Khalil Mohammed Yakout on 8/26/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import Foundation


class UserDefaults {
    
    private struct Const {
        static let UserKeys = "User"
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var userInfo: [String: AnyObject] {
        get { return defaults.objectForKey(Const.UserKeys) as? [String: AnyObject] ?? [:] }
        set { defaults.setObject(newValue, forKey: Const.UserKeys) }
    }
    
    func updateUserInfoWithInfo(info: [String: AnyObject]) {
        userInfo = info
    }
}