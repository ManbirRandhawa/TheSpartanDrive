//
//  FirstViewController.swift
//  TheSpartanDrive
//
//  Created by Manbir Randhawa on 5/2/16.
//  Copyright © 2016 CMPE137Group5. All rights reserved.
//

import UIKit
import Parse

class UserViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var currentUser = PFUser.currentUser()
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    var profilePicAvailable = Bool()

    @IBOutlet weak var profileLabel: UILabel!
    @IBAction func profilePictureUpload(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.contentMode = .ScaleAspectFill
            profileImageView.image = pickedImage
            profileImageView.clipsToBounds = true
            
            let profileImageData = UIImageJPEGRepresentation(profileImageView.image!, 0.5)
            
            if (profileImageData != nil)
            {
                let profileImageFile = PFFile(data: profileImageData!)
                currentUser?.setObject(profileImageFile!, forKey: "profilePicture")
                currentUser?.saveInBackground()
                print("SUCCESSFUL IMAGE UPLOAD")
            }
            else {
                print("ERROR SAVING IMAGE TO PARSE")
            }
            
            
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func queryProfilePicture()
    {
        if currentUser != nil
        {
            var userQuery = PFUser.query()
            userQuery!.whereKey("objectId", equalTo: currentUser!.objectId!)
            userQuery!.findObjectsInBackgroundWithBlock {
                (object:[PFObject]?, error:NSError?) in
                
                if error == nil {
                    
                                        
                    if let imagedisplay = object?[0]["profilePicture"] as? PFFile
                    {
                        imagedisplay.getDataInBackgroundWithBlock { (result, error) in
                            if (error == nil)
                            {
                                print("PROFILE IMAGE AVAILABLE")
                                self.profileImageView.contentMode = .ScaleAspectFill
                                self.profileImageView.image = UIImage(data: result!)
                                self.profileImageView.clipsToBounds = true
                                
                            }else {
                                print("NO profile IMAGE")
                                self.profileImageView.backgroundColor = UIColor.brownColor()
                            }
                        }
                    }
                    
                    
                    
                }
                else {
                    print("Error")
                }
                
            }
            
        } else {
            print("current user is nil...")
        }
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "imageTapped:")
        tapGesture.numberOfTapsRequired = 1
        profileImageView.userInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGesture)
     
        profileLabel.text = currentUser?.username
        
        
        if currentUser != nil
        {
            queryProfilePicture()
        } else {
            print("NO USER LOGGEDIN")
        }
        
    }
    
    
   
    
    func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if let profileImageView = gesture.view as? UIImageView {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .PhotoLibrary
            
            presentViewController(imagePicker, animated: true, completion: nil)
            //Here you can initiate your new ViewController
            
        }
    }

    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    @IBAction func logUserOut(sender: AnyObject) {
        PFUser.logOut()
        performSegueWithIdentifier("userLoggedOut", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

