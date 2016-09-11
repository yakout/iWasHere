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
        static let UserKey = "User"
        static let NotificationsKey = "Notifications"
        static let helperMessageNo1 = "h1"
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var userInfo: [String: AnyObject] {
        get { return defaults.objectForKey(Const.UserKey) as? [String: AnyObject] ?? [:] }
        set { defaults.setObject(newValue, forKey: Const.UserKey) }
    }
    
    var enableNotifications: Bool {
        get {return defaults.objectForKey(Const.NotificationsKey) as? Bool ?? true}
        set {defaults.setObject(newValue, forKey: Const.NotificationsKey)}
    }
    
    var showHelperMessageNo1: Bool {
        get {return defaults.objectForKey(Const.helperMessageNo1) as? Bool ?? true}
        set {defaults.setObject(newValue, forKey: Const.helperMessageNo1)}
    }
    
    func updateUserInfoWithInfo(info: [String: AnyObject]) {
        userInfo = info
    }
}