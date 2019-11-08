//
//  ForgotPasswordController.swift
//  junaid
//
//  Created by Administrator on 2019/10/22.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit

class ForgotPasswordController: UIViewController {
    
    @IBOutlet weak var emailTextField: PaddingTextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        submitButton.layer.cornerRadius = 10
        
        emailTextField.delegate = self
        
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Observe keyboard change
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        // Observe keyboard change
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func onSubmit(_ sender: UIButton) {
        view.endEditing(true)
        
        if emailTextField.isEmpty()! { return }
        
        if !isValidEmail(email: emailTextField.text!) {
            emailTextField.warning()
            
            let alert = UIAlertController(title: APP_NAME, message: "Invalid email".localizedString, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localizedString, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        submit(email: emailTextField.text!)
    }
    
    func submit(email: String) {
        if Reachability.isConnectedToNetwork() {
            self.serverRequestStart();
            
            var request = URLRequest(url: URL(string: Constants.API.FORGOT_PASSWORD)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: Constants.REQUEST_TIMEOUT)
            request.httpMethod = "POST"
            
            let postString = "email=" + email
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
                                    self.navigationController?.popViewController(animated: true)
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
        emailTextField.invalidate()
    }
    
    @IBAction func onTappedBackground(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension ForgotPasswordController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        emailTextField.resignFirstResponder()
        
        return true
    }
}

// MARK: Keyboard Handling
extension ForgotPasswordController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            let activeTextField = self.view.selectedTextField
            
            let distanceToBottom = self.view.frame.height - ((activeTextField?.frame.origin.y)! + (activeTextField?.frame.size.height)!)
            let collapseSpace = keyboardHeight - distanceToBottom
            
            if collapseSpace > 0 {
                self.view.frame.origin.y =  -(collapseSpace + 10)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
