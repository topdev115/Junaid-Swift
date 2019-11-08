//
//  Image.swift
//  junaid
//
//  Created by Administrator on 2019/10/29.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import Foundation

class Image {
    var id: Int = 0
    var imageLink: String = ""
    var imageUrl: URL?
    
    var postId: Int = 0
    var sequence: String = ""
    var status: Int = 0
    var createdAt: Date?
    var updatedAt: Date?
    
    init(_ image : Dictionary<String, AnyObject>) {
        if let id = image["id"] as? Int {
            self.id = id
        }
        
        if let imageLink = image["image_url"] as? String {
            self.imageLink = Constants.API.MAIN_URL + "/" + imageLink
            self.imageUrl = URL(string: self.imageLink)!
        }
        
        if let postId = image["post_id"] as? String {
            self.postId = Int(postId)!
        }
        
        if let sequence = image["sequence"] as? String {
            self.sequence = sequence
        }
        
        if let status = image["status"] as? String {
            self.status = Int(status)!
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let createdAt = image["created_at"] as? String {
            self.createdAt = dateFormatter.date(from: createdAt)
        }
        
        if let updatedAt = image["updated_at"] as? String {
            self.updatedAt = dateFormatter.date(from: updatedAt)
        }
    }
}
