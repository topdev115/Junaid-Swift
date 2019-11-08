//
//  ProfileController.swift
//  junaid
//
//  Created by Administrator on 2019/10/27.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileController: UIViewController {

    @IBOutlet weak var picImageView: UIImageView!
    @IBOutlet var infoLabels: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Profile Picture
        let picUrl = SettingManager.sharedInstance.profilePic
        if !picUrl.isEmpty {
            picImageView.kf.setImage(with: URL(string: Constants.API.MAIN_URL + "/" + picUrl)!)
        }
        
        infoLabels[0].text = SettingManager.sharedInstance.fullName
        infoLabels[1].text = SettingManager.sharedInstance.employeeCode
        infoLabels[2].text = SettingManager.sharedInstance.role
        
        infoLabels[3].text = SettingManager.sharedInstance.email
        infoLabels[4].text = SettingManager.sharedInstance.mobileNumber
        infoLabels[5].text = SettingManager.sharedInstance.doj
        infoLabels[6].text = "Store Location : " + SettingManager.sharedInstance.storeName
        infoLabels[7].text = "Country : " + SettingManager.sharedInstance.countryName
    }
    
    @IBAction func onChoosePhoto(_ sender: UIButton) {
        ImagePickerManager().pickImage(self){ image in
            self.picImageView.image = image
        }
    }
}
