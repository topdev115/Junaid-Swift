//
//  PostDetailController.swift
//  junaid
//
//  Created by Administrator on 2019/10/29.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit
import ImageSlideshow
import Kingfisher

class PostDetailController: UIViewController {
    
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageSlideshow: ImageSlideshow!
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var splitBar: UIView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var commentTextField: PaddingTextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sendButton: UIButton!
    
    var post: Post?
    var postDetail: Post!
    var comments: [Comment] = []
    
    var onDismissed : (([Comment]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        commentTextField.delegate = self
        commentTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        if let post = self.post {
            self.loadPostDetail(post.id)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
        // Observe keyboard change
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        
        // Observe keyboard change
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if self.isMovingFromParent {
            onDismissed?(self.comments)
        }
    }
    
    func loadPostDetail(_ postId: Int) {
        if Reachability.isConnectedToNetwork() {
            self.serverRequestStart()
            
            var request = URLRequest(url: URL(string: Constants.API.GET_POST_DETAIL + String(postId))!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: Constants.REQUEST_TIMEOUT)
            request.httpMethod = "GET"
            
            request.setValue("Bearer \(SettingManager.sharedInstance.token)", forHTTPHeaderField:"Authorization")
            
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
                        // get product detail
                        if let postDetail = response["data"] as? Dictionary<String, AnyObject> {
                            self.postDetail = Post(postDetail)
                            
                            DispatchQueue.main.async {
                                self.displayData()
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
    
    func displayData() {
        
        profilePicView.layer.cornerRadius = profilePicView.frame.width / 2
        profilePicView.layer.masksToBounds = true
        
        if let profilePicUrl = postDetail.profilePicUrl {
            profilePicView.kf.setImage(with: profilePicUrl)
        }
        profilePicView.isHidden = false
        
        createdByLabel.text = postDetail.createdBy
        createdByLabel.isHidden = false
        descriptionLabel.text = postDetail.description
        descriptionLabel.isHidden = false
        
        // Image Slideshow
        imageSlideshow.slideshowInterval = 0
        imageSlideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
        imageSlideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        imageSlideshow.clipsToBounds = true
        imageSlideshow.layer.cornerRadius = 10.0
        imageSlideshow.layer.borderColor = UIColor.lightGray.cgColor
        imageSlideshow.layer.borderWidth = 1.0
        
        imageSlideshow.layer.shadowColor = UIColor.darkGray.cgColor
        imageSlideshow.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        imageSlideshow.layer.shadowRadius = 1.0
        imageSlideshow.layer.shadowOpacity = 0.6
        
        let pageControl = UIPageControl()
        pageControl.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        pageControl.currentPageIndicatorTintColor = UIColor.blue
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        imageSlideshow.pageIndicator = pageControl
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        imageSlideshow.activityIndicator = DefaultActivityIndicator()
        
        var inputs: [InputSource] = []
        for image in postDetail.images {
            if let imageUrl = image.imageUrl {
                let inputSource = KingfisherSource(url: imageUrl)
                inputs.append(inputSource)
            }
        }
        
        imageSlideshow.setImageInputs(inputs)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onSlideshow))
        imageSlideshow.addGestureRecognizer(recognizer)
        
        imageSlideshow.isHidden = false
        
        commentImage.isHidden = false
        
        commentCountLabel.text = String(postDetail.comments.count)
        commentCountLabel.isHidden = false
        
        splitBar.isHidden = false
        
        // Comment TableView
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.estimatedRowHeight = UITableView.automaticDimension
        
        self.comments = postDetail.comments
        self.comments.sort(by: { $0.createdAt! > $1.createdAt! })
        
        commentTableView.reloadData()
    }
    
    @objc func onSlideshow() {
        let fullScreenController = imageSlideshow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    @IBAction func onSend(_ sender: UIButton) {
        view.endEditing(true)
        
        if !commentTextField.isEmpty()! {
            send(comment: commentTextField.text!)
        }
    }
    
    func send(comment: String) {
        if Reachability.isConnectedToNetwork() {
            self.serverRequestStart()
            
            var request = URLRequest(url: URL(string: Constants.API.ADD_COMMENT)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: Constants.REQUEST_TIMEOUT)
            request.httpMethod = "POST"
            request.setValue("Bearer \(SettingManager.sharedInstance.token)", forHTTPHeaderField:"Authorization")
            
            let postString = "post_id=\(postDetail.id)&comment=\(comment)"
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
                        // add comment success
                        if let data = response["data"] as? Dictionary<String, AnyObject> {
                            let newComment = Comment(data)
                            self.comments.append(newComment)
                            self.comments.sort(by: { $0.createdAt! > $1.createdAt! })
                            
                            DispatchQueue.main.async {
                                self.commentCountLabel.text = String(self.comments.count)
                                self.commentTableView.reloadData()
                            }
                        }
                        
                    } else {
                        // add comment error
                        let message = response["message"] as! String
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

extension PostDetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! PostCommentCell
        
        // Configure cell...
        let comment = self.comments[indexPath.row]
        
        cell.profilePicView.layer.cornerRadius = cell.profilePicView.frame.width / 2
        cell.profilePicView.layer.masksToBounds = true
        
        if let profilePicUrl = comment.profilePicUrl {
            cell.profilePicView.kf.setImage(with: profilePicUrl)
        }
        cell.createdByLabel.text = comment.firstName + " " + comment.lastName
        cell.createdAtLabel.text = prettyDate(comment.createdAt)
        cell.descriptionLabel.text = comment.comment
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        super.updateViewConstraints()
        
        self.commentTableViewHeight.constant = self.commentTableView.contentSize.height
    }
}

extension PostDetailController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.commentTextField.resignFirstResponder()
        self.onSend(sendButton)
        
        return true
    }
}

// MARK: Keyboard Handling
extension PostDetailController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            self.bottomConstraint.constant = keyboardHeight - 30
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.bottomConstraint.constant != 0.0 {
            self.bottomConstraint.constant = 0.0
        }
    }
}


// PostCommentCell --- UITableViewCell

class PostCommentCell: UITableViewCell {
    
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
