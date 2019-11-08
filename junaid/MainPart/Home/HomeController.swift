//
//  HomeController.swift
//  junaid
//
//  Created by Administrator on 2019/10/29.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit
import PagingTableView
import Kingfisher
import ImageSlideshow

class HomeController: UIViewController {

    @IBOutlet weak var tableView: PagingTableView!
    
    let postData = PostData()
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl!.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.pagingDelegate = self
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        //self.tableView.refreshControl!.beginRefreshing()
    }
    
    @objc private func refreshData(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            self.posts.removeAll()
            self.tableView.reset()
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguePostDetail", let postDetailVC = segue.destination as? PostDetailController {
            let row = sender as! Int
            postDetailVC.post = self.posts[row]
            postDetailVC.onDismissed = { comments in
                self.posts[row].commentCount = comments.count
                self.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .fade)
            }
        }
    }
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
        
        // Configure cell...
        let post = posts[indexPath.row]
        
        cell.profilePicView.layer.cornerRadius = cell.profilePicView.frame.width / 2
        cell.profilePicView.layer.masksToBounds = true
        
        /*
        if let profilePicUrl = post.profilePicUrl {
            cell.profilePicView.kf.setImage(with: profilePicUrl)
        } else {
            cell.profilePicView.image = UIImage(named: "user")
        }
        */
        
        cell.createdByLabel.text = post.createdBy
        cell.createdAtLabel.text = prettyDate(post.createdAt)
        cell.descriptionLabel.text = post.description
        cell.initImageSlideshow(images: post.images)
        cell.delegate = self
        cell.commentCountLabel.text = String(post.commentCount)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "seguePostDetail", sender: indexPath.row)
    }
}

extension HomeController: PostCellDelegate {
    func slideShowTapped(cell: PostCell) {
        let fullScreenController = cell.imageSlideshow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
}

extension HomeController: PagingTableViewDelegate {
    func paginate(_ tableView: PagingTableView, to page: Int) {
        if !self.tableView.refreshControl!.isRefreshing {
            self.tableView.isLoading = true
        }
        
        DispatchQueue.main.async {
            self.postData.loadData(at: page) { contents in
                self.posts.append(contentsOf: contents)
                self.posts.sort(by: { $0.createdAt! > $1.createdAt! })
                self.tableView.isLoading = false
                
                if self.tableView.refreshControl!.isRefreshing {
                    self.tableView.refreshControl!.endRefreshing()
                }
            }
        }
    }
}

// PostCell --- UITableViewCell

protocol PostCellDelegate {
    func slideShowTapped(cell: PostCell)
}

class PostCell: UITableViewCell {
   
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageSlideshow: ImageSlideshow!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    var delegate: PostCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    func initImageSlideshow(images: [Image]) {
        
        imageSlideshow.slideshowInterval = 0
        imageSlideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        imageSlideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
        
        imageSlideshow.clipsToBounds = true
        imageSlideshow.layer.cornerRadius = 10.0
        imageSlideshow.layer.borderColor = UIColor.lightGray.cgColor
        imageSlideshow.layer.borderWidth = 1.0
        
        imageSlideshow.layer.shadowColor = UIColor.darkGray.cgColor
        imageSlideshow.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        imageSlideshow.layer.shadowRadius = 1.0
        imageSlideshow.layer.shadowOpacity = 0.6
        
        if images.count > 1 {
            let pageControl = UIPageControl()
            pageControl.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
            pageControl.currentPageIndicatorTintColor = UIColor.blue
            pageControl.pageIndicatorTintColor = UIColor.lightGray
            imageSlideshow.pageIndicator = pageControl
        }
        imageSlideshow.activityIndicator = DefaultActivityIndicator()
        
        var inputs: [InputSource] = []
        for image in images {
            if let imageUrl = image.imageUrl {
                let inputSource = KingfisherSource(url: imageUrl)
                inputs.append(inputSource)
            }
        }
        
        imageSlideshow.setImageInputs(inputs)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onSlideshow))
        imageSlideshow.addGestureRecognizer(recognizer)
    }
    
    @objc func onSlideshow() {
        delegate?.slideShowTapped(cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}


class PostData {
    func loadData(at page: Int, onComplete: @escaping ([Post]) -> Void) {
        
        var posts: [Post] = []
        
        if !Reachability.isConnectedToNetwork() {
            onComplete(posts)
            return
        }
        
        let strLink = Constants.API.GET_POST + "?page_size=\(Constants.PAGE_SIZE)&page=\(page + 1)"
        print(strLink)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            var request = URLRequest(url: URL(string: strLink)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: Constants.REQUEST_TIMEOUT)
            request.httpMethod = "GET"
            
            request.setValue("Bearer \(SettingManager.sharedInstance.token)", forHTTPHeaderField:"Authorization")
            
            URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
                let err = error as NSError?
                guard let data = data, err == nil else {
                    print(err!.localizedDescription)
                    
                    DispatchQueue.main.async {
                        onComplete(posts)
                    }
                    return
                }
                
                do {
                    let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let status = response["status"] as? Bool
                    
                    if status! {
                        if let total = response["total"] as? Int {
                            print("Total Items : \(total)")
                        }
                        // fetch products
                        
                        if let data = response["data"] as? [Dictionary<String, AnyObject>] {
                            for _posts in data {
                                posts.append(Post(_posts))
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        onComplete(posts)
                    }
                } catch let err {
                    print(err.localizedDescription)
                    
                    DispatchQueue.main.async {
                        onComplete(posts)
                    }
                }
            }).resume()
        }
    }
}
