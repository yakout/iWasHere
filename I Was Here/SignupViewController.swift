//
//  SignupViewController.swift
//  iWasHere
//
//  Created by Ahmed Yakout on 8/11/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import UIKit
import Alamofire

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Constants
    struct  Const {
        static let wallIdentifier = "signupToWall"
    }
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    // MARK: - Actions
    
    @IBAction func signup(sender: UIButton?) {
        let name = nameField.text
        let email = emailField.text
        let pass = passwordField.text
        
        Alamofire.request(.POST, "\(url)/register/", parameters: [
            "email": email ?? "",
            "password": pass ?? "",
            "name": name ?? ""
            ])
            .responseJSON { [weak self] response in
                debugPrint(response)
                
                switch response.result {
                case .Success:
                    if let JSON = response.result.value as? [String: AnyObject] {
                        
                        User.currentUser.email = email
                        User.currentUser.uid = JSON["id"] as? String
                        User.currentUser.isList = (JSON["listViewMode"] as? String) == "0" ? false : true
                        User.currentUser.name = JSON["name"] as? String
                        User.currentUser.token = JSON["token"] as? String
                        User.currentUser.profileImageUrl = JSON["profilePicture"] as? String
                        
                        self?.performSegueWithIdentifier(Const.wallIdentifier, sender: nil)
                    } else {
                        print(String(data: response.data!, encoding: NSUTF8StringEncoding))
                        self?.showErrorView(String(data: response.data!, encoding: NSUTF8StringEncoding))
                    }
                case .Failure(let error):
                    print(error)
                    let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
                    self?.showErrorView(errorMessage)
                    
                    print(String(data: response.data!, encoding: NSUTF8StringEncoding))
                    self?.showErrorView(String(data: response.data!, encoding: NSUTF8StringEncoding))
                }
        }
        
        
    }
    
    
    // MARK: - Methods
    
    
    // MARK: - UITextFieldDelegate Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == nameField {
            emailField.becomeFirstResponder()
        } else if textField == emailField {
            emailField.resignFirstResponder()
            passwordField.becomeFirstResponder()
        } else {
            passwordField.resignFirstResponder()
            self.signup(nil)
        }
        return true
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameField.delegate = self
        self.emailField.delegate = self
        self.passwordField.delegate = self
        nameField.becomeFirstResponder()
    }
    
}
