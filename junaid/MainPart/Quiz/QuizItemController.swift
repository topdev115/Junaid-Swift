//
//  QuizItemController.swift
//  junaid
//
//  Created by Administrator on 2019/11/11.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit
import Kingfisher
import HGCircularSlider

class QuizItemController: UIViewController {
    weak var delegate: QuizItemDelegate?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var positionLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageMarginTop: NSLayoutConstraint!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var countDownTimer: CircularSlider!
    @IBOutlet weak var secondLabel: UILabel!
    
    @IBOutlet weak var optionTableView: UITableView!
    @IBOutlet weak var optionTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var answerTextView: PaddingTextView!
    @IBOutlet weak var answerTextHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    
    private var timer = Timer()
    private var second = 0
    var timeTaken = 0
    
    var quizType: String!
    var position: String!
    var question: QuizQuestionsItem!
    
    var selectedOption: QuizOptionsItem?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Observe keyboard change
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Observe keyboard change
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        positionLabel.text = position
        
        if let questionImageUrl = question.questionImageUrl {
            imageView.kf.setImage(with: questionImageUrl)
        } else {
            imageMarginTop.constant = 0
            imageHeight.constant = 0
        }
        
        second = question.answerTime
        
        countDownTimer.minimumValue = 0
        countDownTimer.maximumValue = CGFloat(second)
        countDownTimer.endPointValue = countDownTimer.maximumValue
        countDownTimer.isEnabled = false
        secondLabel.text = "\(second) sec"
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(QuizItemController.updateTimer(t:))), userInfo: nil, repeats: true)
        
        questionText.text = question.questionText
        
        if quizType == Constants.QUIZ_SALES_PITCH {
            answerTextView.delegate = self
            answerTextView.text = "Your Answer...".localizedString
            answerTextView.textColor = UIColor.lightGray
            
            answerTextHeight.constant = 150
        } else {
            optionTableView.delegate = self
            optionTableView.dataSource = self
            
            optionTableView.estimatedRowHeight = UITableView.automaticDimension
            optionTableHeight.constant = 30
            
            optionTableView.reloadData()
        }
    }
    
    @objc func updateTimer(t: Timer) {
        second -= 1
        timeTaken += 1
        if (second == 0) {
            self.timer.invalidate()
            self.delegate?.quizItem(timeOut: question)
        }
        
        secondLabel.text = "\(second) sec"
        countDownTimer.endPointValue = CGFloat(second)
    }
    
    @IBAction func onTappedBackground(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension QuizItemController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        (textView as! PaddingTextView).invalidate()
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Your Answer...".localizedString
            textView.textColor = UIColor.lightGray
        }
    }
}

extension QuizItemController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question.options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath) as! QuestionOptionCell
        
        cell.optionTextLabel.text = question.options[indexPath.row].optionText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        super.updateViewConstraints()
        
        self.optionTableHeight.constant = self.optionTableView.contentSize.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOption = question.options[indexPath.row]
    }
}

// MARK: Keyboard Handling
extension QuizItemController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            self.scrollView.contentOffset.y = self.scrollView.contentSize.height
            self.viewBottomConstraint.constant =  keyboardHeight - 50
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.viewBottomConstraint.constant != 0 {
            self.viewBottomConstraint.constant = 0
            self.scrollView.contentOffset.y = 0
        }
    }
}

extension QuizItemController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: optionTableView))! {
            return false
        }
        
        return true
    }
}

// QuestionOptionCell

class QuestionOptionCell: UITableViewCell {
    
    @IBOutlet weak var checkBox: UIImageView!
    @IBOutlet weak var optionTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        if selected {
            self.contentView.backgroundColor = UIColor.init(red: 203.0/255.0, green: 172.0/255.0, blue: 80.0/255.0, alpha: 0.5)
            
            self.checkBox.image = UIImage(named: "checked")
        } else {
            self.contentView.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            self.checkBox.image = UIImage(named: "unchecked")
        }
    }
}
