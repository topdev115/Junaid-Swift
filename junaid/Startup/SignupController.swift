//
//  SignupController.swift
//  junaid
//
//  Created by Administrator on 2019/10/22.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit
import Kingfisher

class SignupController: UIViewController {
    
    @IBOutlet var personalDataTextFields: [PaddingTextField]!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView1: UIStackView!
    @IBOutlet weak var infoView2: UIStackView!
    
    @IBOutlet weak var signupButton: UIButton!
    
    var countries: [Country] = []
    var stores: [Store] = []
    
    let countryPicker = CustomePickerView()
    let storePicker = CustomePickerView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        countryPicker.backgroundColor = UIColor.init(white: 0.1, alpha: 0.9)
        storePicker.backgroundColor = UIColor.init(white: 0.1, alpha: 0.9)
        
        loadStoreCountryInfo()
        
        signupButton.layer.cornerRadius = 10
        
        for textField in personalDataTextFields {
            textField.delegate = self
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
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
    
    func loadStoreCountryInfo() {
        if Reachability.isConnectedToNetwork() {
            self.serverRequestStart();
            
            var request = URLRequest(url: URL(string: Constants.API.FETCH_COUNTRIES_STORES)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: Constants.REQUEST_TIMEOUT)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
                let err = error as NSError?
                guard let data = data, err == nil else {
                    print(err!.localizedDescription)
                    
                    DispatchQueue.main.async() {
                        self.serverRequestEnd()
                    }
                    
                    return
                }
                
                do {
                    let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let status = response["status"] as? Bool
                    
                    if status! {
                        // fetch countries & stores success
                        
                        if let countries = response["countries"] as? [Dictionary<String, AnyObject>] {
                            for _country in countries {
                                let newCountry = Country(_country)
                                self.countries.append(newCountry)
                            }
                            
                            DispatchQueue.main.async {
                                self.countryPicker.delegate = self
                            }
                        }
                        
                        if let stores = response["stores"] as? [Dictionary<String, AnyObject>] {
                            for _store in stores {
                                let newStore = Store(_store)
                                self.stores.append(newStore)
                            }
                            
                            DispatchQueue.main.async {
                                self.storePicker.delegate = self
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
                    }
                }
            }).resume()
        }
    }
    
    @IBAction func onSignup(_ sender: UIButton) {
        var empty = false
        for textField in personalDataTextFields {
            empty = textField.isEmpty()! || empty
        }
        if empty { return }
        
        if !isValidEmail(email: personalDataTextFields[2].text!) {
            personalDataTextFields[2].warning()
            
            let alert = UIAlertController(title: APP_NAME, message: "Invalid email".localizedString, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localizedString, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        if !isPhoneNumber(phoneNumber: personalDataTextFields[3].text!) {
            personalDataTextFields[3].warning()
            
            let alert = UIAlertController(title: APP_NAME, message: "Invalid phone number".localizedString, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localizedString, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        if personalDataTextFields[6].text != personalDataTextFields[7].text {
            //personalDataTextFields[6].warning()
            personalDataTextFields[7].warning()
            
            let alert = UIAlertController(title: APP_NAME, message: "Confirm password doesn't match".localizedString, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localizedString, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        self.signup()
    }
    
    @IBAction func onLogIn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func signup() {
        if Reachability.isConnectedToNetwork() {
            self.serverRequestStart();
            
            var request = URLRequest(url: URL(string: Constants.API.REGISTER)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: Constants.REQUEST_TIMEOUT)
            request.httpMethod = "POST"
            
            var postString = "first_name=" + personalDataTextFields[0].text!
            postString += "&last_name=" + personalDataTextFields[1].text!
            postString += "&email=" + personalDataTextFields[2].text!
            postString += "&mobile_number=" + personalDataTextFields[3].text!
            postString += "&dob=" + personalDataTextFields[4].text!.replacingOccurrences(of: "-", with: "/")
            postString += "&employee_code=" + personalDataTextFields[5].text!
            postString += "&password=" + personalDataTextFields[6].text!
            postString += "&store_id=" + String(personalDataTextFields[8].tag)
            postString += "&country_id=" + String(personalDataTextFields[9].tag)
            postString += "&doj=" + personalDataTextFields[10].text!.replacingOccurrences(of: "-", with: "/")
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
        (textField as! PaddingTextField).invalidate()
    }
    
    @IBAction func onTappedBackground(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    ///////////////////////////
    fileprivate func createToolbar(_ hint: String) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //toolbar.tintColor = UIColor.blue
        //toolbar.backgroundColor = UIColor.gray
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        titleLabel.text = hint.localizedString
        let textBtn = UIBarButtonItem(customView: titleLabel)
        let doneButton = UIBarButtonItem(title: "Done".localizedString, style: .plain, target: self, action: #selector(closePickerView))
        toolbar.setItems([textBtn, flexSpace, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }
    
    @objc func closePickerView() {
        view.endEditing(true)
    }
}



extension SignupController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case personalDataTextFields[4] ,    // Date of Birth
             personalDataTextFields[8] ,    // Store
             personalDataTextFields[9] ,    // Country
             personalDataTextFields[10] :   // Date of Joining
            return false
        default:
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == personalDataTextFields[4] || textField == personalDataTextFields[10] { // Date of Birth, Date of Joining
            let datePickerView = CustomeDatePicker()
            datePickerView.datePickerMode = .date
            
            if textField == personalDataTextFields[10] {
                textField.text = Date().string(format: Constants.DATE_FORMAT)
            }
            
            textField.inputView = datePickerView
            textField.inputAccessoryView = createToolbar("Select date")
            
            datePickerView.linkedTextField = textField
            datePickerView.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        }
        
        if textField == personalDataTextFields[8] { // Store
            storePicker.linkedTextField = textField
            textField.inputView = storePicker
            textField.inputAccessoryView = createToolbar("Select store")
        }
        
        if textField == personalDataTextFields[9] { // Country
            countryPicker.linkedTextField = textField
            textField.inputView = countryPicker
            textField.inputAccessoryView = createToolbar("Select country")
        }
    }
    
    @objc func datePickerValueChanged(_ sender: CustomeDatePicker) {
        if let textField = sender.linkedTextField {
            textField.text = sender.date.string(format: Constants.DATE_FORMAT)
            (textField as! PaddingTextField).invalidate()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == personalDataTextFields.last {
            textField.resignFirstResponder()
        } else {
            personalDataTextFields[textField.tag + 1].becomeFirstResponder()
        }
        
        return true
    }
}

extension SignupController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == countryPicker {
            return self.countries.count
        } else {
            return self.stores.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if pickerView == countryPicker {
            
            let parentView = UIView(frame: CGRect(x: (self.view.frame.size.width - 250) / 2, y: 0, width: 250, height:50))
            let flagView = UIImageView(frame: CGRect(x: 0, y: 10, width: 50, height:30))
            flagView.kf.setImage(with: self.countries[row].iconUrl)
            
            let label = UILabel(frame: CGRect(x: 70, y: 0, width: 180, height: 50))
            label.textColor = UIColor.white
            label.textAlignment = .left
            label.text = self.countries[row].name
            
            parentView.addSubview(flagView)
            parentView.addSubview(label)
            
            return parentView
        } else {
            
            let label = UILabel()
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.text = self.stores[row].name
            
            return label
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let textField = (pickerView as! CustomePickerView).linkedTextField {
            textField.text = pickerView == countryPicker ? self.countries[row].name : self.stores[row].name
            textField.tag = pickerView == countryPicker ? self.countries[row].id : self.stores[row].id
            (textField as! PaddingTextField).invalidate()
        }
    }
}



// MARK: Keyboard Handling
extension SignupController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            let keyboardFrame = self.view.convert(keyboardRect, from: nil)
            
            var contentInset:UIEdgeInsets = self.scrollView.contentInset
            contentInset.bottom = keyboardFrame.size.height
            scrollView.contentInset = contentInset
            
            /*
            let activeTextField = self.view.selectedTextField
            let frame = self.view.convert(activeTextField!.frame, from: activeTextField!.tag < 5 ? infoView1 : infoView2)
            let distanceToBottom = self.view.frame.height - (frame.origin.y + frame.size.height - scrollView.contentOffset.y)

            print("\(keyboardHeight)   \(distanceToBottom)  \(scrollView.contentOffset.y)")

            let collapseSpace = keyboardHeight - distanceToBottom
            if collapseSpace >= 0 {
                self.view.frame.origin.y =  -(collapseSpace + 10)
            }
            */
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        
        /*
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
        */
    }
}
