//
//  SettingsController.swift
//  junaid
//
//  Created by Administrator on 2019/10/26.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {
    
    fileprivate let sections = [2, 2, 1]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
        
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if indexPath.section == 0 {
            let tabBarVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
            appDelegate.window?.rootViewController = tabBarVC
            
            if indexPath.row == 0 {
                tabBarVC.selectedIndex = 4 // Profile Tab
            } else {
                tabBarVC.selectedIndex = 3 // Notifications Tab
            }
            
            appDelegate.window?.rootViewController = tabBarVC
        
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                
            } else {
                let feedbackVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedbackController") as! FeedbackController
                self.present(UINavigationController.init(rootViewController: feedbackVC), animated: true)
            }
        } else if indexPath.section == 2 && indexPath.row == 0 {
            let logoutAlert = UIAlertController(title: APP_NAME, message: "Are you sure to log out?".localized(), preferredStyle: .alert)
            
            logoutAlert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: { (action: UIAlertAction!) in
                
                SettingManager.sharedInstance.clearProfile()
                
                let loginVC = UIStoryboard.init(name: "Startup", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginController") as! LoginController
                let navigationController = UINavigationController.init(rootViewController: loginVC)
                appDelegate.window?.rootViewController = navigationController
            }))
            
            logoutAlert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: { (action: UIAlertAction!) in
                print("Cancel deactivate!")
            }))
            
            self.present(logoutAlert, animated: true, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
