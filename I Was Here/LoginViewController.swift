//
//  LoginViewController.swift
//  iWasHere
//
//  Created by Ahmed Yakout on 8/11/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import UIKit
import Alamofire

// url = "https://ec42e392.ngrok.io"
let userDefaults = UserDefaults()


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Constants
    struct Const {
        static let loginToWall = "loginToWall"
    }

    // MARK: Outlets
    
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    
    
    // MARK: Actions
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func loginDidTouch(sender: AnyObject?) {
        let email = textFieldLoginEmail.text
        let pass = textFieldLoginPassword.text
        
        Alamofire.request(.POST, "https://ec42e392.ngrok.io/login", parameters: [
            "email": email ?? "",
            "password": pass ?? ""
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
                        let folders = JSON["folders"] as? [AnyObject] ?? []
                        let foldersCount = JSON["foldersCount"] as! Int
                        
                        debugPrint(User.currentUser.token)
                        debugPrint(folders, foldersCount)
                        
                        var places = [Place]()
                        for i in 0 ..< foldersCount {
                            let folder = folders[i] as? [String : AnyObject] ?? [:]
                            let placeName = folder["folderName"] as? String
                            let imagesCount = folder["imagesCount"] as! Int
                            let images = folder["images"] as? [AnyObject] ?? []
                            
                            var memories = [Memory]()
                            for j in 0 ..< imagesCount {
                                let image = images[j] as? [String: AnyObject] ?? [:]
                                let imageName = image["imageName"] as? String
                                let imageDescription = image["imageDescription"] as? String
                                let imageExtension = image["imageExtension"] as? String
                                
                                let memory = Memory(name: imageName, description: imageDescription, addedByUser: email, imageExtension: imageExtension)
                                memories.append(memory)
                            }
                            
                            let place = Place(name: placeName , memories: memories, count: foldersCount)
                            places.append(place)
                        }
                        
                        User.currentUser.places = places
                        
                        self?.performSegueWithIdentifier(Const.loginToWall, sender: nil)
                    } else {
                        self?.showErrorView(response.result.value as? String)
                    }
                case .Failure(let error):
                    print(error)
                    let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
                    self?.showErrorView(errorMessage)
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
        
        User.currentUser.uid =  userDefaults.userInfo["id"] as? String
        User.currentUser.profileImageUrl = userDefaults.userInfo["profilePictureUrl"] as? String
        User.currentUser.token = userDefaults.userInfo["token"] as? String
        User.currentUser.email = userDefaults.userInfo["email"] as? String
        User.currentUser.name = userDefaults.userInfo["name"] as? String
        
        let foo = userDefaults.userInfo
        
        if let token = User.currentUser.token where token != "" {
            print("user already signed in with email go directly to home")
            self.view.hidden = true
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier(Const.loginToWall, sender: nil)
            }
        }
        
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}

