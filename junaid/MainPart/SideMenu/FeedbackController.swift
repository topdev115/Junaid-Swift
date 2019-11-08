//
//  FeedbackController.swift
//  junaid
//
//  Created by Administrator on 2019/10/27.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit
import Cosmos

class FeedbackController: UIViewController {
    
    @IBOutlet weak var fullNameTextField: PaddingTextField!
    @IBOutlet weak var mobileNumberTextField: PaddingTextField!
    @IBOutlet weak var feedbackTextView: PaddingTextView!
    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fullNameTextField.delegate = self
        fullNameTextField.text = SettingManager.sharedInstance.fullName
        fullNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        mobileNumberTextField.delegate = self
        mobileNumberTextField.text = SettingManager.sharedInstance.mobileNumber
        mobileNumberTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        feedbackTextView.delegate = self
        feedbackTextView.text = PaddingTextView.PLACEHOLDER
        feedbackTextView.textColor = UIColor.lightGray
        
        ratingView.settings.fillMode = .full
        
        sendButton.layer.cornerRadius = 10
    }
    
    @IBAction func onBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onSend(_ sender: UIButton) {
        var empty = fullNameTextField.isEmpty()!
        empty = mobileNumberTextField.isEmpty()! || empty
        empty = feedbackTextView.isEmpty()! || empty
        
        if empty { return }
        
        if !isPhoneNumber(phoneNumber: mobileNumberTextField.text!) {
            mobileNumberTextField.warning()
            
            let alert = UIAlertController(title: APP_NAME, message: "Invalid mobile number".localizedString, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localizedString, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        self.send()
    }
    
    func send() {       
        if Reachability.isConnectedToNetwork() {
            self.serverRequestStart();
            
            var request = URLRequest(url: URL(string: Constants.API.CUSTOMER_FEEDBACK)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: Constants.REQUEST_TIMEOUT)
            request.httpMethod = "POST"
            
            request.setValue("Bearer \(SettingManager.sharedInstance.token)", forHTTPHeaderField:"Authorization")
            
            var postString = "name=" + fullNameTextField.text!
            postString += "&mobile_number=" + mobileNumberTextField.text!
            postString += "&feedback=" + feedbackTextView.text!
            postString += "&rating=" + String(Int(ratingView.rating))
     
            request.httpBody = postString.data(using: .utf8)
           
            URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
                let err = error as NSError?
                guard let data = data, err == nil else {
                    print(err!.localizedDescription)
                    
                    DispatchQueue.main.async() {
                        self.serverRequestEnd()
                        
                        if err!.code == NSURLErrorTimedOut {
                            let alert = UIAlertController(title: APP_NAME, message: "Could not connect to the server.\nPlease check the internet connection!".localizedString, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK".localizedString, style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    
                    return
                }
                
                do {
                    let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let status = response["status"] as? Bool
                    let message = response["message"] as? String
                    
                    if status! {
                        // register success
                        DispatchQueue.main.async {
                            // show message with error
                            let alert = UIAlertController(title: APP_NAME, message: message, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK".localizedString, style: .cancel, handler: { (action) in
                                DispatchQueue.main.async {
                                    self.dismiss(animated: true)
                                }
                            }))
                            // show the alert
                            self.present(alert, animated: true, completion: nil)
                        }
                    } else {
                        // register error
                        DispatchQueue.main.async {
                            // show message with error
                            let alert = UIAlertController(title: APP_NAME, message: message, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK".localizedString, style: .cancel, handler: nil))
                            // show the alert
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    
                    DispatchQueue.main.async() {
                        self.serverRequestEnd()
                    }
                } catch let err {
                    print(err.localizedDescription)
                    
                    DispatchQueue.main.async() {
                        self.serverRequestEnd()
                    }
                }
            }).resume()
            
        } else {
            // network disconnected
            DispatchQueue.main.async {
                let alert = UIAlertController(title: APP_NAME, message: "Could not connect to the server.\nPlease check the internet connection!".localizedString, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK".localizedString, style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        (textField as! PaddingTextField).invalidate()
    }
    
    @IBAction func onTappedBackground(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension FeedbackController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            mobileNumberTextField.becomeFirstResponder()
            break
        default:
            feedbackTextView.becomeFirstResponder()
        }
        
        return true
    }
}

extension FeedbackController: UITextViewDelegate {
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
            textView.text = PaddingTextView.PLACEHOLDER
            textView.textColor = UIColor.lightGray
        }
    }
}
