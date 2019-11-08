//
//  Post.swift
//  junaid
//
//  Created by Administrator on 2019/10/29.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import Foundation

class Post {
    var id: Int = 0
    var type: String = ""
    var description: String = ""
    var userId: Int = 0
    var productId: Int = 0
    var storeId: Int = 0
    var profilePicUrl: URL?
    var createdBy: String = ""
    var createdAt: Date?
    var commentCount: Int = 0

    var images: [Image] = []
    var comments: [Comment] = []

    init(_ post : Dictionary<String, AnyObject>) {
        if let id = post["id"] as? String {
            self.id = Int(id)!
        }
        
        if let type = post["type"] as? String {
            self.type = type
        }

        if let description = post["description"] as? String {
            self.description = description
        }

        if let userId = post["user_id"] as? String {
            self.userId = Int(userId)!
        }

        if let productId = post["product_id"] as? String {
            self.productId = Int(productId)!
        }

        if let storeId = post["store_id"] as? String {
            self.storeId = Int(storeId)!
        }

        if let profilePic = post["profile_pic"] as? String {
            self.profilePicUrl = URL(string: Constants.API.MAIN_URL + "/" + profilePic)!
        }

        if let createdBy = post["created_by"] as? String {
            self.createdBy = createdBy
        }
        
        if let createdAt = post["created_at"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            self.createdAt = dateFormatter.date(from: createdAt)
        }

        if let commentCount = post["comment_count"] as? Int {
            self.commentCount = commentCount
        }
        
        if let images = post["images"] as? [Dictionary<String, AnyObject>] {
            for _image in images {
                let newImage = Image(_image)
                self.images.append(newImage)
            }
        } else if let image = post["images"] as? Dictionary<String, AnyObject> {
            let newImage = Image(image)
            self.images.append(newImage)
        }
        
        if let comments = post["comments"] as? [Dictionary<String, AnyObject>] {
            for _comment in comments {
                let newComment = Comment(_comment)
                self.comments.append(newComment)
            }
        }
    }
}

class Comment: Hashable {
    var id: Int = 0
    var userId: Int = 0
    var comment: String = ""
    var createdAt: Date?
    var firstName: String = ""
    var lastName: String = ""
    var profilePicUrl: URL?

    init(_ comment : Dictionary<String, AnyObject>) {
        if let id = comment["id"] as? Int {
            self.id = id
        }
        
        if let userId = comment["user_id"] as? String {
            self.userId = Int(userId)!
        }
        
        if let comment = comment["comment"] as? String {
            self.comment = comment
        }
        
        if let createdAt = comment["created_at"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            self.createdAt = dateFormatter.date(from: createdAt)
        }
        
        if let firstName = comment["first_name"] as? String {
            self.firstName = firstName
        }
        
        if let lastName = comment["last_name"] as? String {
            self.lastName = lastName
        }
        
        if let profilePic = comment["profile_pic"] as? String {
            self.profilePicUrl = URL(string: Constants.API.MAIN_URL + "/" + profilePic)!
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }

    static func ==(lhs: Comment, rhs: Comment) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
