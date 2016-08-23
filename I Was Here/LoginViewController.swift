//
//  LoginViewController.swift
//  iWasHere
//
//  Created by Ahmed Yakout on 8/11/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import UIKit
// import QuartzCore
import Firebase


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Constants
    
    let loginToWall = "loginToWall"
    let user = User.user
    
    
    // MARK: Outlets
    
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    
    
    // MARK: Actions
    
    @IBAction func loginDidTouch(sender: AnyObject?) {
        let email = textFieldLoginEmail.text!
        let pass = textFieldLoginPassword.text!
        FIRAuth.auth()?.signInWithEmail(email, password: pass) { [weak self]
            (auth, error) in
            if error != nil {
                // print(error)
                self?.showErrorView(error!)
            } else if let uid = auth?.uid {
                print("LoginViewController: user logged in with id \(uid)")
                self?.performSegueWithIdentifier(self!.loginToWall, sender: nil)
            }
        }
    }
    
    
    // MARK: - UITextFieldDelegate Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == textFieldLoginEmail {
            textFieldLoginPassword.becomeFirstResponder()
        } else if textField == textFieldLoginPassword {
            textFieldLoginPassword.resignFirstResponder()
            self.loginDidTouch(nil)
        }
        return true
    }
    
    
    // MARK: UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldLoginEmail.delegate = self
        self.textFieldLoginPassword.delegate = self
        textFieldLoginEmail.becomeFirstResponder()
        
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            // print("User is signed in with uid:", uid)
            user.setData((FIRAuth.auth()?.currentUser)!)
            performSegueWithIdentifier(self.loginToWall, sender: nil)
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //        FIRAuth.auth()!.addAuthStateDidChangeListener() { (auth, user) in
        //            if let user = user {
        //                print("User is signed in with uid:", user.uid)
        //                // self.performSegueWithIdentifier(self.loginToWall, sender: nil)
        //            } else {
        //                print("no user signed in")
        //            }
        //        }
    }
    
}

