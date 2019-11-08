//
//  Notification.swift
//  junaid
//
//  Created by Administrator on 2019/10/27.
//  Copyright © 2019 Zemin Li. All rights reserved.
//
import Foundation

class Notification {
    var id: Int = 0
    var title: String = ""
    var description: String = ""
    var imageUrl: String = ""
    var profilePic: String = ""
    var createdBy: String = ""
    var createdAt: Date?
    
    init(_ notification : Dictionary<String, AnyObject>) {
        if let id = notification["id"] as? String {
            self.id = Int(id)!
        }
        
        if let title = notification["title"] as? String {
            self.title = title
        }
        
        if let description = notification["description"] as? String {
            self.description = description
        }
        
        if let imageUrl = notification["image_url"] as? String {
            self.imageUrl = imageUrl
        }
        
        if let profilePic = notification["profile_pic"] as? String {
            self.profilePic = profilePic
        }
        
        if let createdBy = notification["created_by"] as? String {
            self.createdBy = createdBy
        }
        
        if let createdAt = notification["created_at"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            self.createdAt = dateFormatter.date(from: createdAt)
        }
    }
}
