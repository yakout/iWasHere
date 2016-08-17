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
// import FirebaseAuth

class LoginViewController: UIViewController {
    
    // MARK: Constants
    let loginToWall = "loginToWall"
    
    // MARK: Outlets
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    // MARK: Properties
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            print("User is signed in with uid:", uid)
            User.user = User(authData: (FIRAuth.auth()?.currentUser)!)
            self.performSegueWithIdentifier(self.loginToWall, sender: nil)
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
    
    // MARK: Actions
    @IBAction func loginDidTouch(sender: AnyObject) {
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
}

