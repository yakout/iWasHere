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
        
        Alamofire.request(.POST, "https://ec42e392.ngrok.io/register/", parameters: [
            "email": email ?? "",
            "password": pass ?? "",
            "name": name ?? ""
            ])
            .responseJSON { [weak self] response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                debugPrint(response)
                
                switch response.result {
                case .Success:
                    print("Validation Successful")
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        
                        User.currentUser.email = email
                        User.currentUser.name = name
                        // User.currentUser.token = JSON["token"]
                        
                        self?.performSegueWithIdentifier(Const.wallIdentifier, sender: nil)
                    }
                case .Failure(let error):
                    print(error)
                    let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
                    self?.showErrorView(errorMessage)
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
