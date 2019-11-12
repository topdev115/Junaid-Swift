//
//  AppDelegate.swift
//  junaid
//
//  Created by Administrator on 2019/10/22.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate/*, MessagingDelegate*/ {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        /*
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            //UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
        */
        
        // Override point for customization after application launch.
        if SettingManager.sharedInstance.token.isEmpty {
            let storyboard = UIStoryboard.init(name: "Startup", bundle: Bundle.main)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
            let navigationController = UINavigationController.init(rootViewController: loginVC)
            self.window?.rootViewController = navigationController
        } else {
            
            print("===TOKEN===\n\(SettingManager.sharedInstance.token)")
            
            let tabBarVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarController") as? TabBarController
            self.window?.rootViewController = tabBarVC
        }
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func registerFCMID(fcmToken: String) {
        if Reachability.isConnectedToNetwork() {
            var request = URLRequest(url: URL(string: Constants.API.REG_FCM_ID)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: Constants.REQUEST_TIMEOUT)
            request.httpMethod = "POST"
            
            request.setValue("Bearer \(SettingManager.sharedInstance.token)", forHTTPHeaderField:"Authorization")
            
            var postString = "gcm_id=" + fcmToken
            postString += "&device_id=" + UIDevice.current.identifierForVendor!.uuidString
            postString += "&device_type=" + "ios"
            
            request.httpBody = postString.data(using: .utf8)
            
            URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
                let err = error as NSError?
                guard let data = data, err == nil else {
                    print(err!.localizedDescription)
                    return
                }
                
                do {
                    let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let status = response["status"] as? Bool
                    let message = response["message"] as? String
                    
                    print("FCM ID Response === status: \(status)  message: \(message)")
                    
                } catch let err {
                    print(err.localizedDescription)
                    
                }
            }).resume()
        }
    }
    
    /*
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("token = \(fcmToken)")
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData) // or do whatever
    }
    */

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

