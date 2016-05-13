//
//  ForgotPassViewController.swift
//  TheSpartanDrive
//
//  Created by Manbir Randhawa on 5/12/16.
//  Copyright © 2016 CMPE137Group5. All rights reserved.
//

import Foundation
import Parse
import UIKit

class ForgotPassViewController: UIViewController, UITextFieldDelegate {
    
    @IBAction func resetPass(sender: AnyObject) {
        
        var email = emailField.text

        if (email != "")
        {
             PFUser.requestPasswordResetForEmailInBackground(email!)
            let errorAlert = UIAlertView(title: "PicS'more", message: "If this email exists, a reset email has been sent!", delegate: self, cancelButtonTitle: "OK")
            errorAlert.show()
        }
       
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBOutlet weak var emailField: KaedeTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailField.delegate = self 
        
        
    }
}