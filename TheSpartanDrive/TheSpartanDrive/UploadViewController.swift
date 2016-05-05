//
//  UploadViewController.swift
//  TheSpartanDrive
//
//  Created by Manbir Randhawa on 5/2/16.
//  Copyright © 2016 CMPE137Group5. All rights reserved.
//

import UIKit
import Parse
import FileBrowser

class UploadViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    let imagePicker = UIImagePickerController()
    var currentUser = PFUser.currentUser()
    
    @IBOutlet weak var imageName: UITextField!
    var imagetypes = String()
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var PublicSwitch: UISwitch!
    
    @IBAction func selectBrowserFile(sender: AnyObject) {
        
        let fileBrowser = FileBrowser()
        
        self.presentViewController(fileBrowser, animated: true, completion: nil)
    }
   
    
    
    var pickerDataSource = ["Funny", "Cool", "Artistic", "Sports", "Cars", "Food"]
    
    @IBAction func UploadFile(sender: AnyObject) {
        
        
       let profileImageData = UIImageJPEGRepresentation((imageView.image)!, 0.5)
        
        if (profileImageData != nil)
        {
            let profileImageFile = PFFile(data: profileImageData!)
            
            var newUpload = PFObject(className:"UserUploads")
            newUpload["Upload"] = profileImageFile
            newUpload["Owner"] = currentUser
            newUpload["imageName"] = imageName.text
            newUpload["Type"] = imagetypes
            if PublicSwitch.on {
                newUpload["Public"] = true
            } else {
                newUpload["Public"] = false
            }
            
            newUpload.saveInBackground()
            
            print("SUCCESSFUL IMAGE UPLOAD")
            clearEverything()
        }
        else {
            print("ERROR SAVING IMAGE TO PARSE")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       pickerView.delegate = self
        pickerView.dataSource = self
        imagePicker.delegate = self
        
       
        
      
    }
    
    
    func clearEverything()
    {
        imageView.image = nil
        pickerView.selectRow(0, inComponent: 0, animated: true)
        imageName.text = ""
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
        print(imagetypes)
    }
    
    
    @IBAction func selectFile(sender: AnyObject) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)

    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
            
        
            
            
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
}
