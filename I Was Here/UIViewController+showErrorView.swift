//
//  UIViewController+showErrorView.swift
//  iWasHere
//
//  Created by Ahmed Yakout on 8/10/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorView(error: NSError) {
        if let errorMessage = error.userInfo["NSLocalizedDescription"] as? String {
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
}
