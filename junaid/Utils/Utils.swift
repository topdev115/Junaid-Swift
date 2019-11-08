//
//  Utils.swift
//  junaid
//
//  Created by Administrator on 2019/10/25.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit

// Load image from url
func loadImage(from url: URL) -> UIImage? {
    if let data = try? Data(contentsOf: url) {
        return UIImage(data: data)
    } else {
        return nil
    }
}

// Validate email
func isValidEmail(email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

// Validate phone number
func isPhoneNumber(phoneNumber: String) -> Bool {
    let charcter  = CharacterSet(charactersIn: "+0123456789").inverted
    let inputString = phoneNumber.components(separatedBy: charcter) as NSArray
    let filtered = inputString.componentsJoined(by: "")
    
    return phoneNumber == filtered
}

// Get pretty date string
func prettyDate(_ date: Date?) -> String {
    guard let date = date else {
        return ""
    }
    
    var retVal: String
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
    let nowString = dateFormatter.string(from: Date())
    
    let dateFormatter2 = DateFormatter()
    dateFormatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let now = dateFormatter2.date(from: nowString)!
    
    let diff = Int(now.timeIntervalSince1970 - date.timeIntervalSince1970)
    
    if diff < 60 {
        retVal = "\(diff)s"
    } else if diff < 3600 {
        retVal = "\(diff / 60)m"
    } else if diff < 86400 {
        retVal = "\(diff / 3600)h"
    } else if diff < 86400 * 30 {
        retVal = "\(diff / 86400)d"
    } else if diff < 86400 * 365 {
        retVal = "\(diff / 86400 / 30)mth"
    } else {
        retVal = "\(diff / 86400 / 365)y"
    }
    
    return retVal
}
