//
//  UserUploadHistoryViewController.swift
//  TheSpartanDrive
//
//  Created by Manbir Randhawa on 5/4/16.
//  Copyright © 2016 CMPE137Group5. All rights reserved.
//

import UIKit
import Parse
import Foundation
import MessageUI

class UserUploadHistoryViewController : UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate  {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var privacyLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var imagesByType = [PFObject]()
    
    var privacyLevels = [String]()
    
    var imagetypes = String()
    
    var pickerDataSource = ["Public", "Private", "Both"]
    
    @IBOutlet var longPressRecognizer: UILongPressGestureRecognizer!
    var currentUser = PFUser.currentUser()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
    }
    
    func sendMessage(gameFile:PFFile) {
        
        if MFMessageComposeViewController.canSendText()
        {
            var messageVC = MFMessageComposeViewController()
            
            // let profileImageData = UIImageJPEGRepresentation((gameFile["Upload"])! as! UIImage, 0.5)
            
            messageVC.body = "Look at this S'more I uploaded to PicS'more!";
            
            messageVC.recipients = [""]
            
            
            gameFile.getDataInBackgroundWithBlock { (result, error) in
                
                let imageUp = UIImage(data:result!)
                
                messageVC.addAttachmentData(UIImageJPEGRepresentation(imageUp!, 0.3)!, typeIdentifier:"image/jpg", filename: "imagesend.jpg")
                
                
            }
            messageVC.messageComposeDelegate = self;
            
            
            
            //controller.addAttachmentData(UIImageJPEGRepresentation(UIImage(named: "images.jpg")!, 1)!, typeIdentifier: "image/jpg", filename: "images.jpg") - See more at: http://www.theappguruz.com/blog/social-messageui-framework-swift#sthash.CGsTtftH.dpuf
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
    
    //Get all Public uploads
    func getPicturesByTypePublic() -> [PFObject]
    {
        imagesByType = [PFObject]()
        print(currentUser)
        
        let query = PFQuery(className: "UserUploads")
       query.whereKey("Owner", equalTo: PFUser.currentUser()!)
        print("step1")
       
        query.whereKey("Public", equalTo: true)
        print("step3")
        query.findObjectsInBackgroundWithBlock{(imageuploads: [PFObject]?, error: NSError?) in
            
            if error == nil
            {
                print("step4")
                if let imageuploads = imageuploads {
                    for images in imageuploads {
                        
                        print("step5")
                        self.imagesByType.append(images)
                        
                        
                    }
                    
                    self.tableView.reloadData()
                }
                print(self.imagesByType.count)
                
            }else{
                print("no success")
            }
            
        }
        
        return imagesByType
        
    }
    
    //Get all Private Upload
    func getPicturesByTypePrivate() -> [PFObject]
    {
        imagesByType = [PFObject]()
        print(currentUser)
        
        let query = PFQuery(className: "UserUploads")
        query.whereKey("Owner", equalTo: PFUser.currentUser()!)
        
        query.whereKey("Public", equalTo: false)
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
        
        return imagesByType
        
    }
    
    
    //Get all Uploads by User
    func getAllPicturesByUser() -> [PFObject]
    {
        imagesByType = [PFObject]()
        print(currentUser)
        
        let query = PFQuery(className: "UserUploads")
        query.whereKey("Owner", equalTo: PFUser.currentUser()!)
        
        
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
        
        return imagesByType
        
    }

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return imagesByType.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! CustomBrowsePicCell
        
        
        
        
        var imagestodisplay = imagesByType[indexPath.row]["Upload"] as! PFFile
        let privacyLvl = imagesByType[indexPath.row]["Public"] as! Bool
        
        imagestodisplay.getDataInBackgroundWithBlock { (result, error) in
            
            cell.displayImage?.image = UIImage(data:result!)
        }
        if privacyLvl
        {
            cell.privacySettingLabel.text = "Public"
        } else {
            cell.privacySettingLabel.text = "Private"
        }
        
        cell.deletePicButton.tag = indexPath.row
        
        cell.deletePicButton.addTarget(self, action: "deletePicAction:", forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    
    @IBAction func deletePicAction(sender: UIButton)
    {
        
        
        let deleteThisImage = imagesByType[sender.tag]
        
        
        deleteThisImage.fetchIfNeededInBackgroundWithBlock {
            (object: PFObject?, error:NSError?) in
            
            deleteThisImage.deleteInBackgroundWithBlock({ (true, error) in
                if (true)
                {
                    let successAlert = UIAlertView(title: "PicS'more", message: "Deleted!", delegate: self, cancelButtonTitle: "OK")
                    successAlert.show()
                    
                    if (self.imagetypes == "Public")
                    {
                        print("public")
                        self.getPicturesByTypePublic()
                    } else if (self.imagetypes == "Private") {
                        print("private")
                        self.getPicturesByTypePrivate()
                    } else {
                        print("private & public")
                        self.getAllPicturesByUser()
                    }
                    self.tableView.reloadData()
                }
                else {
                    let errorAlert = UIAlertView(title: "PicS'more", message: "Error Deleting!", delegate: self, cancelButtonTitle: "OK")
                    errorAlert.show()
                }
            })
            
            
        }
        
        
        
        
     
        
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
        if (imagetypes == "Public")
        {
            print("public")
            getPicturesByTypePublic()
        } else if (imagetypes == "Private") {
            print("private")
            getPicturesByTypePrivate()
        } else {
            print("private & public")
            getAllPicturesByUser()
        }
        self.tableView.reloadData()
        
    }
    
    
    
    
}
