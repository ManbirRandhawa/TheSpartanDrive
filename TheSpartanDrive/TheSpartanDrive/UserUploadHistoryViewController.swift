//
//  UserUploadHistoryViewController.swift
//  TheSpartanDrive
//
//  Created by Manbir Randhawa on 5/4/16.
//  Copyright © 2016 CMPE137Group5. All rights reserved.
//

import UIKit
import Parse

class UserUploadHistoryViewController : UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var privacyLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var imagesByType = [PFObject]()
    
    var privacyLevels = [String]()
    
    var imagetypes = String()
    
    var pickerDataSource = ["Public", "Private", "Both"]
    
    var currentUser = PFUser.currentUser()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
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
        
        return cell
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
