//
//  RegisterViewController.swift
//  TheSpartanDrive
//
//  Created by Manbir Randhawa on 5/2/16.
//  Copyright © 2016 CMPE137Group5. All rights reserved.
//

import UIKit
import Parse

class RegisterViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var passwordAgainLabel: UITextField!
    
    var passwordsNotSameAlertController: UIAlertController?
   
    @IBOutlet weak var emailLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.nameLabel.delegate = self
        self.usernameLabel.delegate=self
        self.emailLabel.delegate = self
        self.passwordLabel.delegate=self
        self.passwordAgainLabel.delegate=self
        setUpPasswordAlert()
        
    }
    
    func setUpPasswordAlert()
    {
        
        passwordsNotSameAlertController = UIAlertController(title: "Error", message: "Passwords do not match!", preferredStyle: .Alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .Default) { (action) in
          
        }
      
        passwordsNotSameAlertController?.addAction(okayAction)
        
    }
    @IBAction func registerButton(sender: AnyObject) {
        
        var username = usernameLabel.text
        var pass1 = passwordLabel.text
        var name = nameLabel.text
        var pass2 = passwordAgainLabel.text
        var email = emailLabel.text
        
        if username != "" && pass1 != "" &&  name != "" && pass2 != "" && email != ""
        {
             //no blank fields, proceed to sign up
            if (pass1 == pass2)
            {
                signUp()
            }
            else {
                self.presentViewController(passwordsNotSameAlertController!, animated: true) {
                    
                }
            }
            
            
        }
        else{
            print("error, empty fields")
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField {
        case nameLabel:
            nameLabel.becomeFirstResponder()
        case usernameLabel:
            usernameLabel.becomeFirstResponder()
        case emailLabel:
            emailLabel.becomeFirstResponder()
        case passwordLabel:
            passwordLabel.becomeFirstResponder()
        case passwordAgainLabel:
            passwordAgainLabel.becomeFirstResponder()
        default:
            break
        }
        self.view.endEditing(true)
        return false
    }
    
   
    func signUp() {
        var username = usernameLabel.text
        var pass1 = passwordLabel.text
        var name = nameLabel.text
        var pass2 = passwordAgainLabel.text
        var email = emailLabel.text
        
        var newUser = PFUser()
        newUser.username = username
        newUser.email = email
        newUser.password = pass1
        newUser["Name"] = name
        
        
        
        newUser.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                print(errorString)
            } else {
                // Hooray! Let them use the app now.
                print("succesfully registered!")
                
                //success, take user to APP
                self.performSegueWithIdentifier("successfulRegistration", sender: self)
                
            }
        }
    }
    
    

}
