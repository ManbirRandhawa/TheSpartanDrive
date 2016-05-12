//
//  SecondViewController.swift
//  TheSpartanDrive
//
//  Created by Manbir Randhawa on 5/2/16.
//  Copyright © 2016 CMPE137Group5. All rights reserved.
//

import UIKit
import Parse
import MessageUI
import Foundation

class BrowseViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var pickerView: UIPickerView!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var imagesByType = [PFObject]()
    
    @IBOutlet var longPressRecognizer: UILongPressGestureRecognizer!
    
    var imagetypes = String()
    
    var visitingThisUser = PFUser()
    
    @IBAction func usernameClicked(sender: AnyObject) {
     
    }
     var pickerDataSource = ["😁","😂", "😎", "🌅", "🏀", "🚗", "🍔"]
    
    @IBOutlet weak var usernameButton: UIButton!
  
    
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    
    func sendMessage(gameFile:PFFile) {
        
        if MFMessageComposeViewController.canSendText()
        {
            var messageVC = MFMessageComposeViewController()
            
            // let profileImageData = UIImageJPEGRepresentation((gameFile["Upload"])! as! UIImage, 0.5)
            
            messageVC.body = "Look at this S'more someone took on PicS'more!";
           
            messageVC.recipients = [""]
           
            
            gameFile.getDataInBackgroundWithBlock { (result, error) in
             
             let imageUp = UIImage(data:result!)
             
           messageVC.addAttachmentData(UIImageJPEGRepresentation(imageUp!, 0.3)!, typeIdentifier:"image/jpg", filename: "imagesend.jpg")
           
             
             }
             messageVC.messageComposeDelegate = self;
            
            
           
            presentViewController(messageVC, animated: true, completion: nil)
        } else {
            print("Error with texting!")
            let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
            errorAlert.show()
        }
        
        
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        switch (result) {
        case MessageComposeResultCancelled:
            print("Message was cancelled")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed:
            print("Message failed")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent:
            print("Message was sent")
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break;
        }
    }
    
    @IBAction func handleLongPress(sender: UILongPressGestureRecognizer) {
        
        if (sender.state == UIGestureRecognizerState.Began)
        {
            
            var p = sender.locationInView(self.tableView)
            
            if let indexPath = self.tableView.indexPathForRowAtPoint(p)
            {
                
                let cell = self.tableView(self.tableView, cellForRowAtIndexPath: indexPath)
                if (cell.highlighted)
                {
                    
                    let gameString = imagesByType[indexPath.row]
                    
                    print(gameString["imageName"] as! String)
                    
                   var imagestodisplay = imagesByType[indexPath.row]["Upload"] as! PFFile
                    
                    sendMessage(imagestodisplay)
                }
                
                
            }
            
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
       
        
        
        
    }
    
    enum smileys: String {
        case 😂 = "Funny"
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        imagetypes = "😁"
       
        getPicturesByType()
    }
    
     func getPicturesByType() -> [PFObject]
    {
         imagesByType = [PFObject]()
        if (imagetypes == "😁")
        {
            let query = PFQuery(className: "UserUploads")
           // query.whereKey("Type", equalTo: imagetypes)
            query.whereKey("Public", equalTo: true)
            query.orderByDescending("createdAt")
            query.findObjectsInBackgroundWithBlock{(imageuploads: [PFObject]?, error: NSError?) in
                
                if error == nil
                {
                    if let imageuploads = imageuploads {
                        for images in imageuploads {
                            
                            self.imagesByType.append(images)
                            
                            
                        }
                        
                        self.tableView.reloadData()
                    }
                    print(self.imagesByType.count)
                    
                }else{
                    print("no success")
                }
                
            }
        } else {
            let query = PFQuery(className: "UserUploads")
            query.whereKey("Type", equalTo: imagetypes)
            query.whereKey("Public", equalTo: true)
            query.orderByDescending("createdAt")
            query.findObjectsInBackgroundWithBlock{(imageuploads: [PFObject]?, error: NSError?) in
                
                if error == nil
                {
                    if let imageuploads = imageuploads {
                        for images in imageuploads {
                            
                            self.imagesByType.append(images)
                            
                            
                        }
                        
                        self.tableView.reloadData()
                    }
                    print(self.imagesByType.count)
                    
                }else{
                    print("no success")
                }
                
            }

        }
     
        return imagesByType
        
    }

  
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       
        return imagesByType.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! CustomBrowsePicCell
        
     
       cell.imageIndic.startAnimating()
        var username = imagesByType[indexPath.row]["Owner"] as! PFUser
        
        
        username.fetchIfNeededInBackgroundWithBlock { (object: PFObject?, error:NSError?) in
            cell.usernameButton.setTitle(username.username, forState: UIControlState.Normal)
            
        }
        
        
        var imagestodisplay = imagesByType[indexPath.row]["Upload"] as! PFFile
        
        imagestodisplay.getDataInBackgroundWithBlock { (result, error) in
            
            cell.displayImage?.image = UIImage(data:result!)
            cell.imageIndic.stopAnimating()
            cell.displayImage.contentMode = .ScaleAspectFit
            cell.displayImage.clipsToBounds = true
        }
        
       
      
       cell.usernameButton.tag = indexPath.row
        
        cell.usernameButton.addTarget(self, action: "userProfileAction:", forControlEvents: .TouchUpInside)
        
       // cell.usernameButton.setTitle(username.username, forState: UIControlState.Normal)
        
        
        return cell
    }
    
    @IBAction func userProfileAction(sender: UIButton)
    {
        
        let usernamestring = imagesByType[sender.tag]["Owner"] as! PFUser
        
        
       usernamestring.fetchIfNeededInBackgroundWithBlock {
        (object: PFObject?, error:NSError?) in
        
        let sharedPref = NSUserDefaults.standardUserDefaults()
        sharedPref.setValue(usernamestring.objectId!, forKey: "VisitingUserProfile")
            
            
        }
        
       
        
        
        performSegueWithIdentifier("visitUserProfile", sender: self)
        
    }
    
  
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return pickerDataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        imagetypes = pickerDataSource[row]
     
        
        getPicturesByType()
    self.tableView.reloadData()
        
    }



}

