//
//  TabBarController.swift
//  junaid
//
//  Created by Administrator on 2019/10/22.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit

import FirebaseCore
import FirebaseAnalytics
import FirebaseInstanceID
import FirebaseMessaging

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        if (iApp.sharedInstance.getFcmRegId().count == 0) {
            
            print("Set Device Token")
            
            self.setDeviceToken()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateBadges), name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
        
        updateBadges();
        
        getSettings();
    }
    
    func connectToFcm() {
        
//        Messaging.messaging().connect { (error) in
//
//            if error != nil {
//
//                print("Unable to connect with FCM.")
//
//            } else {
//
//                print("Connected to FCM.")
//
//                if let refreshedToken = FIRInstanceID.instanceID().token() {
//
//                    iApp.sharedInstance.setFcmRegId(ios_fcm_regid: refreshedToken);
//
//                    self.setDeviceToken()
//                }
//            }
//        }
    }
    
    @objc func updateBadges() {
        
        print("update badges notify")
        
        if (iApp.sharedInstance.getNotificationsCount() > 0) {
            
            self.tabBar.items?[2].badgeValue = String(iApp.sharedInstance.getNotificationsCount())
            
        } else {
            
            self.tabBar.items?[2].badgeValue = nil
        }
        
        if (iApp.sharedInstance.getMessagesCount() > 0) {
            
            self.tabBar.items?[3].badgeValue = String(iApp.sharedInstance.getMessagesCount())
            
        } else {
            
            self.tabBar.items?[3].badgeValue = nil
        }
    }
    
    func setDeviceToken() {
        
//        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_SET_DEVICE_TOKEN)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
//        request.httpMethod = "POST"
//        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&ios_fcm_regId=" + iApp.sharedInstance.getFcmRegId();
//        request.httpBody = postString.data(using: .utf8)
//
//        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
//
//            if error != nil {
//
//                print(error!.localizedDescription)
//
//            } else {
//
//                do {
//
//                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
//                    let responseError = response["error"] as! Bool;
//
//                    if (responseError == false) {
//
//                        // print(response)
//                    }
//
//                } catch let error2 as NSError {
//
//                    print(error2.localizedDescription)
//                }
//            }
//
//        }).resume();
    }
    
    func getSettings() {
        
//        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_GET_SETTINGS)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
//        request.httpMethod = "POST"
//        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken();
//        request.httpBody = postString.data(using: .utf8)
//
//        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
//
//            if error != nil {
//
//                print(error!.localizedDescription)
//
//            } else {
//
//                do {
//
//                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
//                    let responseError = response["error"] as! Bool;
//
//                    if (responseError == false) {
//
//                        iApp.sharedInstance.setMessagesCount(messagesCount: (response["messagesCount"] as? Int)!)
//
//                        // Get categories obj
//
//                        let categoriesObj = response["categories"] as AnyObject
//
//                        //Get items array
//                        let itemsArray = categoriesObj["items"] as! [AnyObject]
//
//                        //Read items from array
//                        for itemObj in itemsArray {
//
//                            let cat = Category(Response: itemObj);
//
//                            iApp.sharedInstance.categories.append(cat.getTitle());
//                        }
//                    }
//
//                    DispatchQueue.main.async() {
//
//                        self.updateBadges()
//                    }
//
//                } catch let error2 as NSError {
//
//                    print(error2.localizedDescription)
//                }
//            }
//
//        }).resume();
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}
