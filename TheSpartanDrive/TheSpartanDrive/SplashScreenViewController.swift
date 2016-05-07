//
//  SplashScreenViewController.swift
//  TheSpartanDrive
//
//  Created by Manbir Randhawa on 5/2/16.
//  Copyright © 2016 CMPE137Group5. All rights reserved.
//

import UIKit
import Parse

class SplashScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "alreadyLoggedIN") {
            
            var currentUser = PFUser.currentUser()
            
            var vc = segue.destinationViewController as! UserProfilePageViewController
           // vc.currentUserr = currentUser!
            
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var currentUser = PFUser.currentUser()
        
        if currentUser != nil {
            //do stuff
            performSegueWithIdentifier("alreadyLoggedIn", sender: self)
            
        } else {
            //show signup or login
        }
    }
    
    
    
    
}
