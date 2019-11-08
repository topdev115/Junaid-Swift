//
//  LoginController.swift
//  junaid
//
//  Created by Administrator on 2019/10/22.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    @IBOutlet weak var employeeCodeTextField: PaddingTextField!
    @IBOutlet weak var passwordTextField: PaddingTextField!
    
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 10
        
        employeeCodeTextField.delegate = self
        passwordTextField.delegate = self
        
        employeeCodeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
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
    
    @IBAction func onLogIn(_ sender: UIButton) {
        view.endEditing(true)
        
        var empty = employeeCodeTextField.isEmpty()!
        empty = passwordTextField.isEmpty()! || empty
        
        if !empty {
            login(employeeCode: employeeCodeTextField.text!, password: passwordTextField.text!)
        }
    }
    
    func login(employeeCode: String, password: String) {
        
        if Reachability.isConnectedToNetwork() {
            self.serverRequestStart();
            
            var request = URLRequest(url: URL(string: Constants.API.LOGIN)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: Constants.REQUEST_TIMEOUT)
            request.httpMethod = "POST"
            
            let postString = "employee_code=" + employeeCode + "&password=" + password
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
                    
                    if status! {
                        // login success
                        
                        // Save profile data
                        SettingManager.sharedInstance.setProfile(response)
                        
                        DispatchQueue.global(qos: .background).async {
                            DispatchQueue.main.async {
                                // run main content storyboard
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "TabBarController")
                                self.present(vc, animated: true, completion: nil)
                            }
                        }
                    } else {
                        // login error
                        DispatchQueue.main.async {
                            // show message with error
                            let alert = UIAlertController(title: APP_NAME, message: "Invalid Credential".localizedString, preferredStyle: .alert)
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

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            self.passwordTextField.becomeFirstResponder()
            
            break
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
}

// MARK: Keyboard Handling
extension LoginController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            let activeTextField = self.view.selectedTextField
            let frame = self.view.convert(activeTextField!.frame, from: nil)
            
            let distanceToBottom = self.view.frame.height - (frame.origin.y + frame.size.height)
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
