//
//  QuizItemDelegate.swift
//  junaid
//
//  Created by Administrator on 2019/11/12.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit

protocol QuizItemDelegate : class {
    func quizItem(timeOut questionItem: QuizQuestionsItem)
}
