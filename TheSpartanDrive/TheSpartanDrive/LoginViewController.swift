//
//  LoginViewController.swift
//  TheSpartanDrive
//
//  Created by Manbir Randhawa on 5/2/16.
//  Copyright © 2016 CMPE137Group5. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import ParseFacebookUtilsV4

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.usernameLabel.delegate = self
        self.passwordLabel.delegate=self
       
        
        }
    
    
    @IBAction func FBAction(sender: AnyObject) {
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func loginButton(sender: AnyObject) {
        var username = usernameLabel.text
        var password = passwordLabel.text
        
        if username != "" && password != ""
        {
            login()
        } else {
            
            print("empty field, all fields required!")
        }
        
        
    }
    
    func login()
    {
        var username = usernameLabel.text
        var password = passwordLabel.text
        
        PFUser.logInWithUsernameInBackground(username!, password:password!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
                print("Succesful login!")
                self.performSegueWithIdentifier("successfulLogin", sender: self)
                
            } else {
                // The login failed. Check error to see why.
                print("Error logging in, check pass/email")
            }
        }
    }
    

}
