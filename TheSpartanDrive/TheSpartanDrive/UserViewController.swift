//
//  FirstViewController.swift
//  TheSpartanDrive
//
//  Created by Manbir Randhawa on 5/2/16.
//  Copyright © 2016 CMPE137Group5. All rights reserved.
//

import UIKit
import Parse
import Foundation

class UserViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    var currentUser = PFUser.currentUser()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    var profilePicAvailable = Bool()
    
      var commentss = [PFObject]()
    
      var commentsArray = [String]()
    
    @IBOutlet weak var postText: MKTextField!
    
    var deleteCommentAlert : UIAlertController?
   
    @IBAction func postCommentButton(sender: AnyObject) {
        
        //let sharedPref = NSUserDefaults.standardUserDefaults()
        //let userYouAreVisiting = sharedPref.valueForKey("VisitingUserProfile")
        
        var newComment = PFObject(className:"ProfileComments")
        newComment["UserProfile"] = currentUser
        newComment["PosterOfUserComment"] = currentUser
        newComment["Comment"] = postText.text
        newComment.saveInBackgroundWithBlock { (true:Bool, error:NSError?) in
            if (true)
            {
                let successAlert = UIAlertView(title: "Post successful!", message: "Comment successful!", delegate: self, cancelButtonTitle: "OK")
                successAlert.show()
                self.postText.text = ""
                self.queryForComments(self.currentUser!)
                self.tableView.reloadData()
                
            } else {
                let errorAlert = UIAlertView(title: "Cannot Post Comment", message: "Try again!", delegate: self, cancelButtonTitle: "OK")
                errorAlert.show()
            }
        }
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
       
        self.view.endEditing(true)
        return false
    }
    

    @IBOutlet weak var profileLabel: UILabel!
    @IBAction func profilePictureUpload(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func queryForComments(host:PFUser) -> [PFObject]
    {
        print(host)
        print("PRINTED I QUERY FOR COMMENTS")
        commentss = [PFObject]()
        
        var query = PFQuery(className: "ProfileComments")
        print("Step1")
        query.whereKey("UserProfile", equalTo: host)
        print("Step2")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (comments:[PFObject]?, error:NSError?) in
            if (error == nil)
            {
                print("SUCEZZZZZ")
                if let commentsz = comments{
                    for comment in commentsz {
                        print("Step3")
                        self.commentss.append(comment)
                        
                    }
                    self.tableView.reloadData()
                    
                }
                print(self.commentss.count)
                
            } else {
                print("error getting comments")
            }
        }
        
        
        return commentss
        
    }

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentss.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath) as! CustomBrowsePicCell
        
        cell.commentLabelBoxProfilePage.text = commentss[indexPath.row]["Comment"] as! String
        
        var userWhoPosted = commentss[indexPath.row]["PosterOfUserComment"] as! PFUser
        
        userWhoPosted.fetchIfNeededInBackgroundWithBlock { (object:PFObject?, error:NSError?) in
            cell.usernameButtonProfilePage.setTitle(userWhoPosted.username!, forState: UIControlState.Normal)
            print (userWhoPosted.username)
            print("now")
            print(self.currentUser!.username)
            
            if (userWhoPosted.username == self.currentUser!.username)
            {
                cell.deleteCommentProfilePage.hidden = false
            } else {
                cell.deleteCommentProfilePage.hidden = true
            }
            
            
        }
        
        cell.deleteCommentProfilePage.tag = indexPath.row
        
        cell.deleteCommentProfilePage.addTarget(self, action: "deleteCommentAction:", forControlEvents: .TouchUpInside)
        
        
        cell.usernameButtonProfilePage.tag = indexPath.row
        
        cell.usernameButtonProfilePage.addTarget(self, action: "userProfileAction:", forControlEvents: .TouchUpInside)
        
        
        return cell

        
    }
    
    @IBAction func userProfileAction(sender: UIButton)
    {
        
        let usernamestring = commentss[sender.tag]["PosterOfUserComment"] as! PFUser
        
        
        usernamestring.fetchIfNeededInBackgroundWithBlock {
            (object: PFObject?, error:NSError?) in
            
            let sharedPref = NSUserDefaults.standardUserDefaults()
            sharedPref.setValue(usernamestring.objectId!, forKey: "VisitingUserProfile")
            
            
        }
        
        
        
        
        performSegueWithIdentifier("visitUserProfile1", sender: self)
        
    }
    
    
    
    @IBAction func deleteCommentAction(sender: UIButton)
    {
        
        
        deleteCommentAlert = UIAlertController(title: "PicS'more", message: "Delete this comment?", preferredStyle: .Alert)
        
        
        let yesAction = UIAlertAction(title: "Yes", style: .Default) { (action) in
            
            let deleteThisComment = self.commentss[sender.tag]
            
            
            deleteThisComment.fetchIfNeededInBackgroundWithBlock {
                (object: PFObject?, error:NSError?) in
                
                deleteThisComment.deleteInBackgroundWithBlock({ (true, error) in
                    if (true)
                    {
                        let successAlert = UIAlertView(title: "PicS'more", message: "Deleted!", delegate: self, cancelButtonTitle: "OK")
                        successAlert.show()
                        self.queryForComments(self.currentUser!)
                    }
                    else {
                        let errorAlert = UIAlertView(title: "PicS'more", message: "Error Deleting!", delegate: self, cancelButtonTitle: "OK")
                        errorAlert.show()
                    }
                })
                
                
            }
            
        }
        
        let noAction = UIAlertAction(title: "No", style: .Default) { (action) in
            
            
        }
        
        deleteCommentAlert?.addAction(yesAction)
        deleteCommentAlert?.addAction(noAction)
        
        presentViewController(deleteCommentAlert!, animated: true) { 
            
        }
        
        
        
        

        
        
        
        
        
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
        self.postText.delegate = self
        
        queryForComments(currentUser!)
        
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

