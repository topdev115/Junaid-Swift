//
//  TopScorer.swift
//  junaid
//
//  Created by Administrator on 2019/10/30.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import Foundation

class TopScorer {
    var id: Int = 0
    var firstName: String = ""
    var lastName: String = ""
    var storeId: Int = 0
    var countryId: Int = 0
    var profilePicUrl: URL?
    var month: Int = 0
    var answerCount: Int = 0
    var totalTimeTaken: Int = 0
    var totalQuestion: Int = 0
    
    init(_ topScorer : Dictionary<String, AnyObject>) {
        if let id = topScorer["id"] as? String {
            self.id = Int(id)!
        }
        
        if let firstName = topScorer["first_name"] as? String {
            self.firstName = firstName
        }
        
        if let lastName = topScorer["last_name"] as? String {
            self.lastName = lastName
        }
        
        if let storeId = topScorer["store_id"] as? String {
            self.storeId = Int(storeId)!
        }
        
        if let countryId = topScorer["country_id"] as? String {
            self.countryId = Int(countryId)!
        }
        
        if let profilePic = topScorer["profile_pic"] as? String {
            self.profilePicUrl = URL(string: Constants.API.MAIN_URL + "/" + profilePic)!
        }
        
        if let month = topScorer["month"] as? String {
            self.month = Int(month)!
        }
        
        if let answerCount = topScorer["answer_count"] as? String {
            self.answerCount = Int(answerCount)!
        }
        
        if let totalTimeTaken = topScorer["total_time_taken"] as? String {
            self.totalTimeTaken = Int(totalTimeTaken)!
        }
        
        if let totalQuestion = topScorer["total_question"] as? String {
            self.totalQuestion = Int(totalQuestion)!
        }
    }
}
