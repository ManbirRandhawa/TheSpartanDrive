//
//  CustomBrowsePicCell.swift
//  TheSpartanDrive
//
//  Created by Manbir Randhawa on 5/4/16.
//  Copyright © 2016 CMPE137Group5. All rights reserved.
//

import UIKit

class CustomBrowsePicCell: UITableViewCell {
    
    @IBOutlet weak var displayImage: UIImageView!
    @IBOutlet weak var privacySettingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        displayImage.clipsToBounds = true
        displayImage.contentMode = .ScaleAspectFit
        //initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //configure the view for the selected state
    }
    
    
}
