//
//  Quiz.swift
//  junaid
//
//  Created by Administrator on 2019/11/11.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import Foundation

class QuizListItem {
    var id: Int = 0
    var name: String = ""
    var type: String = ""
    
    init(id: Int, name: String, type: String) {
        self.id = id
        self.name = name
        self.type = type
    }
    
    init(_ quizListItem : Dictionary<String, AnyObject>) {
        if let id = quizListItem["id"] as? Int {
            self.id = id
        }
        
        if let name = quizListItem["name"] as? String {
            self.name = name
        }
        
        if let type = quizListItem["type"] as? String {
            self.type = type
        }
    }
}

class QuizOptionsItem {
    var id: Int = 0
    var sequence: String = ""
    var optionText: String = ""
    var optionImage: String = ""
    var optionImageUrl: URL?
    var isCorrectAnswer: Int = 0
    
    init(_ quizOptionsItem : Dictionary<String, AnyObject>) {
        if let id = quizOptionsItem["id"] as? Int {
            self.id = id
        }
        
        if let sequence = quizOptionsItem["sequence"] as? String {
            self.sequence = sequence
        }
        
        if let optionText = quizOptionsItem["option_text"] as? String {
            self.optionText = optionText
        }
        
        if let optionImage = quizOptionsItem["option_image"] as? String {
            self.optionImage = optionImage
            if !self.optionImage.isEmpty {
                self.optionImageUrl = URL(string: Constants.API.MAIN_URL + "/" + self.optionImage)!
            }
        }
        
        if let isCorrectAnswer = quizOptionsItem["is_correct_answer"] as? String {
            self.isCorrectAnswer = Int(isCorrectAnswer)!
        }
    }
}

class QuizQuestionsItem {
    var id: Int = 0
    var questionText: String = ""
    var questionImage: String = ""
    var questionImageUrl: URL?
    var answerTime: Int = 0
    var correctAnswer: String = ""
    var answerId: String = ""
    var answerText: String = ""
    var timeTaken: Int = 0
    var isCorrectAnswer: String = ""
    
    var options: [QuizOptionsItem] = []
    
    init(_ questionsItem : Dictionary<String, AnyObject>) {
        if let id = questionsItem["id"] as? String {
            self.id = Int(id)!
        }
        
        if let questionText = questionsItem["question_text"] as? String {
            self.questionText = questionText
        }
        
        if let questionImage = questionsItem["question_image"] as? String {
            self.questionImage = questionImage
            if !self.questionImage.isEmpty {
                self.questionImageUrl = URL(string: Constants.API.MAIN_URL + "/" + self.questionImage)!
            }
        }
        
        if let answerTime = questionsItem["answer_time"] as? String {
            self.answerTime = Int(answerTime)!
        }
        
        if let correctAnswer = questionsItem["correct_answer"] as? String {
            self.correctAnswer = correctAnswer
        }
        
        if let answerId = questionsItem["answer_id"] as? String {
            self.answerId = answerId
        }
        
        if let answerText = questionsItem["answer_text"] as? String {
            self.answerText = answerText
        }
        
        if let timeTaken = questionsItem["time_taken"] as? String {
            self.timeTaken = Int(timeTaken)!
        }
        
        if let isCorrectAnswer = questionsItem["is_correct_answer"] as? String {
            self.isCorrectAnswer = isCorrectAnswer
        }
        
        if let options = questionsItem["options"] as? [Dictionary<String, AnyObject>] {
            for _option in options {
                let newOption = QuizOptionsItem(_option)
                self.options.append(newOption)
            }
        }
    }
}
