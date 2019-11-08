//
//  SideMenuController.swift
//  junaid
//
//  Created by Administrator on 2019/10/25.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit
import Kingfisher

class SideMenuController: UIViewController {
    
    @IBOutlet weak var picView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var employeeCodeLabel: UILabel!
    
    @IBOutlet weak var scoreChartsButton: UIStackView!
    @IBOutlet weak var storesButton: UIStackView!
    @IBOutlet weak var trainingManualButton: UIStackView!
    @IBOutlet weak var customerFeedbackButton: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Profile Picture
        picView.layer.cornerRadius = picView.frame.width / 2
        picView.layer.masksToBounds = true
        
        let picUrl = SettingManager.sharedInstance.profilePic
        if !picUrl.isEmpty {
            picView.kf.setImage(with: URL(string: Constants.API.MAIN_URL + "/" + picUrl)!)
        }
        
        // Full Name
        fullNameLabel.text = SettingManager.sharedInstance.fullName
        
        // Employee Code
        employeeCodeLabel.text = SettingManager.sharedInstance.employeeCode
        
        let tapScoreCharts = UITapGestureRecognizer(target: self, action: #selector(onScoreCharts))
        scoreChartsButton.addGestureRecognizer(tapScoreCharts)
        
        let tapStores = UITapGestureRecognizer(target: self, action: #selector(onStores))
        storesButton.addGestureRecognizer(tapStores)
        
        let tapTrainingManual = UITapGestureRecognizer(target: self, action: #selector(onTrainingManual))
        trainingManualButton.addGestureRecognizer(tapTrainingManual)
        
        let tapCustomerFeedback = UITapGestureRecognizer(target: self, action: #selector(onCustomerFeedback))
        customerFeedbackButton.addGestureRecognizer(tapCustomerFeedback)
    }
    
    @objc func onScoreCharts() {
        let scoreChartVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScoreChartController") as! ScoreChartController
        self.present(UINavigationController.init(rootViewController: scoreChartVC), animated: true)
    }
    
    @objc func onStores() {
        let storeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CountryController") as! CountryController
        self.present(UINavigationController.init(rootViewController: storeVC), animated: true)
    }
    
    @objc func onTrainingManual() {
        
    }
    
    @objc func onCustomerFeedback() {
        let feedbackVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedbackController") as! FeedbackController
        self.present(UINavigationController.init(rootViewController: feedbackVC), animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
