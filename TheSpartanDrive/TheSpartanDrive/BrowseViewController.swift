//
//  SecondViewController.swift
//  TheSpartanDrive
//
//  Created by Manbir Randhawa on 5/2/16.
//  Copyright © 2016 CMPE137Group5. All rights reserved.
//

import UIKit
import Parse

class BrowseViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var imagesByType = [PFObject]()
    
    var imagetypes = String()
    
     var pickerDataSource = ["Funny", "Cool", "Artistic", "Sports", "Cars", "Food"]
    
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
    }
    
     func getPicturesByType() -> [PFObject]
    {
         imagesByType = [PFObject]()
        
        let query = PFQuery(className: "UserUploads")
        query.whereKey("Type", equalTo: imagetypes)
        query.whereKey("Public", equalTo: true)
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
        
        imagestodisplay.getDataInBackgroundWithBlock { (result, error) in
            
            cell.displayImage?.image = UIImage(data:result!)
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
        getPicturesByType()
        self.tableView.reloadData()
        
    }



}

