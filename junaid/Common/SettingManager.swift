//
//  Setting.swift
//  GoodsAlert
//
//  Created by Liao Fang on 3/1/19.
//  Copyright © 2019 liaofang.com. All rights reserved.
//

import UIKit

class SettingManager {
    
    static let sharedInstance = SettingManager()
    
    func setId(_ id: String?) -> Void {
        UserDefaults.standard.set(id!, forKey: idKey)
    }
    
    var id : String {
        return UserDefaults.standard.string(forKey: idKey) ?? ""
    }
    
    func setFirstName(_ firstName: String?) -> Void {
        UserDefaults.standard.set(firstName!, forKey: firstNameKey)
    }
    
    var firstName : String {
        return UserDefaults.standard.string(forKey: firstNameKey) ?? ""
    }
    
    func setLastName(_ lastName: String?) -> Void {
        UserDefaults.standard.set(lastName!, forKey: lastNameKey)
    }
    
    var lastName : String {
        return UserDefaults.standard.string(forKey: lastNameKey) ?? ""
    }
    
    var fullName : String {
        return self.firstName + " " + self.lastName
    }
    
    func setEmail(_ email: String?) -> Void {
        UserDefaults.standard.set(email!, forKey: emailKey)
    }
    
    var email : String {
        return UserDefaults.standard.string(forKey: emailKey) ?? ""
    }
    
    func setMobileNumber(_ mobileNumber: String?) -> Void {
        UserDefaults.standard.set(mobileNumber!, forKey: mobileNumberKey)
    }
    
    var mobileNumber : String {
        return UserDefaults.standard.string(forKey: mobileNumberKey) ?? ""
    }
    
    func setProfilePic(_ profilePic: String?) -> Void {
        UserDefaults.standard.set(profilePic!, forKey: profilePicKey)
    }
    
    var profilePic : String {
        return UserDefaults.standard.string(forKey: profilePicKey) ?? ""
    }
    
    func setEmployeeCode(_ employeeCode: String?) -> Void {
        UserDefaults.standard.set(employeeCode!, forKey: employeeCodeKey)
    }
    
    var employeeCode : String {
        return UserDefaults.standard.string(forKey: employeeCodeKey) ?? ""
    }
    
    func setDob(_ dob: String?) -> Void {
        UserDefaults.standard.set(dob!, forKey: dobKey)
    }
    
    var dob : String {
        return UserDefaults.standard.string(forKey: dobKey) ?? ""
    }
    
    func setDoj(_ doj: String?) -> Void {
        UserDefaults.standard.set(doj!, forKey: dojKey)
    }
    
    var doj : String {
        return UserDefaults.standard.string(forKey: dojKey) ?? ""
    }
    
    func setStoreId(_ storeId: String?) -> Void {
        UserDefaults.standard.set(storeId!, forKey: storeIdKey)
    }
    
    var storeId : String {
        return UserDefaults.standard.string(forKey: storeIdKey) ?? ""
    }
    
    func setStoreName(_ storeName: String?) -> Void {
        UserDefaults.standard.set(storeName!, forKey: storeNameKey)
    }
    
    var storeName : String {
        return UserDefaults.standard.string(forKey: storeNameKey) ?? ""
    }
    
    func setCountryId(_ countryId: String?) -> Void {
        UserDefaults.standard.set(countryId!, forKey: countryIdKey)
    }
    
    var countryId : String {
        return UserDefaults.standard.string(forKey: countryIdKey) ?? ""
    }

    func setCountryName(_ countryName: String?) -> Void {
        UserDefaults.standard.set(countryName!, forKey: countryNameKey)
    }
    
    var countryName : String {
        return UserDefaults.standard.string(forKey: countryNameKey) ?? ""
    }
    
    func setRole(_ role: String?) -> Void {
        UserDefaults.standard.set(role!, forKey: roleKey)
    }
    
    var role : String {
        return UserDefaults.standard.string(forKey: roleKey) ?? ""
    }
    
    func setToken(_ token: String?) -> Void {
        UserDefaults.standard.set(token!, forKey: tokenKey)
    }
    
    var token : String {
        return UserDefaults.standard.string(forKey: tokenKey) ?? ""
    }
    
    func setProfile(_ profileData : Dictionary<String, AnyObject>) {
        if let id = profileData["id"] as? String {
            UserDefaults.standard.set(id, forKey: idKey)
        }
        
        if let firstName = profileData["first_name"] as? String {
            UserDefaults.standard.set(firstName, forKey: firstNameKey)
        }
        
        if let lastName = profileData["last_name"] as? String {
            UserDefaults.standard.set(lastName, forKey: lastNameKey)
        }
        
        if let email = profileData["email"] as? String {
            UserDefaults.standard.set(email, forKey: emailKey)
        }
        
        if let mobileNumber = profileData["mobile_number"] as? String {
            UserDefaults.standard.set(mobileNumber, forKey: mobileNumberKey)
        }
        
        if let profilePic = profileData["profile_pic"] as? String {
            UserDefaults.standard.set(profilePic, forKey: profilePicKey)
        }
        
        if let employeeCode = profileData["employee_code"] as? String {
            UserDefaults.standard.set(employeeCode, forKey: employeeCodeKey)
        }
        
        if let dob = profileData["dob"] as? String {
            UserDefaults.standard.set(dob, forKey: dobKey)
        }
        
        if let doj = profileData["doj"] as? String {
            UserDefaults.standard.set(doj, forKey: dojKey)
        }
        
        if let storeId = profileData["store_id"] as? String {
            UserDefaults.standard.set(storeId, forKey: storeIdKey)
        }
        
        if let storeName = profileData["store_name"] as? String {
            UserDefaults.standard.set(storeName, forKey: storeNameKey)
        }
        
        if let countryId = profileData["country_id"] as? String {
            UserDefaults.standard.set(countryId, forKey: countryIdKey)
        }
        
        if let countryName = profileData["country_name"] as? String {
            UserDefaults.standard.set(countryName, forKey: countryNameKey)
        }
        
        if let role = profileData["role"] as? String {
            UserDefaults.standard.set(role, forKey: roleKey)
        }
        
        if let token = profileData["token"] as? String {
            UserDefaults.standard.set(token, forKey: tokenKey)
        }
    }
    
    func clearProfile() {
        UserDefaults.standard.set("", forKey: idKey)
        UserDefaults.standard.set("", forKey: firstNameKey)
        UserDefaults.standard.set("", forKey: lastNameKey)
        UserDefaults.standard.set("", forKey: emailKey)
        UserDefaults.standard.set("", forKey: mobileNumberKey)
        UserDefaults.standard.set("", forKey: profilePicKey)
        UserDefaults.standard.set("", forKey: employeeCodeKey)
        UserDefaults.standard.set("", forKey: dobKey)
        UserDefaults.standard.set("", forKey: dojKey)
        UserDefaults.standard.set("", forKey: storeIdKey)
        UserDefaults.standard.set("", forKey: storeNameKey)
        UserDefaults.standard.set("", forKey: countryIdKey)
        UserDefaults.standard.set("", forKey: countryNameKey)
        UserDefaults.standard.set("", forKey: roleKey)
        UserDefaults.standard.set("", forKey: tokenKey)
    }
    
    // UserDefaults
    fileprivate let idKey           = "idKey"
    fileprivate let firstNameKey    = "firstNameKey"
    fileprivate let lastNameKey     = "lastNameKey"
    fileprivate let emailKey        = "emailKey"
    fileprivate let mobileNumberKey = "mobileNumberKey"
    fileprivate let profilePicKey   = "profilePicKey"
    fileprivate let employeeCodeKey = "employeeCodeKey"
    fileprivate let dobKey          = "dobKey"
    fileprivate let dojKey          = "dojKey"
    fileprivate let storeIdKey      = "storeIdKey"
    fileprivate let storeNameKey    = "storeNameKey"
    fileprivate let countryIdKey    = "countryIdKey"
    fileprivate let countryNameKey  = "countryNameKey"
    fileprivate let roleKey         = "roleKey"
    fileprivate let tokenKey        = "tokenKey"
}
