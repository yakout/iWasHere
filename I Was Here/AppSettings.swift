//
//  AppSettings.swift
//  iWasHere
//
//  Created by Ahmed Yakout on 8/18/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import Foundation


// ++++++++++++++++++++ WARNINIG: DEPRECATED CLASS, WE DON'T NEED IT ANYMORE. THANKS FOR BEING A GOOD CLASS FOR OUR CLIENTS ++++++++++++++++++++

class AppSettings {
    private struct Const {
        static let notification = "enableNotifications.Values"
        static let viewMode = "viewMode.Values"
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    private var pushNotification: Bool {
        get { return defaults.objectForKey(Const.notification) as? Bool ?? true }
        set { defaults.setObject(newValue, forKey: Const.notification) }
    }
    
    private var isList: Bool {
        get { return defaults.objectForKey(Const.viewMode) as? Bool ?? true }
        set { defaults.setObject(newValue, forKey: Const.viewMode) }
    }
    
    enum Settings {
        case NotificationIsEnabled
        case ListViewIsEnabled
    }
    
    // MARK: Methods
    
    func set(option: Settings, value: AnyObject) {
        switch option {
        case .NotificationIsEnabled:
            self.pushNotification = (value as? Bool) ?? true
        case .ListViewIsEnabled:
            self.isList = (value as? Bool) ?? true
        }
    }
    
    func get(option: Settings) -> AnyObject {
        switch option {
        case .NotificationIsEnabled:
            return pushNotification
        case .ListViewIsEnabled:
            return isList
        }
    }
    
}
