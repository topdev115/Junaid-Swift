//
//  QuizController.swift
//  junaid
//
//  Created by Administrator on 2019/11/11.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit

class QuizController: UIViewController, QuizItemDelegate {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var continueLaterButton: UILabel!
    @IBOutlet weak var nextQuestionButton: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    enum PageKind : Int {
        case quiz = 0
        case notFound  = 1
        case complete  = 2
    }
    
    var quizType: QuizListItem!
    
    var questionnaireId: Int!
    var questions: [QuizQuestionsItem] = []
    
    var pageViewController: SlidePageViewController!
    var currentPageIdx = 0
    var pageCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = quizType.name
        
        continueLaterButton.layer.cornerRadius = continueLaterButton.bounds.size.height / 2
        let tapContinueLater = UITapGestureRecognizer(target: self, action: #selector(onContinueLater))
        continueLaterButton.addGestureRecognizer(tapContinueLater)
        
        nextQuestionButton.layer.cornerRadius = nextQuestionButton.bounds.size.height / 2
        let tapNextQuestion = UITapGestureRecognizer(target: self, action: #selector(onNextQuestion))
        nextQuestionButton.addGestureRecognizer(tapNextQuestion)
        
        bottomConstraint.constant = -100.0
        
        self.loadQuestions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func loadQuestions() {
        if Reachability.isConnectedToNetwork() {
            self.serverRequestStart()
            
            var request = URLRequest(url: URL(string: Constants.API.GET_QUESTION_BY_TYPE + "?type=" + quizType.type)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: Constants.REQUEST_TIMEOUT)
            request.httpMethod = "GET"
            
            request.setValue("Bearer \(SettingManager.sharedInstance.token)", forHTTPHeaderField:"Authorization")
            
            URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
                let err = error as NSError?
                guard let data = data, err == nil else {
                    print(err!.localizedDescription)
                    
                    DispatchQueue.main.async() {
                        self.serverRequestEnd()
                        self.setupPageViewController(.notFound)
                    }
                    return
                }
                
                do {
                    let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let status = response["status"] as? Bool
                    
                    if status! {
                        if let questionnaireId = response["questionnaire_id"] as? Int {
                            self.questionnaireId = questionnaireId
                        }
                        
                        // fetch questionnaire
                        if let questions = response["data"] as? [Dictionary<String, AnyObject>] {
                            for _question in questions {
                                self.questions.append(QuizQuestionsItem(_question))
                            }
                            
                            DispatchQueue.main.async {
                                self.setupPageViewController(.quiz)
                            }
                        }
                    }
                    
                    DispatchQueue.main.async() {
                        self.serverRequestEnd()
                    }
                } catch let err {
                    print(err.localizedDescription)
                    
                    DispatchQueue.main.async() {
                        self.serverRequestEnd()
                        self.setupPageViewController(.notFound)
                    }
                }
            }).resume()
        }
    }
    
    private func setupPageViewController(_ option: PageKind) {
        let pages: [UIViewController] = setupPages(option)
        
        pageViewController = SlidePageViewController(pages: pages, transitionStyle: .scroll, interPageSpacing: 0.0)
        
        addChild(pageViewController)
        containerView.addSubview(pageViewController.view)
        pageViewController.view.frame = containerView.bounds
    }
    
    private func setupPages(_ option: PageKind) -> [UIViewController] {
        var pages: [UIViewController] = []
        
        if option == .quiz {
            bottomConstraint.constant = 20.0
            
            var idx = 0
            for _question in self.questions {
                idx += 1
                if _question.timeTaken == 0 {
                    let page = storyboard?.instantiateViewController(withIdentifier: "QuizItemController") as! QuizItemController
                    
                    page.delegate = self
                    page.quizType = quizType.type
                    page.position = "\(idx) of \(questions.count)"
                    page.question = _question
                    pages.append(page)
                }
            }
            
            if pages.count == 0 {
                bottomConstraint.constant = -100.0
                let page = storyboard?.instantiateViewController(withIdentifier: "QuizInfoController") as! QuizInfoController
                page.infoText = String(format: "Quiz for this %@ has been completed".localizedString, self.getQuizMessage())
                pages.append(page)
            }
        } else if option == .notFound {
            bottomConstraint.constant = -100.0
            
            let page = storyboard?.instantiateViewController(withIdentifier: "QuizInfoController") as! QuizInfoController
            
            page.infoText = "Quiz not found!".localizedString
            pages.append(page)
        }
        
        self.pageCount = pages.count
        
        return pages
    }
    
    @objc func onContinueLater() {
        showSnackbar(message: "Continue later".localizedString)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onNextQuestion() {
        let quizItemController = pageViewController.pages[currentPageIdx] as! QuizItemController
        
        if quizType.type == Constants.QUIZ_SALES_PITCH {
            if quizItemController.answerTextView.text != "Your Answer...".localizedString {
                
                submitQuiz(forParameter: quizItemController)
                
                if currentPageIdx >= pageCount - 1 {
                    showSnackbar(message: "Quiz Submitted Successfully".localizedString)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    
                    if currentPageIdx < pageCount - 2 {
                        nextQuestionButton.text = "Next Question".localizedString
                    } else {
                        nextQuestionButton.text = "Finish".localizedString
                    }
                    
                    pageViewController.changePage()
                    currentPageIdx += 1
                }
            } else {
                showSnackbar(message: "Please enter answer".localizedString)
            }
        } else {
            if quizItemController.selectedOption != nil {
                
                submitQuiz(forParameter: quizItemController)
                
                if currentPageIdx >= pageCount - 1 {
                    showSnackbar(message: "Quiz Submitted Successfully".localizedString)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    
                    if currentPageIdx < pageCount - 2 {
                        nextQuestionButton.text = "Next Question".localizedString
                    } else {
                        nextQuestionButton.text = "Finish".localizedString
                    }
                    
                    pageViewController.changePage()
                    currentPageIdx += 1
                }
            } else {
                showSnackbar(message: "Please select option".localizedString)
            }
        }
    }
    
    // MARK: - Quiz item timeout //
    
    func quizItem(timeOut questionItem: QuizQuestionsItem) {
        let quizItemController = pageViewController.pages[currentPageIdx] as! QuizItemController
        
        submitQuiz(forParameter: quizItemController)
        
        if currentPageIdx >= pageCount - 1 {
            showSnackbar(message: "Quiz Submitted Successfully".localizedString)
            self.navigationController?.popViewController(animated: true)
        } else {
            
            if currentPageIdx < pageCount - 2 {
                nextQuestionButton.text = "Next Question".localizedString
            } else {
                nextQuestionButton.text = "Finish".localizedString
            }
            
            pageViewController.changePage()
            currentPageIdx += 1
        }
    }
    
    ////////////////////////////////////
    
    func submitQuiz(forParameter quizItemController: QuizItemController) {
        // prepare json data
        
        var answerText = ""
        
        if quizType.type == Constants.QUIZ_SALES_PITCH {
            if quizItemController.answerTextView.text != "Your Answer...".localizedString {
                answerText = quizItemController.answerTextView.text
            }
        }
        
        var isCorrectAnswer: Int? = nil
        var answerId: Int?  = nil
        if quizItemController.selectedOption != nil {
            isCorrectAnswer = quizItemController.selectedOption!.isCorrectAnswer
            answerId = quizItemController.selectedOption!.id
        }
        
        let answerItem: [String: Any?] = [
            "is_correct_answer": isCorrectAnswer,
            "question_id": quizItemController.question.id,
            "answer_id": answerId,
            "answer_text": answerText,
            "time_taken": quizItemController.timeTaken,
        ]
        
        let answerList = [answerItem]
        
        let quizSubmitBody: [String: Any] = ["questionnaire_id": self.questionnaireId!, "answers": answerList]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: quizSubmitBody)
        
        // create post request
        if Reachability.isConnectedToNetwork() {
            var request = URLRequest(url: URL(string: Constants.API.SUBMIT_ANSWER + "?type=" + quizType.type)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: Constants.REQUEST_TIMEOUT)
            request.httpMethod = "POST"
            request.setValue("Bearer \(SettingManager.sharedInstance.token)", forHTTPHeaderField:"Authorization")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
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
                    
                    print("Sumbit Response === status: \(status)  message: \(message)")
                    
                } catch let err {
                    print(err.localizedDescription)
                }
            }).resume()
        }
    }
    
    func getQuizMessage() -> String {
        if quizType.type == "monthly" {
            return "month"
        } else {
            return "week"
        }
    }
}
